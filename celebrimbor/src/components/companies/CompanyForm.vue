<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Name -->
    <div>
      <label for="name" class="block text-sm font-medium text-slate-700">Company Name *</label>
      <Input
        id="name"
        v-model="form.name"
        required
        class="mt-1"
      />
    </div>

    <!-- Company Type -->
    <div>
      <label for="company_type" class="block text-sm font-medium text-slate-700">Company Type *</label>
      <select
        id="company_type"
        v-model="form.company_type"
        required
        class="mt-1 w-full rounded-md border border-slate-300 px-3 py-2 text-sm"
      >
        <option value="">Select a type</option>
        <option value="customer">Customer</option>
        <option value="supplier">Supplier</option>
        <option value="both">Both</option>
      </select>
    </div>

    <!-- Tax ID & Website -->
    <div class="grid grid-cols-2 gap-4">
      <div>
        <label for="tax_id" class="block text-sm font-medium text-slate-700">Tax ID</label>
        <Input
          id="tax_id"
          v-model="form.tax_id"
          class="mt-1"
        />
      </div>
      <div>
        <label for="website" class="block text-sm font-medium text-slate-700">Website</label>
        <Input
          id="website"
          v-model="form.website"
          type="url"
          class="mt-1"
        />
      </div>
    </div>

    <!-- Email & Phone -->
    <div class="grid grid-cols-2 gap-4">
      <div>
        <label for="email" class="block text-sm font-medium text-slate-700">Email</label>
        <Input
          id="email"
          v-model="form.email"
          type="email"
          class="mt-1"
        />
      </div>
      <div>
        <label for="phone" class="block text-sm font-medium text-slate-700">Phone</label>
        <Input
          id="phone"
          v-model="form.phone"
          class="mt-1"
        />
      </div>
    </div>

    <!-- Active Status -->
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

    <!-- Actions -->
    <div class="flex justify-end gap-3">
      <Button
        type="button"
        variant="outline"
        @click="$emit('cancel')"
      >
        Cancel
      </Button>
      <Button
        type="submit"
        class="bg-indigo-600 hover:bg-indigo-700"
        :disabled="isSubmitting"
      >
        {{ isSubmitting ? 'Saving...' : (isEditing ? 'Update' : 'Create') }} Company
      </Button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import type { Company } from '@/types/api'

interface Props {
  company?: Company | null
  isSubmitting?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  company: null,
  isSubmitting: false
})

const emit = defineEmits<{
  submit: [data: any]
  cancel: []
}>()

const isEditing = Boolean(props.company)

const form = ref({
  name: '',
  company_type: '',
  tax_id: '',
  website: '',
  email: '',
  phone: '',
  is_active: true
})

// Watch for company changes and update form
watch(
  () => props.company,
  (company) => {
    if (company) {
      form.value = {
        name: company.name,
        company_type: company.company_type,
        tax_id: company.tax_id || '',
        website: company.website || '',
        email: company.email || '',
        phone: company.phone || '',
        is_active: company.is_active
      }
    }
  },
  { immediate: true }
)

function handleSubmit() {
  emit('submit', form.value)
}

// Expose form data for dirty checking
defineExpose({ form })
</script>
