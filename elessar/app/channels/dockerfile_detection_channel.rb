class DockerfileDetectionChannel < ApplicationCable::Channel
  def subscribed
    stream_for current_user

    git_url = params[:git_url]
    branch = params[:branch] || 'main'

    if git_url.blank?
      transmit_error('Missing Git URL', 'Please provide a valid Git repository URL.')
      reject
      return
    end

    transmit({ status: 'detecting', message: 'Connecting to repository...' })

    DetectDockerfilesJob.perform_later(current_user.id, git_url, branch)
  end

  def unsubscribed
    stop_all_streams
  end

  private

  def transmit_error(title, message, suggestion = nil)
    data = { status: 'error', error: title, message: message }
    data[:suggestion] = suggestion if suggestion
    transmit(data)
  end
end
