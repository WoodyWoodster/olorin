<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-slate-900">Products</h1>
        <p class="mt-2 text-sm text-slate-600">Manage your product catalog</p>
      </div>
      <Button @click="router.push('/products/new')" class="bg-indigo-600 hover:bg-indigo-700">
        <Plus class="mr-2 h-4 w-4" />
        New Product
      </Button>
    </div>

    <!-- Filters -->
    <div class="flex gap-4">
      <Input
        v-model="searchQuery"
        placeholder="Search products..."
        class="max-w-sm"
      />
      <select
        v-model="typeFilter"
        class="rounded-md border border-slate-300 px-3 py-2 text-sm"
      >
        <option value="">All Types</option>
        <option value="raw_material">Raw Material</option>
        <option value="component">Component</option>
        <option value="finished_good">Finished Good</option>
        <option value="service">Service</option>
      </select>
    </div>

    <!-- Products Table -->
    <div class="rounded-lg border border-slate-200 bg-white">
      <div v-if="isLoading" class="p-12 text-center">
        <p class="text-slate-600">Loading products...</p>
      </div>
      <div v-else-if="error" class="p-12 text-center">
        <p class="text-red-600">Error loading products</p>
      </div>
      <div v-else-if="!filteredProducts?.length" class="p-12 text-center">
        <Package class="mx-auto h-12 w-12 text-slate-400" />
        <p class="mt-4 text-lg font-medium text-slate-900">No products found</p>
        <p class="mt-2 text-sm text-slate-600">Get started by creating a new product</p>
        <Button @click="router.push('/products/new')" class="mt-4">
          <Plus class="mr-2 h-4 w-4" />
          New Product
        </Button>
      </div>
      <table v-else class="w-full">
        <thead class="border-b border-slate-200 bg-slate-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              SKU
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              Name
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              Type
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              UOM
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              Cost
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              Price
            </th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">
              Status
            </th>
            <th class="px-6 py-3 text-right text-xs font-medium uppercase tracking-wider text-slate-600">
              Actions
            </th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-200">
          <tr
            v-for="product in filteredProducts"
            :key="product.id"
            class="hover:bg-slate-50"
          >
            <td class="px-6 py-4 text-sm font-medium text-slate-900">
              {{ product.sku }}
            </td>
            <td class="px-6 py-4 text-sm text-slate-900">
              {{ product.name }}
            </td>
            <td class="px-6 py-4 text-sm text-slate-600">
              <span class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="{
                  'bg-blue-100 text-blue-800': product.product_type === 'raw_material',
                  'bg-purple-100 text-purple-800': product.product_type === 'component',
                  'bg-green-100 text-green-800': product.product_type === 'finished_good',
                  'bg-gray-100 text-gray-800': product.product_type === 'service'
                }">
                {{ formatProductType(product.product_type) }}
              </span>
            </td>
            <td class="px-6 py-4 text-sm text-slate-600">
              {{ product.unit_of_measure }}
            </td>
            <td class="px-6 py-4 text-sm text-slate-900">
              {{ formatCurrency(product.cost) }}
            </td>
            <td class="px-6 py-4 text-sm text-slate-900">
              {{ formatCurrency(product.price) }}
            </td>
            <td class="px-6 py-4 text-sm">
              <span
                class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="product.is_active
                  ? 'bg-green-100 text-green-800'
                  : 'bg-gray-100 text-gray-800'"
              >
                {{ product.is_active ? 'Active' : 'Inactive' }}
              </span>
            </td>
            <td class="px-6 py-4 text-right text-sm font-medium">
              <Button
                @click="router.push(`/products/${product.id}/edit`)"
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
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { Plus, Package } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { useProducts } from '@/composables/useProducts'

const router = useRouter()
const searchQuery = ref('')
const typeFilter = ref('')

const { data: products, isLoading, error } = useProducts()

const filteredProducts = computed(() => {
  if (!products.value) return []

  return products.value.filter(product => {
    const matchesSearch = !searchQuery.value ||
      product.name.toLowerCase().includes(searchQuery.value.toLowerCase()) ||
      product.sku.toLowerCase().includes(searchQuery.value.toLowerCase())

    const matchesType = !typeFilter.value || product.product_type === typeFilter.value

    return matchesSearch && matchesType
  })
})

const formatProductType = (type: string) => {
  return type.split('_').map(word => word.charAt(0).toUpperCase() + word.slice(1)).join(' ')
}

const formatCurrency = (amount: number | undefined) => {
  if (amount === undefined || amount === null) return '-'
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD'
  }).format(amount)
}
</script>
