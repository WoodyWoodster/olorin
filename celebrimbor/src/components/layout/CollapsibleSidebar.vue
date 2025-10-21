<template>
  <!-- Backdrop -->
  <Teleport to="body">
    <Transition name="backdrop">
      <div
        v-if="isOpen"
        class="fixed inset-0 z-40 bg-black/50"
        @click="close"
      />
    </Transition>

    <!-- Sidebar -->
    <Transition name="sidebar">
      <aside
        v-if="isOpen"
        class="fixed left-0 top-0 z-50 h-screen w-64 border-r border-stone-200 bg-white shadow-xl"
      >
        <!-- Logo & Close -->
        <div class="flex h-16 items-center justify-between border-b border-stone-200 px-6">
          <div class="flex items-center space-x-3">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-orange-600">
              <svg class="h-6 w-6 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
              </svg>
            </div>
            <h1 class="text-lg font-bold text-stone-900">Olorin PaaS</h1>
          </div>
          <button
            @click="close"
            class="rounded-lg p-1.5 text-stone-400 hover:bg-stone-100 hover:text-stone-600"
          >
            <X class="h-5 w-5" />
          </button>
        </div>

        <!-- Navigation -->
        <nav class="flex-1 space-y-1 overflow-y-auto px-3 py-4">
          <router-link
            v-for="item in navigation"
            :key="item.name"
            :to="item.href"
            class="flex items-center rounded-xl px-3 py-2 text-sm font-medium transition-colors"
            :class="isActive(item.href)
              ? 'bg-orange-50 text-orange-600'
              : 'text-stone-700 hover:bg-stone-100 hover:text-stone-900'"
            @click="close"
          >
            <component :is="item.icon" class="mr-3 h-5 w-5 flex-shrink-0" />
            {{ item.name }}
          </router-link>
        </nav>

        <!-- Footer Info -->
        <div class="border-t border-stone-200 p-4">
          <div class="text-xs text-stone-500">
            <div class="font-semibold text-stone-900">{{ organization }}</div>
            <div class="mt-1">{{ user?.email }}</div>
          </div>
        </div>
      </aside>
    </Transition>
  </Teleport>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import {
  X,
  LayoutDashboard,
  Rocket,
  Settings
} from 'lucide-vue-next'
import { useAuthStore } from '@/stores/auth'

const route = useRoute()
const authStore = useAuthStore()

const isOpen = ref(false)

const user = computed(() => authStore.user)
const organization = computed(() => 'My Organization')

const navigation = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Apps', href: '/apps', icon: Rocket },
  { name: 'Settings', href: '/settings', icon: Settings },
]

const isActive = (href: string) => {
  return route.path === href || route.path.startsWith(href + '/')
}

function open() {
  isOpen.value = true
}

function close() {
  isOpen.value = false
}

defineExpose({ open, close })
</script>

<style scoped>
.backdrop-enter-active,
.backdrop-leave-active {
  transition: opacity 0.3s ease;
}

.backdrop-enter-from,
.backdrop-leave-to {
  opacity: 0;
}

.sidebar-enter-active,
.sidebar-leave-active {
  transition: transform 0.3s ease;
}

.sidebar-enter-from,
.sidebar-leave-to {
  transform: translateX(-100%);
}
</style>
