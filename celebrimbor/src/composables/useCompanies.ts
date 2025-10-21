import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { Company, CreateCompanyRequest, UpdateCompanyRequest } from '../types/api'
import apiClient from '../api/client'

export function useCompanies(filters?: { company_type?: string; is_active?: boolean; search?: string }) {
  return useQuery({
    queryKey: ['companies', filters],
    queryFn: async () => {
      const response = await apiClient.get<Company[]>('/api/v1/companies', { params: filters })
      return response.data
    }
  })
}

export function useCompany(id: number | string) {
  return useQuery({
    queryKey: ['companies', id],
    queryFn: async () => {
      const response = await apiClient.get<Company>(`/api/v1/companies/${id}`)
      return response.data
    },
    enabled: !!id
  })
}

export function useCreateCompany() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: CreateCompanyRequest) => {
      const response = await apiClient.post<Company>('/api/v1/companies', data)
      return response.data
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['companies'] })
    }
  })
}

export function useUpdateCompany() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async ({ id, data }: { id: number; data: UpdateCompanyRequest }) => {
      const response = await apiClient.patch<Company>(`/api/v1/companies/${id}`, data)
      return response.data
    },
    onSuccess: (_, variables) => {
      queryClient.invalidateQueries({ queryKey: ['companies'] })
      queryClient.invalidateQueries({ queryKey: ['companies', variables.id] })
    }
  })
}

export function useDeleteCompany() {
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (id: number) => {
      await apiClient.delete(`/api/v1/companies/${id}`)
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['companies'] })
    }
  })
}
