<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-slate-50 via-white to-slate-100 px-4 py-12">
    <div class="w-full max-w-md">
      <!-- Company Branding -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-indigo-600 rounded-xl mb-4">
          <svg class="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
          </svg>
        </div>
        <h1 class="text-3xl font-bold text-slate-900 mb-2">Olorin ERP</h1>
        <p class="text-slate-600">Enterprise Resource Planning</p>
      </div>

      <!-- Login Card -->
      <Card class="border-slate-200 shadow-xl">
        <CardHeader class="space-y-1 pb-6">
          <CardTitle class="text-2xl font-bold text-center text-slate-900">Sign in to your account</CardTitle>
          <CardDescription class="text-center text-slate-600">
            Enter your credentials to access your dashboard
          </CardDescription>
        </CardHeader>

        <CardContent>
          <form @submit.prevent="handleLogin" class="space-y-4">
            <!-- Error Alert -->
            <Alert v-if="loginMutation.error.value" variant="destructive" class="mb-4">
              <AlertCircle class="h-4 w-4" />
              <AlertTitle>Error</AlertTitle>
              <AlertDescription>
                {{  loginMutation.error.value?.response?.data?.message || 'Login failed. Please try again.' }}
              </AlertDescription>
            </Alert>

            <!-- Email Input -->
            <div class="space-y-2">
              <Label for="email" class="text-slate-700 font-medium">Email address</Label>
              <div class="relative">
                <Mail class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
                <Input
                  id="email"
                  v-model="email"
                  type="email"
                  placeholder="you@example.com"
                  required
                  class="pl-10 h-11 border-slate-300 focus:border-indigo-500 focus:ring-indigo-500"
                  :disabled="loginMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Password Input -->
            <div class="space-y-2">
              <div class="flex items-center justify-between">
                <Label for="password" class="text-slate-700 font-medium">Password</Label>
                <a href="#" class="text-sm text-indigo-600 hover:text-indigo-700 font-medium">
                  Forgot password?
                </a>
              </div>
              <div class="relative">
                <Lock class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-slate-400" />
                <Input
                  id="password"
                  v-model="password"
                  type="password"
                  placeholder="••••••••"
                  required
                  class="pl-10 h-11 border-slate-300 focus:border-indigo-500 focus:ring-indigo-500"
                  :disabled="loginMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Remember Me -->
            <div class="flex items-center space-x-2">
              <input
                type="checkbox"
                id="remember"
                class="h-4 w-4 rounded border-slate-300 text-indigo-600 focus:ring-indigo-500"
              />
              <Label for="remember" class="text-sm text-slate-600 font-normal cursor-pointer">
                Remember me for 30 days
              </Label>
            </div>

            <!-- Submit Button -->
            <Button
              type="submit"
              class="w-full h-11 bg-indigo-600 hover:bg-indigo-700 text-white font-semibold shadow-lg hover:shadow-xl transition-all"
              :disabled="loginMutation.isPending.value"
            >
              <Loader2 v-if="loginMutation.isPending.value" class="mr-2 h-4 w-4 animate-spin" />
              <span v-else>Sign in</span>
            </Button>
          </form>

          <!-- Test Credentials Info -->
          <div class="mt-6 p-3 bg-slate-50 border border-slate-200 rounded-lg">
            <p class="text-xs text-slate-600 text-center">
              <span class="font-semibold">Test credentials:</span> test@example.com / password
            </p>
          </div>
        </CardContent>

        <CardFooter class="flex flex-col space-y-4 border-t border-slate-100 pt-6">
          <div class="text-sm text-center text-slate-600">
            Don't have an account?
            <a href="#" class="text-indigo-600 hover:text-indigo-700 font-semibold">Sign up</a>
          </div>
        </CardFooter>
      </Card>

      <!-- Footer -->
      <div class="mt-8 text-center text-sm text-slate-500">
        <p>&copy; 2025 Olorin ERP. All rights reserved.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Mail, Lock, Loader2, AlertCircle } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { useLogin } from '@/composables/useAuth'

const router = useRouter()
const loginMutation = useLogin()

const email = ref('test@example.com')
const password = ref('password')

async function handleLogin() {
  try {
    await loginMutation.mutateAsync({
      email: email.value,
      password: password.value
    })
    router.push('/dashboard')
  } catch (error) {
    // Error is handled by the mutation
    console.error('Login failed:', error)
  }
}
</script>
