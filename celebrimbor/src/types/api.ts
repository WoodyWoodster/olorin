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
  organization: {
    name: string
    subdomain: string
  }
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

// Apps
export interface App {
  id: number
  name: string
  subdomain: string
  git_url?: string
  status: 'stopped' | 'building' | 'running' | 'failed'
  description?: string
  created_at: string
  updated_at: string
}

export interface CreateAppRequest {
  app: {
    name: string
    subdomain: string
    git_url?: string
    branch?: string
    dockerfile_path?: string
    status?: string
    description?: string
  }
}

export interface UpdateAppRequest {
  app: Partial<CreateAppRequest['app']>
}

// Deployments
export interface Deployment {
  id: number
  app_id: number
  commit_sha: string
  status: 'pending' | 'building' | 'deployed' | 'failed' | 'rolled_back'
  build_logs?: string
  deployed_at?: string
  created_at: string
  updated_at: string
}

export interface CreateDeploymentRequest {
  deployment: {
    app_id: number
    commit_sha: string
    status?: string
    build_logs?: string
    deployed_at?: string
  }
}

export interface UpdateDeploymentRequest {
  deployment: Partial<CreateDeploymentRequest['deployment']>
}

// Addons
export interface Addon {
  id: number
  app_id: number
  addon_type: 'postgres' | 'mysql' | 'redis' | 'mongodb'
  name: string
  connection_string?: string
  status: 'provisioning' | 'available' | 'failed' | 'deprovisioning'
  config?: string
  created_at: string
  updated_at: string
}

export interface CreateAddonRequest {
  addon: {
    app_id: number
    addon_type: string
    name: string
    connection_string?: string
    status?: string
    config?: string
  }
}

export interface UpdateAddonRequest {
  addon: Partial<CreateAddonRequest['addon']>
}

// Domains
export interface Domain {
  id: number
  app_id: number
  hostname: string
  ssl_enabled: boolean
  verified_at?: string
  created_at: string
  updated_at: string
}

export interface CreateDomainRequest {
  domain: {
    app_id: number
    hostname: string
    ssl_enabled?: boolean
    verified_at?: string
  }
}

export interface UpdateDomainRequest {
  domain: Partial<CreateDomainRequest['domain']>
}

// Environment Variables
export interface EnvVar {
  id: number
  app_id: number
  key: string
  value?: string
  created_at: string
  updated_at: string
}

export interface CreateEnvVarRequest {
  env_var: {
    app_id: number
    key: string
    value?: string
  }
}

export interface UpdateEnvVarRequest {
  env_var: Partial<CreateEnvVarRequest['env_var']>
}

// Type aliases for form data
export type AppFormData = CreateAppRequest['app']
