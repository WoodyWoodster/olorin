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
          :key="item.action"
          :value="item.name"
          @select="handleAction(item.action)"
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
  Rocket,
  Database,
  Globe,
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

const emit = defineEmits<{
  action: [actionName: string]
}>()

// Navigation items
const navigationItems = [
  { name: 'Dashboard', href: '/dashboard', icon: LayoutDashboard },
  { name: 'Apps', href: '/apps', icon: Rocket },
  { name: 'Settings', href: '/settings', icon: Settings },
]

// Action items
const actionItems = [
  { name: 'New App', action: 'new-app', icon: Plus },
  { name: 'Provision Add-on', action: 'new-addon', icon: Database },
  { name: 'Add Custom Domain', action: 'new-domain', icon: Globe },
]

// Navigation
function navigate(href: string) {
  router.push(href)
  isOpen.value = false
}

// Handle actions
function handleAction(actionName: string) {
  emit('action', actionName)
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
