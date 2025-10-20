import { describe, it, expect, beforeEach, afterEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from '../auth'

describe('Auth Store', () => {
  beforeEach(() => {
    // Create a fresh pinia instance for each test
    setActivePinia(createPinia())
    // Clear localStorage before each test
    localStorage.clear()
  })

  afterEach(() => {
    localStorage.clear()
  })

  it('initializes with no token and user', () => {
    const store = useAuthStore()
    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('loads token from localStorage on initialization', () => {
    localStorage.setItem('auth_token', 'test-token-123')
    const store = useAuthStore()
    expect(store.token).toBe('test-token-123')
    expect(store.isAuthenticated).toBe(true)
  })

  it('sets token and persists to localStorage', () => {
    const store = useAuthStore()
    store.setToken('new-token-456')

    expect(store.token).toBe('new-token-456')
    expect(localStorage.getItem('auth_token')).toBe('new-token-456')
    expect(store.isAuthenticated).toBe(true)
  })

  it('clears token from localStorage when set to null', () => {
    const store = useAuthStore()
    store.setToken('token-to-remove')
    expect(localStorage.getItem('auth_token')).toBe('token-to-remove')

    store.setToken(null)
    expect(store.token).toBeNull()
    expect(localStorage.getItem('auth_token')).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('clears all auth data', () => {
    const store = useAuthStore()
    store.setToken('test-token')
    store.user = { id: 1, email: 'test@example.com' }

    store.clearAuth()

    expect(store.token).toBeNull()
    expect(store.user).toBeNull()
    expect(localStorage.getItem('auth_token')).toBeNull()
    expect(store.isAuthenticated).toBe(false)
  })

  it('computes isAuthenticated correctly', () => {
    const store = useAuthStore()
    expect(store.isAuthenticated).toBe(false)

    store.setToken('valid-token')
    expect(store.isAuthenticated).toBe(true)

    store.clearAuth()
    expect(store.isAuthenticated).toBe(false)
  })
})
