<template>
  <div class="min-h-screen bg-slate-50">
    <Navbar />

    <main class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8 py-8">
      <!-- Welcome Section -->
      <div class="mb-8">
        <h1 class="text-3xl font-bold text-slate-900">Welcome back!</h1>
        <p class="text-slate-600 mt-1">Here's what's happening with your account today.</p>
      </div>

      <!-- Loading State -->
      <div v-if="userQuery.isLoading.value" class="space-y-6">
        <div class="grid gap-6 md:grid-cols-3">
          <Card v-for="i in 3" :key="i">
            <CardContent class="pt-6">
              <Skeleton class="h-20 w-full" />
            </CardContent>
          </Card>
        </div>
      </div>

      <!-- Error State -->
      <Alert v-else-if="userQuery.error.value" variant="destructive" class="mb-6">
        <AlertCircle class="h-4 w-4" />
        <AlertTitle>Error</AlertTitle>
        <AlertDescription>
          Failed to load user data. Please try refreshing the page.
        </AlertDescription>
      </Alert>

      <!-- Main Content -->
      <div v-else class="space-y-6">
        <!-- Stats Cards -->
        <div class="grid gap-6 md:grid-cols-3">
          <StatsCard
            title="Total Sign-ins"
            :value="user?.sign_in_count || 0"
            subtitle="Lifetime account activity"
            :icon="Activity"
            icon-class="text-emerald-600"
            icon-bg-class="bg-emerald-100"
          />

          <StatsCard
            title="Last Sign-in"
            :value="lastSignInText"
            :subtitle="lastSignInDate"
            :icon="Clock"
            icon-class="text-blue-600"
            icon-bg-class="bg-blue-100"
          />

          <StatsCard
            title="Account Status"
            value="Active"
            subtitle="Good standing"
            :icon="CheckCircle2"
            icon-class="text-indigo-600"
            icon-bg-class="bg-indigo-100"
          />
        </div>

        <!-- User Profile & Activity -->
        <div class="grid gap-6 lg:grid-cols-2">
          <UserProfileCard :user="user ?? null" />

          <Card>
            <CardHeader>
              <CardTitle>Recent Activity</CardTitle>
              <CardDescription>Your recent sign-in history</CardDescription>
            </CardHeader>
            <CardContent>
              <div class="space-y-4">
                <div v-if="user?.current_sign_in_at" class="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                  <div class="flex items-center space-x-3">
                    <div class="flex-shrink-0">
                      <div class="w-10 h-10 bg-indigo-100 rounded-full flex items-center justify-center">
                        <LogIn class="w-5 h-5 text-indigo-600" />
                      </div>
                    </div>
                    <div>
                      <p class="text-sm font-medium text-slate-900">Current Session</p>
                      <p class="text-xs text-slate-500">{{ formatDateTime(user.current_sign_in_at) }}</p>
                    </div>
                  </div>
                  <Badge>Active</Badge>
                </div>

                <div v-if="user?.last_sign_in_at" class="flex items-center justify-between p-3 bg-slate-50 rounded-lg">
                  <div class="flex items-center space-x-3">
                    <div class="flex-shrink-0">
                      <div class="w-10 h-10 bg-slate-100 rounded-full flex items-center justify-center">
                        <History class="w-5 h-5 text-slate-600" />
                      </div>
                    </div>
                    <div>
                      <p class="text-sm font-medium text-slate-900">Previous Session</p>
                      <p class="text-xs text-slate-500">{{ formatDateTime(user.last_sign_in_at) }}</p>
                    </div>
                  </div>
                  <Badge variant="outline">Ended</Badge>
                </div>

                <div v-if="!user?.current_sign_in_at && !user?.last_sign_in_at" class="text-center py-8 text-slate-500">
                  <History class="w-12 h-12 mx-auto mb-3 text-slate-300" />
                  <p class="text-sm">No activity history available</p>
                </div>
              </div>
            </CardContent>
            <CardFooter class="border-t bg-slate-50">
              <Button variant="ghost" class="w-full" @click="refreshData" :disabled="userQuery.isRefetching.value">
                <RefreshCw :class="['mr-2 h-4 w-4', { 'animate-spin': userQuery.isRefetching.value }]" />
                {{ userQuery.isRefetching.value ? 'Refreshing...' : 'Refresh Data' }}
              </Button>
            </CardFooter>
          </Card>
        </div>

        <!-- Authentication Info -->
        <Card>
          <CardHeader>
            <CardTitle>Authentication Details</CardTitle>
            <CardDescription>Security and session information</CardDescription>
          </CardHeader>
          <CardContent>
            <div class="grid gap-4 md:grid-cols-2">
              <div class="space-y-2">
                <Label class="text-slate-600">JWT Token</Label>
                <div class="flex items-center space-x-2">
                  <code class="flex-1 px-3 py-2 text-xs bg-slate-100 border border-slate-200 rounded font-mono truncate">
                    {{ authStore.token?.substring(0, 40) }}...
                  </code>
                  <Button variant="outline" size="sm">
                    <Copy class="h-4 w-4" />
                  </Button>
                </div>
              </div>
              <div class="space-y-2">
                <Label class="text-slate-600">Session Status</Label>
                <div class="flex items-center space-x-2 px-3 py-2 bg-emerald-50 border border-emerald-200 rounded">
                  <CheckCircle2 class="h-5 w-5 text-emerald-600" />
                  <span class="text-sm font-medium text-emerald-900">Authenticated</span>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Activity, Clock, CheckCircle2, LogIn, History, RefreshCw, Copy, AlertCircle } from 'lucide-vue-next'
import Navbar from '@/components/layout/Navbar.vue'
import StatsCard from '@/components/dashboard/StatsCard.vue'
import UserProfileCard from '@/components/dashboard/UserProfileCard.vue'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Button } from '@/components/ui/button'
import { Label } from '@/components/ui/label'
import { Skeleton } from '@/components/ui/skeleton'
import { Alert, AlertDescription, AlertTitle } from '@/components/ui/alert'
import { useCurrentUser } from '@/composables/useAuth'
import { useAuthStore } from '@/stores/auth'

const authStore = useAuthStore()
const userQuery = useCurrentUser()

const user = computed(() => userQuery.data.value)

const lastSignInText = computed(() => {
  if (!user.value?.last_sign_in_at) return 'Never'
  const date = new Date(user.value.last_sign_in_at)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffMins = Math.floor(diffMs / 60000)
  const diffHours = Math.floor(diffMins / 60)
  const diffDays = Math.floor(diffHours / 24)

  if (diffMins < 60) return `${diffMins}m ago`
  if (diffHours < 24) return `${diffHours}h ago`
  return `${diffDays}d ago`
})

const lastSignInDate = computed(() => {
  if (!user.value?.last_sign_in_at) return ''
  return new Date(user.value.last_sign_in_at).toLocaleDateString('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
})

function formatDateTime(dateString: string | null) {
  if (!dateString) return 'N/A'
  return new Date(dateString).toLocaleString('en-US', {
    month: 'short',
    day: 'numeric',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}

function refreshData() {
  userQuery.refetch()
}
</script>
