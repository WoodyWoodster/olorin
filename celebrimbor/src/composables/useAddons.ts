import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Addon, CreateAddonRequest, UpdateAddonRequest } from '../types/api'
import apiClient from '../api/client'

export function useAddons(filters?: { app_id?: number; addon_type?: string; status?: string }) {
  return useQuery({
    queryKey: ['addons', filters],
    queryFn: async () => {
      const response = await apiClient.get<Addon[]>('/api/v1/addons', { params: filters })
      return response.data
    }
  })
}

export function useAddon(id: number | string) {
  return useQuery({
    queryKey: ['addons', id],
    queryFn: async () => {
      const response = await apiClient.get<Addon>(`/api/v1/addons/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateAddon() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateAddonRequest) => {
      const response = await apiClient.post<Addon>('/api/v1/addons', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['addons'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useUpdateAddon() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateAddonRequest }) => {
      const response = await apiClient.patch<Addon>(`/api/v1/addons/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['addons'] })
      queryClient.invalidateQueries({ queryKey: ['addons', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useDeleteAddon() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/addons/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['addons'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}
