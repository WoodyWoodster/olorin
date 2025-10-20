<template>
  <nav class="sticky top-0 z-50 bg-white border-b border-slate-200 shadow-sm">
    <div class="mx-auto max-w-7xl px-4 sm:px-6 lg:px-8">
      <div class="flex h-16 justify-between items-center">
        <!-- Logo & Brand -->
        <div class="flex items-center space-x-3">
          <div class="flex items-center justify-center w-10 h-10 bg-indigo-600 rounded-lg">
            <svg class="w-6 h-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </div>
          <div>
            <h1 class="text-xl font-bold text-slate-900">Olorin ERP</h1>
            <p class="text-xs text-slate-500">Enterprise Dashboard</p>
          </div>
        </div>

        <!-- User Menu -->
        <div class="flex items-center space-x-4">
          <DropdownMenu>
            <DropdownMenuTrigger as-child>
              <Button variant="ghost" class="relative flex items-center space-x-3 hover:bg-slate-100">
                <Avatar>
                  <AvatarFallback class="bg-indigo-600 text-white font-semibold">
                    {{ userInitials }}
                  </AvatarFallback>
                </Avatar>
                <div class="hidden md:block text-left">
                  <p class="text-sm font-semibold text-slate-900">{{ user?.email }}</p>
                  <p class="text-xs text-slate-500">Administrator</p>
                </div>
                <ChevronDown class="h-4 w-4 text-slate-500" />
              </Button>
            </DropdownMenuTrigger>
            <DropdownMenuContent align="end" class="w-56">
              <DropdownMenuLabel>My Account</DropdownMenuLabel>
              <DropdownMenuSeparator />
              <DropdownMenuItem>
                <User class="mr-2 h-4 w-4" />
                <span>Profile</span>
              </DropdownMenuItem>
              <DropdownMenuItem>
                <Settings class="mr-2 h-4 w-4" />
                <span>Settings</span>
              </DropdownMenuItem>
              <DropdownMenuSeparator />
              <DropdownMenuItem @click="handleLogout" :disabled="logoutMutation.isPending.value">
                <LogOut class="mr-2 h-4 w-4" />
                <span>{{ logoutMutation.isPending.value ? 'Logging out...' : 'Log out' }}</span>
              </DropdownMenuItem>
            </DropdownMenuContent>
          </DropdownMenu>
        </div>
      </div>
    </div>
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { ChevronDown, User, Settings, LogOut } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import {
  DropdownMenu,
  DropdownMenuContent,
  DropdownMenuItem,
  DropdownMenuLabel,
  DropdownMenuSeparator,
  DropdownMenuTrigger,
} from '@/components/ui/dropdown-menu'
import { useAuthStore } from '@/stores/auth'
import { useLogout } from '@/composables/useAuth'

const router = useRouter()
const authStore = useAuthStore()
const logoutMutation = useLogout()

const user = computed(() => authStore.user)

const userInitials = computed(() => {
  if (!user.value?.email) return 'U'
  const email = user.value.email
  const parts = email.split('@')[0]?.split('.')
  const first = parts?.[0]?.[0]
  const second = parts?.[1]?.[0]
  if (first && second) {
    return (first + second).toUpperCase()
  }
  return email.slice(0, 2).toUpperCase()
})

async function handleLogout() {
  try {
    await logoutMutation.mutateAsync()
    router.push('/login')
  } catch (error) {
    console.error('Logout failed:', error)
  }
}
</script>
