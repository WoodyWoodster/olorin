import { useMutation, useQuery, useQueryClient } from '@tanstack/vue-query'
import type { LoginRequest, LoginResponse, RegisterRequest, RegisterResponse, UserProfileResponse } from '../types/api'
import apiClient from '../api/client'
import { useAuthStore } from '../stores/auth'

export function useLogin() {
  const authStore = useAuthStore()
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (credentials: { email: string; password: string }) => {
      const response = await apiClient.post<LoginResponse>('/api/auth/login', {
        user: credentials
      } as LoginRequest)

      const token = response.headers['authorization']?.split(' ')[1]
      if (!token) {
        throw new Error('No token received from server')
      }

      return { token, user: response.data.user }
    },
    onSuccess: (data) => {
      authStore.setToken(data.token)
      authStore.user = data.user
      queryClient.invalidateQueries({ queryKey: ['currentUser'] })
    },
    onError: (error: unknown) => {
      console.error('Login error:', error)
    }
  })
}

export function useRegister() {
  const authStore = useAuthStore()
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async (data: {
      organization: { name: string; subdomain: string }
      email: string
      password: string
      password_confirmation: string
    }) => {
      const response = await apiClient.post<RegisterResponse>('/api/auth/signup', {
        organization: data.organization,
        user: {
          email: data.email,
          password: data.password,
          password_confirmation: data.password_confirmation
        }
      } as RegisterRequest)

      const token = response.headers['authorization']?.split(' ')[1]
      if (!token) {
        throw new Error('No token received from server')
      }

      return { token, user: response.data.user }
    },
    onSuccess: (data) => {
      authStore.setToken(data.token)
      authStore.user = data.user
      queryClient.invalidateQueries({ queryKey: ['currentUser'] })
    },
    onError: (error: unknown) => {
      console.error('Registration error:', error)
    }
  })
}

export function useLogout() {
  const authStore = useAuthStore()
  const queryClient = useQueryClient()

  return useMutation({
    mutationFn: async () => {
      await apiClient.delete('/api/auth/logout')
    },
    onSuccess: () => {
      authStore.clearAuth()
      queryClient.clear()
    },
    onError: (error: unknown) => {
      // Even if API call fails, clear local auth
      console.error('Logout error:', error)
      authStore.clearAuth()
      queryClient.clear()
    }
  })
}

export function useCurrentUser() {
  const authStore = useAuthStore()

  return useQuery({
    queryKey: ['currentUser'],
    queryFn: async () => {
      const response = await apiClient.get<UserProfileResponse>('/api/v1/me')
      const user = response.data.user
      authStore.user = user
      return user
    },
    enabled: !!authStore.token,
    staleTime: 5 * 60 * 1000, // 5 minutes
    retry: false
  })
}
