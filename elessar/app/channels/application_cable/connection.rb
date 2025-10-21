module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Try JWT token from query parameter (for WebSocket connections)
      if verified_user = find_user_from_jwt
        logger.info "ActionCable: User authenticated via JWT: #{verified_user.email}"
        return verified_user
      end

      # Try session-based authentication (fallback)
      if verified_user = find_user_from_session
        logger.info "ActionCable: User authenticated via session: #{verified_user.email}"
        return verified_user
      end

      # In development, allow connections with first available user
      if Rails.env.development?
        user = User.first
        if user
          logger.info "ActionCable: Development mode - using user: #{user.email}"
          return user
        else
          logger.error "ActionCable: No users found in database"
          reject_unauthorized_connection
        end
      end

      # Production requires authentication
      logger.warn "ActionCable: Authentication failed - rejecting connection"
      reject_unauthorized_connection
    end

    def find_user_from_jwt
      # Try to get token from httpOnly cookie first (most secure)
      token = cookies.encrypted[:jwt_token]

      # Fallback to query parameter for backward compatibility
      token ||= request.params[:token]

      return nil unless token

      begin
        secret_key = ENV["DEVISE_JWT_SECRET_KEY"] || Rails.application.credentials.secret_key_base
        decoded_token = JWT.decode(token, secret_key, true, { algorithm: "HS256" })

        user_id = decoded_token[0]["sub"]

        jti = decoded_token[0]["jti"]
        return nil if JwtDenylist.exists?(jti: jti)

        User.find_by(id: user_id)
      rescue JWT::DecodeError, JWT::ExpiredSignature => e
        logger.warn "ActionCable: JWT decode error: #{e.message}"
        nil
      end
    end

    def find_user_from_session
      session_key = Rails.application.config.session_options[:key]
      session_cookie = cookies.encrypted[session_key]

      return nil unless session_cookie

      if warden_data = session_cookie["warden.user.user.key"]
        user_id = extract_user_id_from_warden(warden_data)
        User.find_by(id: user_id) if user_id
      end
    end

    def extract_user_id_from_warden(warden_data)
      return warden_data[0][0] if warden_data.is_a?(Array) && warden_data[0].is_a?(Array)
      return warden_data[0] if warden_data.is_a?(Array)
      warden_data
    end
  end
end
