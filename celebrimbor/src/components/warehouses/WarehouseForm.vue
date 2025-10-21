<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Code -->
    <div>
      <label for="code" class="block text-sm font-medium text-slate-700">Warehouse Code *</label>
      <Input
        id="code"
        v-model="form.code"
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
        {{ isSubmitting ? 'Saving...' : (isEditing ? 'Update' : 'Create') }} Warehouse
      </Button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import { Button } from '@/components/ui/button'
import { Input } from '@/components/ui/input'
import type { Warehouse } from '@/types/api'

interface Props {
  warehouse?: Warehouse | null
  isSubmitting?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  warehouse: null,
  isSubmitting: false
})

const emit = defineEmits<{
  submit: [data: any]
  cancel: []
}>()

const isEditing = Boolean(props.warehouse)

const form = ref({
  code: '',
  name: '',
  is_active: true
})

// Watch for warehouse changes and update form
watch(
  () => props.warehouse,
  (warehouse) => {
    if (warehouse) {
      form.value = {
        code: warehouse.code,
        name: warehouse.name,
        is_active: warehouse.is_active
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
