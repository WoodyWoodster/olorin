<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h1 class="text-3xl font-bold text-slate-900">Dashboard</h1>
      <p class="mt-2 text-sm text-slate-600">
        Welcome back! Here's what's happening with your business.
      </p>
    </div>

    <!-- Top Row: Favorites + Recent -->
    <div class="grid gap-6 lg:grid-cols-2">
      <!-- Favorites -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-4 py-3">
          <h2 class="font-semibold text-slate-900">Favorites</h2>
        </div>
        <div class="p-4">
          <div class="space-y-2">
            <router-link
              to="/products"
              class="flex items-center rounded-lg p-2 text-sm transition-colors hover:bg-slate-50"
            >
              <Package class="mr-3 h-4 w-4 text-slate-400" />
              <span class="text-slate-700">Products</span>
            </router-link>
            <router-link
              to="/companies"
              class="flex items-center rounded-lg p-2 text-sm transition-colors hover:bg-slate-50"
            >
              <Building2 class="mr-3 h-4 w-4 text-slate-400" />
              <span class="text-slate-700">Companies</span>
            </router-link>
            <router-link
              to="/warehouses"
              class="flex items-center rounded-lg p-2 text-sm transition-colors hover:bg-slate-50"
            >
              <Warehouse class="mr-3 h-4 w-4 text-slate-400" />
              <span class="text-slate-700">Warehouses</span>
            </router-link>
          </div>
        </div>
      </div>

      <!-- Recent Activity -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-4 py-3">
          <h2 class="font-semibold text-slate-900">Recent Activity</h2>
        </div>
        <div class="p-4">
          <div class="space-y-3">
            <div
              v-if="recentProducts.length === 0 && recentCompanies.length === 0"
              class="py-8 text-center"
            >
              <Clock class="mx-auto h-8 w-8 text-slate-300" />
              <p class="mt-2 text-sm text-slate-500">No recent activity</p>
            </div>
            <div v-else class="space-y-2">
              <router-link
                v-for="product in recentProducts"
                :key="product.id"
                :to="`/products/${product.id}/edit`"
                class="flex items-center justify-between rounded-lg p-2 text-sm transition-colors hover:bg-slate-50"
              >
                <div class="flex items-center">
                  <Package class="mr-3 h-4 w-4 text-indigo-400" />
                  <span class="text-slate-700">{{ product.name }}</span>
                </div>
                <span class="text-xs text-slate-400">Product</span>
              </router-link>
              <router-link
                v-for="company in recentCompanies"
                :key="company.id"
                to="/companies"
                class="flex items-center justify-between rounded-lg p-2 text-sm transition-colors hover:bg-slate-50"
              >
                <div class="flex items-center">
                  <Building2 class="mr-3 h-4 w-4 text-emerald-400" />
                  <span class="text-slate-700">{{ company.name }}</span>
                </div>
                <span class="text-xs text-slate-400">Company</span>
              </router-link>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Products Preview -->
    <div class="rounded-lg border border-slate-200 bg-white">
      <div class="flex items-center justify-between border-b border-slate-200 px-4 py-3">
        <h2 class="font-semibold text-slate-900">Products</h2>
        <div class="flex items-center space-x-2">
          <button
            @click="openNewProductSheet"
            class="rounded-lg bg-indigo-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-indigo-700"
          >
            <Plus class="mr-1 inline h-4 w-4" />
            New Product
          </button>
          <router-link
            to="/products"
            class="text-sm font-medium text-indigo-600 hover:text-indigo-700"
          >
            View All →
          </router-link>
        </div>
      </div>
      <div class="overflow-x-auto">
        <table v-if="productsData && productsData.length > 0" class="w-full">
          <thead class="border-b border-slate-200 bg-slate-50">
            <tr>
              <th
                class="px-4 py-2 text-left text-xs font-medium uppercase tracking-wider text-slate-600"
              >
                SKU
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium uppercase tracking-wider text-slate-600"
              >
                Name
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium uppercase tracking-wider text-slate-600"
              >
                Type
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium uppercase tracking-wider text-slate-600"
              >
                Price
              </th>
              <th
                class="px-4 py-2 text-left text-xs font-medium uppercase tracking-wider text-slate-600"
              >
                Status
              </th>
            </tr>
          </thead>
          <tbody class="divide-y divide-slate-200">
            <tr
              v-for="product in productsData.slice(0, 5)"
              :key="product.id"
              class="hover:bg-slate-50"
            >
              <td class="px-4 py-3 text-sm font-medium text-slate-900">{{ product.sku }}</td>
              <td class="px-4 py-3 text-sm text-slate-900">{{ product.name }}</td>
              <td class="px-4 py-3 text-sm text-slate-600">
                <span
                  class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                  :class="{
                    'bg-blue-100 text-blue-800': product.product_type === 'raw_material',
                    'bg-purple-100 text-purple-800': product.product_type === 'component',
                    'bg-green-100 text-green-800': product.product_type === 'finished_good',
                    'bg-gray-100 text-gray-800': product.product_type === 'service',
                  }"
                >
                  {{ formatProductType(product.product_type) }}
                </span>
              </td>
              <td class="px-4 py-3 text-sm text-slate-900">{{ formatCurrency(product.price) }}</td>
              <td class="px-4 py-3 text-sm">
                <span
                  class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                  :class="
                    product.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'
                  "
                >
                  {{ product.is_active ? 'Active' : 'Inactive' }}
                </span>
              </td>
            </tr>
          </tbody>
        </table>
        <div v-else class="p-12 text-center">
          <Package class="mx-auto h-12 w-12 text-slate-300" />
          <p class="mt-2 text-sm text-slate-500">No products yet</p>
        </div>
      </div>
    </div>

    <!-- Product Form Sheet -->
    <ProductFormSheet
      v-model:open="isNewProductSheetOpen"
      @success="handleProductCreated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Package, Building2, Warehouse, Plus, Clock } from 'lucide-vue-next'
import { useProducts } from '@/composables/useProducts'
import { useCompanies } from '@/composables/useCompanies'
import ProductFormSheet from '@/components/products/ProductFormSheet.vue'

const isNewProductSheetOpen = ref(false)

const { data: productsData, refetch: refetchProducts } = useProducts()
const { data: companiesData } = useCompanies()

const recentProducts = computed(() => {
  if (!productsData.value) return []
  return productsData.value.slice(0, 3)
})

const recentCompanies = computed(() => {
  if (!companiesData.value) return []
  return companiesData.value.slice(0, 2)
})

const formatProductType = (type: string) => {
  return type
    .split('_')
    .map((word) => word.charAt(0).toUpperCase() + word.slice(1))
    .join(' ')
}

const formatCurrency = (amount: number | undefined) => {
  if (amount === undefined || amount === null) return '-'
  return new Intl.NumberFormat('en-US', {
    style: 'currency',
    currency: 'USD',
  }).format(amount)
}

function openNewProductSheet() {
  isNewProductSheetOpen.value = true
}

function handleProductCreated() {
  refetchProducts()
}
</script>
