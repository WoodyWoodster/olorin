<template>
  <div class="min-h-screen bg-slate-50">
    <!-- Command Palette -->
    <CommandPalette ref="commandPaletteRef" />

    <!-- Collapsible Sidebar -->
    <CollapsibleSidebar ref="sidebarRef" />

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
import CommandPalette from '../components/layout/CommandPalette.vue'
import CollapsibleSidebar from '../components/layout/CollapsibleSidebar.vue'
import Navbar from '../components/layout/Navbar.vue'

const commandPaletteRef = ref<InstanceType<typeof CommandPalette> | null>(null)
const sidebarRef = ref<InstanceType<typeof CollapsibleSidebar> | null>(null)

function toggleSidebar() {
  sidebarRef.value?.open()
}

function openCommandPalette() {
  commandPaletteRef.value?.open()
}
</script>
