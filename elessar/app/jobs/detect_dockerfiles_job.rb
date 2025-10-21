class DetectDockerfilesJob < ApplicationJob
  queue_as :default

  def perform(user_id, git_url, branch)
    user = User.find(user_id)

    Dir.mktmpdir do |tmpdir|
      begin
        broadcast_to_user(user, status: "detecting", message: "Cloning repository...")

        repo_path = "#{tmpdir}/repo"

        clone_result = system(
          "git", "clone",
          "--depth", "1",
          "--branch", branch,
          git_url,
          repo_path,
          out: File::NULL,
          err: File::NULL
        )

        unless clone_result
          broadcast_error(user, "Clone Failed", "Could not clone repository from #{git_url}",
                         "Verify the repository URL and branch name are correct, and that you have access.")
          return
        end

        # Find all Dockerfiles
        dockerfiles = find_dockerfiles(repo_path)

        if dockerfiles.empty?
          broadcast_to_user(user, status: "completed")
          return
        end

        # Parse and broadcast each Dockerfile
        dockerfiles.each do |dockerfile_path|
          relative_path = dockerfile_path.gsub("#{repo_path}/", "./")
          parsed_data = parse_dockerfile(dockerfile_path)

          broadcast_to_user(user,
            status: "found",
            dockerfile: {
              path: relative_path,
              base_image: parsed_data[:base_image],
              runtime: parsed_data[:runtime],
              version: parsed_data[:version],
              port: parsed_data[:port],
              start_command: parsed_data[:start_command]
            }
          )
        end

        # Broadcast completion
        broadcast_to_user(user, status: "completed", message: "Found #{dockerfiles.count} Dockerfile(s)")

      rescue StandardError => e
        Rails.logger.error "Dockerfile detection error: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
        broadcast_error(user, "Detection Error", e.message, "Please try again or contact support if the issue persists.")
      end
    end
  end

  private

  def find_dockerfiles(path)
    # Find all files named Dockerfile or Dockerfile.*
    Dir.glob("#{path}/**/Dockerfile*").select { |f| File.file?(f) }.sort_by do |f|
      # Prioritize Dockerfile.prod over regular Dockerfile
      f.include?(".prod") ? 0 : 1
    end
  end

  def parse_dockerfile(path)
    content = File.read(path)

    data = {
      base_image: nil,
      runtime: nil,
      version: nil,
      port: nil,
      start_command: nil
    }

    # Extract FROM instruction (base image)
    if match = content.match(/^FROM\s+([^\s]+)/i)
      data[:base_image] = match[1]

      # Try to detect runtime and version from base image
      detect_runtime_from_image(data[:base_image], data)
    end

    # Extract EXPOSE instruction (port)
    if match = content.match(/^EXPOSE\s+(\d+)/i)
      data[:port] = match[1].to_i
    end

    # Extract CMD or ENTRYPOINT (start command)
    if match = content.match(/^(?:CMD|ENTRYPOINT)\s+(.+)/i)
      data[:start_command] = match[1].strip
    end

    data
  end

  def detect_runtime_from_image(image, data)
    case image.downcase
    when /^node:(.+)/
      data[:runtime] = "Node.js"
      data[:version] = $1.split("-").first
    when /^python:(.+)/
      data[:runtime] = "Python"
      data[:version] = $1.split("-").first
    when /^ruby:(.+)/
      data[:runtime] = "Ruby"
      data[:version] = $1.split("-").first
    when /^golang:(.+)/, /^go:(.+)/
      data[:runtime] = "Go"
      data[:version] = $1.split("-").first
    when /^openjdk:(.+)/, /^java:(.+)/
      data[:runtime] = "Java"
      data[:version] = $1.split("-").first
    when /^php:(.+)/
      data[:runtime] = "PHP"
      data[:version] = $1.split("-").first
    when /^nginx:(.+)/
      data[:runtime] = "Nginx"
      data[:version] = $1.split("-").first
    when /^alpine/, /^ubuntu/, /^debian/
      data[:runtime] = "Linux"
    end
  end

  def broadcast_to_user(user, message)
    DockerfileDetectionChannel.broadcast_to(user, message)
  end

  def broadcast_error(user, title, message, suggestion = nil)
    broadcast_to_user(user, {
      status: "error",
      error: title,
      message: message,
      suggestion: suggestion
    })
  end
end
