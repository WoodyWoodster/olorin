export interface User {
  id: number
  email: string
  created_at?: string
  sign_in_count?: number
  current_sign_in_at?: string | null
  last_sign_in_at?: string | null
  current_sign_in_ip?: string | null
  last_sign_in_ip?: string | null
}

export interface LoginRequest {
  user: {
    email: string
    password: string
  }
}

export interface LoginResponse {
  message: string
  user: User
}

export interface RegisterRequest {
  user: {
    email: string
    password: string
    password_confirmation: string
  }
}

export interface RegisterResponse {
  message: string
  user: User
}

export interface UserProfileResponse {
  user: User
}

export interface ApiError {
  message: string
  errors?: Record<string, string[]>
}
