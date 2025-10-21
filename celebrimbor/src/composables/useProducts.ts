import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Product, CreateProductRequest, UpdateProductRequest } from '../types/api'
import apiClient from '../api/client'

export function useProducts(filters?: { product_type?: string; is_active?: boolean; search?: string }) {
  return useQuery({
    queryKey: ['products', filters],
    queryFn: async () => {
      const response = await apiClient.get<Product[]>('/api/v1/products', { params: filters })
      return response.data
    }
  })
}

export function useProduct(id: number | string) {
  return useQuery({
    queryKey: ['products', id],
    queryFn: async () => {
      const response = await apiClient.get<Product>(`/api/v1/products/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateProduct() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateProductRequest) => {
      const response = await apiClient.post<Product>('/api/v1/products', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['products'] })
    }
  })
}

export function useUpdateProduct() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateProductRequest }) => {
      const response = await apiClient.patch<Product>(`/api/v1/products/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['products'] })
      queryClient.invalidateQueries({ queryKey: ['products', variables.id] })
    }
  })
}

export function useDeleteProduct() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/products/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['products'] })
    }
  })
}
