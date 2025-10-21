<template>
  <nav class="sticky top-0 z-30 border-b border-stone-200 bg-white shadow-sm">
    <div class="flex h-16 items-center justify-between px-4 sm:px-6 lg:px-8">
      <!-- Left Section: Hamburger + Logo + Command Palette -->
      <div class="flex items-center space-x-4">
        <!-- Hamburger Menu -->
        <button
          @click="$emit('toggleSidebar')"
          class="rounded-lg p-2 text-stone-600 hover:bg-stone-100"
        >
          <Menu class="h-5 w-5" />
        </button>

        <!-- Logo -->
        <div class="flex items-center space-x-3">
          <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-orange-600">
            <svg class="h-5 w-5 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
            </svg>
          </div>
          <h1 class="hidden text-lg font-bold text-stone-900 sm:block">Olorin PaaS</h1>
        </div>

        <!-- Command Palette Trigger -->
        <button
          @click="$emit('openCommandPalette')"
          class="flex items-center space-x-2 rounded-lg border border-stone-300 bg-stone-50 px-3 py-1.5 text-sm text-stone-600 transition-colors hover:bg-stone-100"
        >
          <Search class="h-4 w-4" />
          <span class="hidden sm:inline">Search or jump to...</span>
          <kbd class="hidden rounded bg-white px-1.5 py-0.5 text-xs text-stone-500 sm:inline">⌘K</kbd>
        </button>
      </div>

      <!-- Right Section: User Menu -->
      <div class="flex items-center space-x-4">
        <DropdownMenu>
          <DropdownMenuTrigger as-child>
            <Button
              variant="ghost"
              class="relative flex items-center space-x-3 hover:bg-stone-100"
            >
              <Avatar>
                <AvatarFallback class="bg-orange-600 font-semibold text-white">
                  {{ userInitials }}
                </AvatarFallback>
              </Avatar>
              <div class="hidden text-left md:block">
                <p class="text-sm font-semibold text-stone-900">{{ user?.email }}</p>
                <p class="text-xs text-stone-500">Administrator</p>
              </div>
              <ChevronDown class="h-4 w-4 text-stone-500" />
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
  </nav>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import { Menu, Search, ChevronDown, User, Settings, LogOut } from 'lucide-vue-next'
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
