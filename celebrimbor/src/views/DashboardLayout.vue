<template>
  <div class="min-h-screen bg-stone-50">
    <!-- Toast Notifications -->
    <Toaster />

    <!-- Command Palette -->
    <CommandPalette
      ref="commandPaletteRef"
      @action="handleCommandPaletteAction"
    />

    <!-- Collapsible Sidebar -->
    <CollapsibleSidebar ref="sidebarRef" />

    <!-- App Creation Wizard -->
    <AppCreationWizard
      v-model:open="isAppWizardOpen"
      :is-submitting="createMutation.isPending.value"
      @submit="handleCreateApp"
      @cancel="isAppWizardOpen = false"
    />

    <!-- Main Content -->
    <div class="flex min-h-screen flex-col">
      <!-- Top Navbar -->
      <Navbar
        @toggleSidebar="toggleSidebar"
        @openCommandPalette="openCommandPalette"
      />

      <!-- Page Content -->
      <main class="flex-1 p-6">
        <router-view />
      </main>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { toast } from 'vue-sonner'
import { Toaster } from '@/components/ui/sonner'
import CommandPalette from '../components/layout/CommandPalette.vue'
import CollapsibleSidebar from '../components/layout/CollapsibleSidebar.vue'
import Navbar from '../components/layout/Navbar.vue'
import AppCreationWizard from '../components/apps/AppCreationWizard.vue'
import { useCreateApp } from '@/composables/useApps'

const router = useRouter()
const commandPaletteRef = ref<InstanceType<typeof CommandPalette> | null>(null)
const sidebarRef = ref<InstanceType<typeof CollapsibleSidebar> | null>(null)

const isAppWizardOpen = ref(false)
const createMutation = useCreateApp()

function toggleSidebar() {
  sidebarRef.value?.open()
}

function openCommandPalette() {
  commandPaletteRef.value?.open()
}

function handleCommandPaletteAction(actionName: string) {
  switch (actionName) {
    case 'new-app':
      isAppWizardOpen.value = true
      break
    case 'new-addon':
      // TODO: Implement add-on marketplace
      router.push('/apps')
      break
    case 'new-domain':
      // TODO: Implement domain management
      router.push('/apps')
      break
  }
}

async function handleCreateApp(formData: any) {
  try {
    await createMutation.mutateAsync({ app: formData })
    const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    toast.success('App created successfully', {
      description: `${formData.name} (${formData.subdomain}) - ${time}`
    })
    isAppWizardOpen.value = false
  } catch (error: any) {
    console.error('Error creating app:', error)
    toast.error('Failed to create app', {
      description: error?.message || 'An unexpected error occurred'
    })
  }
}
</script>
