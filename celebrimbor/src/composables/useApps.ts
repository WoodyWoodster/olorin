import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { App, CreateAppRequest, UpdateAppRequest } from '../types/api'
import apiClient from '../api/client'

export function useApps(filters?: { status?: string; search?: string }) {
  return useQuery({
    queryKey: ['apps', filters],
    queryFn: async () => {
      const response = await apiClient.get<App[]>('/api/v1/apps', { params: filters })
      return response.data
    }
  })
}

export function useApp(id: number | string) {
  return useQuery({
    queryKey: ['apps', id],
    queryFn: async () => {
      const response = await apiClient.get<App>(`/api/v1/apps/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateApp() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateAppRequest) => {
      const response = await apiClient.post<App>('/api/v1/apps', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useUpdateApp() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateAppRequest }) => {
      const response = await apiClient.patch<App>(`/api/v1/apps/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['apps'] })
      queryClient.invalidateQueries({ queryKey: ['apps', variables.id] })
    }
  })
}

export function useDeleteApp() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/apps/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}
