<template>
  <div class="max-w-3xl space-y-6">
    <!-- Header -->
    <div>
      <router-link to="/products" class="text-sm text-indigo-600 hover:text-indigo-700">
        ← Back to Products
      </router-link>
      <h1 class="mt-4 text-3xl font-bold text-slate-900">
        {{ isEditing ? 'Edit Product' : 'New Product' }}
      </h1>
    </div>

    <!-- Form -->
    <form @submit.prevent="handleSubmit" class="space-y-6 rounded-lg border border-slate-200 bg-white p-6">
      <!-- SKU -->
      <div>
        <label for="sku" class="block text-sm font-medium text-slate-700">SKU *</label>
        <Input
          id="sku"
          v-model="form.sku"
          required
          class="mt-1"
          :disabled="isEditing"
        />
      </div>

      <!-- Name -->
      <div>
        <label for="name" class="block text-sm font-medium text-slate-700">Name *</label>
        <Input
          id="name"
          v-model="form.name"
          required
          class="mt-1"
        />
      </div>

      <!-- Description -->
      <div>
        <label for="description" class="block text-sm font-medium text-slate-700">Description</label>
        <textarea
          id="description"
          v-model="form.description"
          rows="3"
          class="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
        />
      </div>

      <!-- Product Type -->
      <div>
        <label for="product_type" class="block text-sm font-medium text-slate-700">Product Type *</label>
        <select
          id="product_type"
          v-model="form.product_type"
          required
          class="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
        >
          <option value="">Select a type</option>
          <option value="raw_material">Raw Material</option>
          <option value="component">Component</option>
          <option value="finished_good">Finished Good</option>
          <option value="service">Service</option>
        </select>
      </div>

      <!-- Unit of Measure -->
      <div>
        <label for="unit_of_measure" class="block text-sm font-medium text-slate-700">Unit of Measure *</label>
        <select
          id="unit_of_measure"
          v-model="form.unit_of_measure"
          required
          class="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
        >
          <option value="">Select a unit</option>
          <option value="piece">Piece</option>
          <option value="kilogram">Kilogram</option>
          <option value="gram">Gram</option>
          <option value="liter">Liter</option>
          <option value="meter">Meter</option>
          <option value="box">Box</option>
        </select>
      </div>

      <!-- Cost & Price -->
      <div class="grid grid-cols-2 gap-4">
        <div>
          <label for="cost" class="block text-sm font-medium text-slate-700">Cost</label>
          <Input
            id="cost"
            v-model.number="form.cost"
            type="number"
            step="0.01"
            min="0"
            class="mt-1"
          />
        </div>
        <div>
          <label for="price" class="block text-sm font-medium text-slate-700">Price</label>
          <Input
            id="price"
            v-model.number="form.price"
            type="number"
            step="0.01"
            min="0"
            class="mt-1"
          />
        </div>
      </div>

      <!-- Checkboxes -->
      <div class="space-y-4">
        <div class="flex items-center">
          <input
            id="is_manufactured"
            v-model="form.is_manufactured"
            type="checkbox"
            class="h-4 w-4 rounded border-slate-300 text-indigo-600"
          />
          <label for="is_manufactured" class="ml-2 text-sm text-slate-700">
            Is Manufactured
          </label>
        </div>
        <div class="flex items-center">
          <input
            id="is_active"
            v-model="form.is_active"
            type="checkbox"
            class="h-4 w-4 rounded border-slate-300 text-indigo-600"
          />
          <label for="is_active" class="ml-2 text-sm text-slate-700">
            Active
          </label>
        </div>
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-3">
        <Button
          type="button"
          variant="outline"
          @click="router.push('/products')"
        >
          Cancel
        </Button>
        <Button
          type="submit"
          class="bg-indigo-600 hover:bg-indigo-700"
          :disabled="mutation.isPending.value"
        >
          {{ mutation.isPending.value ? 'Saving...' : (isEditing ? 'Update' : 'Create') }} Product
        </Button>
      </div>
    </form>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import { useProduct, useCreateProduct, useUpdateProduct } from '@/composables/useProducts'

const router = useRouter()
const route = useRoute()

const productId = computed(() => route.params.id as string)
const isEditing = computed(() => !!productId.value && productId.value !== 'new')

const form = ref({
  sku: '',
  name: '',
  description: '',
  product_type: '',
  unit_of_measure: '',
  cost: undefined as number | undefined,
  price: undefined as number | undefined,
  is_manufactured: false,
  is_active: true
})

// Load existing product if editing
const { data: existingProduct } = useProduct(productId.value)
watch(existingProduct, (product) => {
  if (product) {
    form.value = {
      sku: product.sku,
      name: product.name,
      description: product.description || '',
      product_type: product.product_type,
      unit_of_measure: product.unit_of_measure,
      cost: product.cost,
      price: product.price,
      is_manufactured: product.is_manufactured,
      is_active: product.is_active
    }
  }
})

const createMutation = useCreateProduct()
const updateMutation = useUpdateProduct()
const mutation = computed(() => isEditing.value ? updateMutation : createMutation)

const handleSubmit = async () => {
  try {
    if (isEditing.value) {
      await updateMutation.mutateAsync({
        id: Number(productId.value),
        data: { product: form.value }
      })
    } else {
      await createMutation.mutateAsync({ product: form.value })
    }
    router.push('/products')
  } catch (error) {
    console.error('Error saving product:', error)
  }
}
</script>
