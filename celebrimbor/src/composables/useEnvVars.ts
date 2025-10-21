import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { EnvVar, CreateEnvVarRequest, UpdateEnvVarRequest } from '../types/api'
import apiClient from '../api/client'

export function useEnvVars(filters?: { app_id?: number }) {
  return useQuery({
    queryKey: ['env_vars', filters],
    queryFn: async () => {
      const response = await apiClient.get<EnvVar[]>('/api/v1/env_vars', { params: filters })
      return response.data
    }
  })
}

export function useEnvVar(id: number | string) {
  return useQuery({
    queryKey: ['env_vars', id],
    queryFn: async () => {
      const response = await apiClient.get<EnvVar>(`/api/v1/env_vars/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateEnvVar() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateEnvVarRequest) => {
      const response = await apiClient.post<EnvVar>('/api/v1/env_vars', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['env_vars'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useUpdateEnvVar() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateEnvVarRequest }) => {
      const response = await apiClient.patch<EnvVar>(`/api/v1/env_vars/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['env_vars'] })
      queryClient.invalidateQueries({ queryKey: ['env_vars', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useDeleteEnvVar() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/env_vars/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['env_vars'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}
