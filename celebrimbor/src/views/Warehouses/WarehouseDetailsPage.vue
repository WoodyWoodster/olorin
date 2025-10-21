<template>
  <div class="max-w-4xl space-y-6">
    <!-- Header -->
    <div>
      <router-link to="/warehouses" class="text-sm text-indigo-600 hover:text-indigo-700">
        ← Back to Warehouses
      </router-link>
      <div class="mt-4 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-slate-900">{{ warehouse?.name || 'Warehouse Details' }}</h1>
          <p class="mt-2 text-sm text-slate-600">Code: {{ warehouse?.code }}</p>
        </div>
        <Button
          @click="openEditSheet"
          class="bg-indigo-600 hover:bg-indigo-700"
        >
          <Pencil class="mr-2 h-4 w-4" />
          Edit Warehouse
        </Button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="rounded-lg border border-slate-200 bg-white p-12 text-center">
      <p class="text-slate-600">Loading warehouse...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="rounded-lg border border-red-200 bg-red-50 p-12 text-center">
      <p class="text-red-600">Error loading warehouse</p>
    </div>

    <!-- Warehouse Details -->
    <div v-else-if="warehouse" class="space-y-6">
      <!-- Basic Information -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Information</h2>
        </div>
        <div class="grid gap-6 p-6 sm:grid-cols-2">
          <div>
            <label class="block text-sm font-medium text-slate-600">Warehouse Name</label>
            <p class="mt-1 text-sm text-slate-900">{{ warehouse.name }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Code</label>
            <p class="mt-1 text-sm text-slate-900">{{ warehouse.code }}</p>
          </div>
        </div>
      </div>

      <!-- Status -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Status</h2>
        </div>
        <div class="p-6">
          <span
            class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
            :class="warehouse.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
          >
            {{ warehouse.is_active ? 'Active' : 'Inactive' }}
          </span>
        </div>
      </div>
    </div>

    <!-- Edit Warehouse Sheet -->
    <WarehouseFormSheet
      v-model:open="isEditSheetOpen"
      :warehouse-id="warehouse?.id"
      @success="handleEditSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { Pencil } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { useWarehouse } from '@/composables/useWarehouses'
import WarehouseFormSheet from '@/components/warehouses/WarehouseFormSheet.vue'

const route = useRoute()
const warehouseId = computed(() => route.params.id as string)

const { data: warehouse, isLoading, error, refetch } = useWarehouse(warehouseId.value)

const isEditSheetOpen = ref(false)

function openEditSheet() {
  isEditSheetOpen.value = true
}

function handleEditSuccess() {
  refetch()
}
</script>
