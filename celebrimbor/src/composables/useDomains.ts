import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Domain, CreateDomainRequest, UpdateDomainRequest } from '../types/api'
import apiClient from '../api/client'

export function useDomains(filters?: { app_id?: number }) {
  return useQuery({
    queryKey: ['domains', filters],
    queryFn: async () => {
      const response = await apiClient.get<Domain[]>('/api/v1/domains', { params: filters })
      return response.data
    }
  })
}

export function useDomain(id: number | string) {
  return useQuery({
    queryKey: ['domains', id],
    queryFn: async () => {
      const response = await apiClient.get<Domain>(`/api/v1/domains/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateDomain() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateDomainRequest) => {
      const response = await apiClient.post<Domain>('/api/v1/domains', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['domains'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useUpdateDomain() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateDomainRequest }) => {
      const response = await apiClient.patch<Domain>(`/api/v1/domains/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['domains'] })
      queryClient.invalidateQueries({ queryKey: ['domains', variables.id] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}

export function useDeleteDomain() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/domains/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['domains'] })
      queryClient.invalidateQueries({ queryKey: ['apps'] })
    }
  })
}
