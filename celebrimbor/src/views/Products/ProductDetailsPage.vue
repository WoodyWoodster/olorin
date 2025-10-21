<template>
  <div class="max-w-4xl space-y-6">
    <!-- Header -->
    <div>
      <router-link to="/products" class="text-sm text-indigo-600 hover:text-indigo-700">
        ← Back to Products
      </router-link>
      <div class="mt-4 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-slate-900">{{ product?.name || 'Product Details' }}</h1>
          <p class="mt-2 text-sm text-slate-600">SKU: {{ product?.sku }}</p>
        </div>
        <Button
          @click="openEditSheet"
          class="bg-indigo-600 hover:bg-indigo-700"
        >
          <Pencil class="mr-2 h-4 w-4" />
          Edit Product
        </Button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="rounded-lg border border-slate-200 bg-white p-12 text-center">
      <p class="text-slate-600">Loading product...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="rounded-lg border border-red-200 bg-red-50 p-12 text-center">
      <p class="text-red-600">Error loading product</p>
    </div>

    <!-- Product Details -->
    <div v-else-if="product" class="space-y-6">
      <!-- Basic Information -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Basic Information</h2>
        </div>
        <div class="grid gap-6 p-6 sm:grid-cols-2">
          <div>
            <label class="block text-sm font-medium text-slate-600">Name</label>
            <p class="mt-1 text-sm text-slate-900">{{ product.name }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">SKU</label>
            <p class="mt-1 text-sm text-slate-900">{{ product.sku }}</p>
          </div>
          <div class="sm:col-span-2">
            <label class="block text-sm font-medium text-slate-600">Description</label>
            <p class="mt-1 text-sm text-slate-900">{{ product.description || '-' }}</p>
          </div>
        </div>
      </div>

      <!-- Product Classification -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Classification</h2>
        </div>
        <div class="grid gap-6 p-6 sm:grid-cols-2">
          <div>
            <label class="block text-sm font-medium text-slate-600">Product Type</label>
            <span
              class="mt-1 inline-flex rounded-full px-2 text-xs font-semibold leading-5"
              :class="{
                'bg-blue-100 text-blue-800': product.product_type === 'raw_material',
                'bg-purple-100 text-purple-800': product.product_type === 'component',
                'bg-green-100 text-green-800': product.product_type === 'finished_good',
                'bg-gray-100 text-gray-800': product.product_type === 'service',
              }"
            >
              {{ formatProductType(product.product_type) }}
            </span>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Unit of Measure</label>
            <p class="mt-1 text-sm text-slate-900">{{ formatUnitOfMeasure(product.unit_of_measure) }}</p>
          </div>
        </div>
      </div>

      <!-- Pricing & Manufacturing -->
      <div class="grid gap-6 lg:grid-cols-2">
        <!-- Pricing -->
        <div class="rounded-lg border border-slate-200 bg-white">
          <div class="border-b border-slate-200 px-6 py-4">
            <h2 class="text-lg font-semibold text-slate-900">Pricing</h2>
          </div>
          <div class="space-y-4 p-6">
            <div>
              <label class="block text-sm font-medium text-slate-600">Cost</label>
              <p class="mt-1 text-sm text-slate-900">{{ formatCurrency(product.cost) }}</p>
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-600">Price</label>
              <p class="mt-1 text-sm text-slate-900">{{ formatCurrency(product.price) }}</p>
            </div>
          </div>
        </div>

        <!-- Status & Manufacturing -->
        <div class="rounded-lg border border-slate-200 bg-white">
          <div class="border-b border-slate-200 px-6 py-4">
            <h2 class="text-lg font-semibold text-slate-900">Status & Manufacturing</h2>
          </div>
          <div class="space-y-4 p-6">
            <div>
              <label class="block text-sm font-medium text-slate-600">Status</label>
              <span
                class="mt-1 inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="product.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
              >
                {{ product.is_active ? 'Active' : 'Inactive' }}
              </span>
            </div>
            <div>
              <label class="block text-sm font-medium text-slate-600">Manufactured</label>
              <p class="mt-1 text-sm text-slate-900">{{ product.is_manufactured ? 'Yes' : 'No' }}</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Product Sheet -->
    <ProductFormSheet
      v-model:open="isEditSheetOpen"
      :product-id="product?.id"
      @success="handleEditSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { Pencil } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { useProduct } from '@/composables/useProducts'
import ProductFormSheet from '@/components/products/ProductFormSheet.vue'

const route = useRoute()
const productId = computed(() => route.params.id as string)

const { data: product, isLoading, error, refetch } = useProduct(productId.value)

const isEditSheetOpen = ref(false)

function openEditSheet() {
  isEditSheetOpen.value = true
}

function handleEditSuccess() {
  refetch()
}

// Format helpers
const formatProductType = (type: string) => {
  return type
    .split('_')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ')
}

const formatUnitOfMeasure = (unit: string) => {
  return unit.charAt(0).toUpperCase() + unit.slice(1)
}

const formatCurrency = (amount: number | undefined) => {
  if (amount === undefined || amount === null) return '-'
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(amount)
}
</script>
