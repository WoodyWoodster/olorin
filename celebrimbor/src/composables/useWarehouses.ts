import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Warehouse, CreateWarehouseRequest, UpdateWarehouseRequest } from '../types/api'
import apiClient from '../api/client'

export function useWarehouses(filters?: { is_active?: boolean; search?: string }) {
  return useQuery({
    queryKey: ['warehouses', filters],
    queryFn: async () => {
      const response = await apiClient.get<Warehouse[]>('/api/v1/warehouses', { params: filters })
      return response.data
    }
  })
}

export function useWarehouse(id: number | string) {
  return useQuery({
    queryKey: ['warehouses', id],
    queryFn: async () => {
      const response = await apiClient.get<Warehouse>(`/api/v1/warehouses/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateWarehouse() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateWarehouseRequest) => {
      const response = await apiClient.post<Warehouse>('/api/v1/warehouses', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['warehouses'] })
    }
  })
}

export function useUpdateWarehouse() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateWarehouseRequest }) => {
      const response = await apiClient.patch<Warehouse>(`/api/v1/warehouses/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['warehouses'] })
      queryClient.invalidateQueries({ queryKey: ['warehouses', variables.id] })
    }
  })
}

export function useDeleteWarehouse() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/warehouses/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['warehouses'] })
    }
  })
}
