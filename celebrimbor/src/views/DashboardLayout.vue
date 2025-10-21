<template>
  <div class="min-h-screen bg-slate-50">
    <!-- Command Palette -->
    <CommandPalette
      ref="commandPaletteRef"
      @action="handleCommandPaletteAction"
    />

    <!-- Collapsible Sidebar -->
    <CollapsibleSidebar ref="sidebarRef" />

    <!-- Form Sheets -->
    <ProductFormSheet
      v-model:open="isProductSheetOpen"
      @success="handleProductSheetSuccess"
    />
    <CompanyFormSheet
      v-model:open="isCompanySheetOpen"
      @success="handleCompanySheetSuccess"
    />
    <WarehouseFormSheet
      v-model:open="isWarehouseSheetOpen"
      @success="handleWarehouseSheetSuccess"
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
import CommandPalette from '../components/layout/CommandPalette.vue'
import CollapsibleSidebar from '../components/layout/CollapsibleSidebar.vue'
import Navbar from '../components/layout/Navbar.vue'
import ProductFormSheet from '../components/products/ProductFormSheet.vue'
import CompanyFormSheet from '../components/companies/CompanyFormSheet.vue'
import WarehouseFormSheet from '../components/warehouses/WarehouseFormSheet.vue'

const router = useRouter()
const commandPaletteRef = ref<InstanceType<typeof CommandPalette> | null>(null)
const sidebarRef = ref<InstanceType<typeof CollapsibleSidebar> | null>(null)

const isProductSheetOpen = ref(false)
const isCompanySheetOpen = ref(false)
const isWarehouseSheetOpen = ref(false)

function toggleSidebar() {
  sidebarRef.value?.open()
}

function openCommandPalette() {
  commandPaletteRef.value?.open()
}

function handleCommandPaletteAction(actionName: string) {
  switch (actionName) {
    case 'new-product':
      isProductSheetOpen.value = true
      break
    case 'new-order':
      // TODO: Implement when orders are ready
      router.push('/orders')
      break
    case 'new-invoice':
      // TODO: Implement when invoices are ready
      router.push('/invoices')
      break
    case 'new-company':
      isCompanySheetOpen.value = true
      break
    case 'new-warehouse':
      isWarehouseSheetOpen.value = true
      break
  }
}

function handleProductSheetSuccess() {
  // Optionally navigate to products page or stay on current page
}

function handleCompanySheetSuccess() {
  // Optionally navigate to companies page or stay on current page
}

function handleWarehouseSheetSuccess() {
  // Optionally navigate to warehouses page or stay on current page
}
</script>
