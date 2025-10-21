<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-slate-900">Warehouses</h1>
        <p class="mt-2 text-sm text-slate-600">Manage warehouse locations</p>
      </div>
      <Button @click="openNewWarehouseSheet" class="bg-indigo-600 hover:bg-indigo-700">
        <Plus class="mr-2 h-4 w-4" />
        New Warehouse
      </Button>
    </div>

    <div class="rounded-lg border border-slate-200 bg-white">
      <div v-if="isLoading" class="p-12 text-center">
        <p class="text-slate-600">Loading warehouses...</p>
      </div>
      <div v-else-if="error" class="p-12 text-center">
        <p class="text-red-600">Error loading warehouses</p>
      </div>
      <div v-else-if="!warehouses?.length" class="p-12 text-center">
        <WarehouseIcon class="mx-auto h-12 w-12 text-slate-400" />
        <p class="mt-4 text-lg font-medium text-slate-900">No warehouses found</p>
        <p class="mt-2 text-sm text-slate-600">Get started by creating a new warehouse</p>
      </div>
      <table v-else class="w-full">
        <thead class="border-b border-slate-200 bg-slate-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Code</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Status</th>
            <th class="px-6 py-3 text-right text-xs font-medium uppercase tracking-wider text-slate-600">Actions</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-200">
          <tr v-for="warehouse in warehouses" :key="warehouse.id" class="cursor-pointer hover:bg-slate-50" @click="router.push(`/warehouses/${warehouse.id}`)">
            <td class="px-6 py-4 text-sm font-medium text-slate-900">{{ warehouse.code }}</td>
            <td class="px-6 py-4 text-sm text-slate-900">{{ warehouse.name }}</td>
            <td class="px-6 py-4 text-sm">
              <span class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="warehouse.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'">
                {{ warehouse.is_active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td class="px-6 py-4 text-right text-sm font-medium">
              <Button
                @click.stop="openEditSheet(warehouse.id)"
                variant="ghost"
                size="sm"
              >
                Edit
              </Button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Warehouse Form Sheet -->
    <WarehouseFormSheet
      v-model:open="isSheetOpen"
      :warehouse-id="editingWarehouseId"
      @success="handleSheetSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Warehouse as WarehouseIcon, Plus } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { useWarehouses } from '@/composables/useWarehouses'
import WarehouseFormSheet from '@/components/warehouses/WarehouseFormSheet.vue'

const router = useRouter()
const isSheetOpen = ref(false)
const editingWarehouseId = ref<number | null>(null)

const { data: warehouses, isLoading, error, refetch } = useWarehouses()

function openNewWarehouseSheet() {
  editingWarehouseId.value = null
  isSheetOpen.value = true
}

function openEditSheet(warehouseId: number) {
  editingWarehouseId.value = warehouseId
  isSheetOpen.value = true
}

function handleSheetSuccess() {
  refetch()
}
</script>
