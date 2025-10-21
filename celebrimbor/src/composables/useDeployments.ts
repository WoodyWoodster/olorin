import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Deployment, CreateDeploymentRequest, UpdateDeploymentRequest } from '../types/api'
import apiClient from '../api/client'

export function useDeployments(filters?: { app_id?: number; status?: string }) {
  return useQuery({
    queryKey: ['deployments', filters],
    queryFn: async () => {
      const response = await apiClient.get<Deployment[]>('/api/v1/deployments', { params: filters })
      return response.data
    }
  })
}

export function useDeployment(id: number | string) {
  return useQuery({
    queryKey: ['deployments', id],
    queryFn: async () => {
      const response = await apiClient.get<Deployment>(`/api/v1/deployments/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateDeployment() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateDeploymentRequest) => {
      const response = await apiClient.post<Deployment>('/api/v1/deployments', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['deployments'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useUpdateDeployment() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateDeploymentRequest }) => {
      const response = await apiClient.patch<Deployment>(`/api/v1/deployments/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['deployments'] })
      queryClient.invalidateQueries({ queryKey: ['deployments', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useDeleteDeployment() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/deployments/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['deployments'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}
