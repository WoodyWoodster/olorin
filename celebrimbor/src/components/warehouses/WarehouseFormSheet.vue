<template>
  <Sheet v-model:open="isOpen">
    <SheetContent class="sm:max-w-2xl overflow-y-auto">
      <SheetHeader>
        <SheetTitle>{{ warehouseId ? 'Edit Warehouse' : 'New Warehouse' }}</SheetTitle>
        <SheetDescription>
          {{ warehouseId ? 'Update warehouse information below.' : 'Fill out the form to create a new warehouse.' }}
        </SheetDescription>
      </SheetHeader>

      <div class="mt-6 px-6">
        <WarehouseForm
          ref="warehouseFormRef"
          :warehouse="existingWarehouse"
          :is-submitting="mutation.isPending.value"
          @submit="handleSubmit"
          @cancel="handleCancel"
        />
      </div>
    </SheetContent>
  </Sheet>

  <!-- Unsaved Changes Confirmation Dialog -->
  <AlertDialog v-model:open="showConfirmDialog">
    <AlertDialogContent>
      <AlertDialogHeader>
        <AlertDialogTitle>Unsaved changes</AlertDialogTitle>
        <AlertDialogDescription>
          You have unsaved changes. Are you sure you want to close? Your changes will be lost.
        </AlertDialogDescription>
      </AlertDialogHeader>
      <AlertDialogFooter>
        <AlertDialogCancel @click="cancelClose">Continue editing</AlertDialogCancel>
        <AlertDialogAction @click="confirmClose">Discard changes</AlertDialogAction>
      </AlertDialogFooter>
    </AlertDialogContent>
  </AlertDialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { useWarehouse, useCreateWarehouse, useUpdateWarehouse } from '@/composables/useWarehouses'
import { useFormDirty } from '@/composables/useFormDirty'
import WarehouseForm from './WarehouseForm.vue'
import {
  Sheet,
  SheetContent,
  SheetDescription,
  SheetHeader,
  SheetTitle,
} from '@/components/ui/sheet'
import {
  AlertDialog,
  AlertDialogAction,
  AlertDialogCancel,
  AlertDialogContent,
  AlertDialogDescription,
  AlertDialogFooter,
  AlertDialogHeader,
  AlertDialogTitle,
} from '@/components/ui/alert-dialog'

interface Props {
  warehouseId?: number | null
  open?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  warehouseId: null,
  open: false
})

const emit = defineEmits<{
  'update:open': [value: boolean]
  'success': []
}>()

const isOpen = computed({
  get: () => props.open,
  set: (value) => {
    if (!value) {
      handleClose()
    } else {
      emit('update:open', value)
    }
  }
})

const warehouseFormRef = ref<InstanceType<typeof WarehouseForm> | null>(null)
const showConfirmDialog = ref(false)
const pendingClose = ref(false)

// Load existing warehouse if editing
const { data: existingWarehouse } = useWarehouse(props.warehouseId?.toString() || '')

// Track form dirty state
const { isDirty, resetDirty, markClean } = useFormDirty(
  computed(() => warehouseFormRef.value?.form || {})
)

// Mutations
const createMutation = useCreateWarehouse()
const updateMutation = useUpdateWarehouse()
const mutation = computed(() => props.warehouseId ? updateMutation : createMutation)

// Reset dirty state when warehouse data loads
watch(existingWarehouse, () => {
  if (existingWarehouse.value) {
    resetDirty()
  }
})

// Handle form submission
async function handleSubmit(formData: any) {
  try {
    if (props.warehouseId) {
      await updateMutation.mutateAsync({
        id: props.warehouseId,
        data: { warehouse: formData }
      })
    } else {
      await createMutation.mutateAsync({ warehouse: formData })
    }
    markClean()
    emit('update:open', false)
    emit('success')
  } catch (error) {
    console.error('Error saving warehouse:', error)
  }
}

// Handle cancel button
function handleCancel() {
  handleClose()
}

// Handle close with dirty check
function handleClose() {
  if (isDirty.value) {
    showConfirmDialog.value = true
    pendingClose.value = true
  } else {
    emit('update:open', false)
  }
}

// Confirm closing and discard changes
function confirmClose() {
  showConfirmDialog.value = false
  pendingClose.value = false
  emit('update:open', false)
}

// Cancel closing and continue editing
function cancelClose() {
  showConfirmDialog.value = false
  pendingClose.value = false
}
</script>
