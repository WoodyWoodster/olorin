<template>
  <div class="min-h-screen bg-slate-50">
    <!-- Toast Notifications -->
    <Toaster />

    <!-- Command Palette -->
    <CommandPalette
      ref="commandPaletteRef"
      @action="handleCommandPaletteAction"
    />

    <!-- Collapsible Sidebar -->
    <CollapsibleSidebar ref="sidebarRef" />

    <!-- Form Sheets -->
    <AppFormSheet
      v-model:open="isAppSheetOpen"
      @success="handleAppSheetSuccess"
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
import { Toaster } from '@/components/ui/sonner'
import CommandPalette from '../components/layout/CommandPalette.vue'
import CollapsibleSidebar from '../components/layout/CollapsibleSidebar.vue'
import Navbar from '../components/layout/Navbar.vue'
import AppFormSheet from '../components/apps/AppFormSheet.vue'

const router = useRouter()
const commandPaletteRef = ref<InstanceType<typeof CommandPalette> | null>(null)
const sidebarRef = ref<InstanceType<typeof CollapsibleSidebar> | null>(null)

const isAppSheetOpen = ref(false)

function toggleSidebar() {
  sidebarRef.value?.open()
}

function openCommandPalette() {
  commandPaletteRef.value?.open()
}

function handleCommandPaletteAction(actionName: string) {
  switch (actionName) {
    case 'new-app':
      isAppSheetOpen.value = true
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

function handleAppSheetSuccess() {
  // App will auto-refresh due to query invalidation
}
</script>
