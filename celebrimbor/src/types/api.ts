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

// Products
export interface Product {
  id: number
  sku: string
  name: string
  description?: string
  product_type: 'raw_material' | 'component' | 'finished_good' | 'service'
  unit_of_measure: string
  cost?: number
  price?: number
  is_manufactured: boolean
  is_active: boolean
  created_at: string
  updated_at: string
}

export interface CreateProductRequest {
  product: {
    sku: string
    name: string
    description?: string
    product_type: string
    unit_of_measure: string
    cost?: number
    price?: number
    is_manufactured?: boolean
    is_active?: boolean
  }
}

export interface UpdateProductRequest {
  product: Partial<CreateProductRequest['product']>
}

// Companies
export interface Address {
  id: number
  address_type: 'billing' | 'shipping' | 'warehouse' | 'other'
  street: string
  street2?: string
  city: string
  state?: string
  postal_code?: string
  country: string
  full_address: string
  single_line_address: string
  created_at: string
  updated_at: string
}

export interface Contact {
  id: number
  first_name?: string
  last_name?: string
  email?: string
  phone?: string
  mobile?: string
  role?: string
  is_primary: boolean
  full_name: string
  company_id?: number
  created_at: string
  updated_at: string
}

export interface Company {
  id: number
  name: string
  company_type: 'customer' | 'supplier' | 'both'
  tax_id?: string
  website?: string
  phone?: string
  email?: string
  is_active: boolean
  contacts?: Contact[]
  addresses?: Address[]
  created_at: string
  updated_at: string
}

export interface CreateCompanyRequest {
  company: {
    name: string
    company_type: string
    tax_id?: string
    website?: string
    phone?: string
    email?: string
    is_active?: boolean
  }
}

export interface UpdateCompanyRequest {
  company: Partial<CreateCompanyRequest['company']>
}

// Warehouses
export interface Warehouse {
  id: number
  code: string
  name: string
  is_active: boolean
  addresses?: Address[]
  created_at: string
  updated_at: string
}

export interface CreateWarehouseRequest {
  warehouse: {
    code: string
    name: string
    is_active?: boolean
  }
}

export interface UpdateWarehouseRequest {
  warehouse: Partial<CreateWarehouseRequest['warehouse']>
}
