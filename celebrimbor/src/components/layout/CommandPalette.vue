<template>
  <CommandDialog v-model:open="isOpen">
    <CommandInput placeholder="Search or jump to..." />
    <CommandList>
      <CommandEmpty>No results found.</CommandEmpty>

      <!-- Navigation Group -->
      <CommandGroup heading="Navigation">
        <CommandItem
          v-for="item in navigationItems"
          :key="item.href"
          :value="item.name"
          @select="navigate(item.href)"
        >
          <component :is="item.icon" class="mr-2 h-4 w-4" />
          <span>{{ item.name }}</span>
        </CommandItem>
      </CommandGroup>

      <CommandSeparator />

      <!-- Actions Group -->
      <CommandGroup heading="Actions">
        <CommandItem
          v-for="item in actionItems"
          :key="item.href"
          :value="item.name"
          @select="navigate(item.href)"
        >
          <component :is="item.icon" class="mr-2 h-4 w-4" />
          <span>{{ item.name }}</span>
        </CommandItem>
      </CommandGroup>
    </CommandList>
  </CommandDialog>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import {
  LayoutDashboard,
  Package,
  Building2,
  Warehouse,
  ShoppingCart,
  FileText,
  Settings,
  Plus
} from 'lucide-vue-next'
import {
  CommandDialog,
  CommandEmpty,
  CommandGroup,
  CommandInput,
  CommandItem,
  CommandList,
  CommandSeparator,
} from '@/components/ui/command'

const router = useRouter()
const isOpen = ref(false)

// Navigation items
const navigationItems = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Products', href: '/products', icon: Package },
  { name: 'Companies', href: '/companies', icon: Building2 },
  { name: 'Warehouses', href: '/warehouses', icon: Warehouse },
  { name: 'Orders', href: '/orders', icon: ShoppingCart },
  { name: 'Invoices', href: '/invoices', icon: FileText },
  { name: 'Settings', href: '/settings', icon: Settings },
]

// Action items
const actionItems = [
  { name: 'New Product', href: '/products/new', icon: Plus },
  { name: 'New Order', href: '/orders/new', icon: Plus },
  { name: 'New Invoice', href: '/invoices/new', icon: Plus },
]

// Navigation
function navigate(href: string) {
  router.push(href)
  isOpen.value = false
}

// Open/Close
function open() {
  isOpen.value = true
}

function close() {
  isOpen.value = false
}

// Global keyboard shortcut
function handleKeydown(e: KeyboardEvent) {
  if ((e.metaKey || e.ctrlKey) && e.key === 'k') {
    e.preventDefault()
    isOpen.value = !isOpen.value
  }
}

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
  window.removeEventListener('keydown', handleKeydown)
})

// Expose methods for parent components
defineExpose({ open, close })
</script>
