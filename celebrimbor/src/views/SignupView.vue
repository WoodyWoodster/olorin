<template>
  <div class="min-h-screen flex items-center justify-center bg-gradient-to-br from-stone-50 via-white to-stone-100 px-4 py-12">
    <div class="w-full max-w-md">
      <!-- Company Branding -->
      <div class="text-center mb-8">
        <div class="inline-flex items-center justify-center w-16 h-16 bg-orange-600 rounded-xl mb-4">
          <svg class="w-8 h-8 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
          </svg>
        </div>
        <h1 class="text-3xl font-bold text-stone-900 mb-2">Olorin PaaS</h1>
        <p class="text-stone-600">Enterprise Resource Planning</p>
      </div>

      <!-- Signup Card -->
      <Card class="border-stone-200 shadow-xl">
        <CardHeader class="space-y-1 pb-6">
          <CardTitle class="text-2xl font-bold text-center text-stone-900">Create your organization</CardTitle>
          <CardDescription class="text-center text-stone-600">
            Set up your organization and admin account
          </CardDescription>
        </CardHeader>

        <CardContent>
          <form @submit.prevent="handleSignup" class="space-y-4">
            <!-- Error Alert -->
            <Alert v-if="registerMutation.error.value" variant="destructive" class="mb-4">
              <AlertCircle class="h-4 w-4" />
              <AlertTitle>Error</AlertTitle>
              <AlertDescription>
                {{ errorMessage }}
              </AlertDescription>
            </Alert>

            <!-- Organization Name Input -->
            <div class="space-y-2">
              <Label for="organization_name" class="text-stone-700 font-medium">Organization Name</Label>
              <div class="relative">
                <Building class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-stone-400" />
                <Input
                  id="organization_name"
                  v-model="organizationName"
                  type="text"
                  placeholder="Acme Inc."
                  required
                  class="pl-10 h-11 border-stone-300 focus:border-orange-500 focus:ring-orange-500"
                  :disabled="registerMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Organization Subdomain Input -->
            <div class="space-y-2">
              <Label for="subdomain" class="text-stone-700 font-medium">Subdomain</Label>
              <div class="relative">
                <Globe class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-stone-400" />
                <Input
                  id="subdomain"
                  v-model="subdomain"
                  type="text"
                  placeholder="acme"
                  required
                  pattern="[a-z0-9-]+"
                  class="pl-10 h-11 border-stone-300 focus:border-orange-500 focus:ring-orange-500"
                  :disabled="registerMutation.isPending.value"
                />
              </div>
              <p class="text-xs text-stone-500">Lowercase letters, numbers, and hyphens only</p>
            </div>

            <div class="border-t border-stone-200 my-4"></div>

            <!-- Email Input -->
            <div class="space-y-2">
              <Label for="email" class="text-stone-700 font-medium">Email address</Label>
              <div class="relative">
                <Mail class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-stone-400" />
                <Input
                  id="email"
                  v-model="email"
                  type="email"
                  placeholder="you@example.com"
                  required
                  class="pl-10 h-11 border-stone-300 focus:border-orange-500 focus:ring-orange-500"
                  :disabled="registerMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Password Input -->
            <div class="space-y-2">
              <Label for="password" class="text-stone-700 font-medium">Password</Label>
              <div class="relative">
                <Lock class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-stone-400" />
                <Input
                  id="password"
                  v-model="password"
                  type="password"
                  placeholder="••••••••"
                  required
                  class="pl-10 h-11 border-stone-300 focus:border-orange-500 focus:ring-orange-500"
                  :disabled="registerMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Password Confirmation Input -->
            <div class="space-y-2">
              <Label for="password_confirmation" class="text-stone-700 font-medium">Confirm Password</Label>
              <div class="relative">
                <Lock class="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-stone-400" />
                <Input
                  id="password_confirmation"
                  v-model="passwordConfirmation"
                  type="password"
                  placeholder="••••••••"
                  required
                  class="pl-10 h-11 border-stone-300 focus:border-orange-500 focus:ring-orange-500"
                  :disabled="registerMutation.isPending.value"
                />
              </div>
            </div>

            <!-- Submit Button -->
            <Button
              type="submit"
              class="w-full h-11 bg-orange-600 hover:bg-orange-700 text-white font-semibold shadow-lg hover:shadow-xl transition-all"
              :disabled="registerMutation.isPending.value"
            >
              <Loader2 v-if="registerMutation.isPending.value" class="mr-2 h-4 w-4 animate-spin" />
              <span v-else>Create Account</span>
            </Button>
          </form>
        </CardContent>

        <CardFooter class="flex flex-col space-y-4 border-t border-stone-100 pt-6">
          <div class="text-sm text-center text-stone-600">
            Already have an account?
            <router-link to="/login" class="text-orange-600 hover:text-orange-700 font-semibold">Sign in</router-link>
          </div>
        </CardFooter>
      </Card>

      <!-- Footer -->
      <div class="mt-8 text-center text-sm text-stone-500">
        <p>&copy; 2025 Olorin PaaS. All rights reserved.</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { Mail, Lock, Loader2, AlertCircle, Building, Globe } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { useRegister } from '@/composables/useAuth'
import axios from 'axios'

const router = useRouter()
const registerMutation = useRegister()

const organizationName = ref('')
const subdomain = ref('')
const email = ref('')
const password = ref('')
const passwordConfirmation = ref('')

const errorMessage = computed(() => {
  const error = registerMutation.error.value
  if (!error) return ''

  // Check if it's an Axios error with response data
  if (axios.isAxiosError(error) && error.response?.data?.message) {
    return error.response.data.message
  }

  return 'Registration failed. Please try again.'
})

async function handleSignup() {
  try {
    await registerMutation.mutateAsync({
      organization: {
        name: organizationName.value,
        subdomain: subdomain.value
      },
      email: email.value,
      password: password.value,
      password_confirmation: passwordConfirmation.value
    })
    router.push('/dashboard')
  } catch (error) {
    // Error is handled by the mutation
    console.error('Signup failed:', error)
  }
}
</script>
