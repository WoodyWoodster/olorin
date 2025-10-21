<template>
  <Sheet v-model:open="isOpen">
    <SheetContent class="sm:max-w-2xl overflow-y-auto">
      <SheetHeader>
        <SheetTitle>{{ productId ? 'Edit Product' : 'New Product' }}</SheetTitle>
        <SheetDescription>
          {{ productId ? 'Update product information below.' : 'Fill out the form to create a new product.' }}
        </SheetDescription>
      </SheetHeader>

      <div class="mt-6 px-6">
        <ProductForm
          ref="productFormRef"
          :product="existingProduct"
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
import { useProduct, useCreateProduct, useUpdateProduct } from '@/composables/useProducts'
import { useFormDirty } from '@/composables/useFormDirty'
import ProductForm from './ProductForm.vue'
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
  productId?: number | null
  open?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  productId: null,
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
      // User is trying to close - check if dirty
      handleClose()
    } else {
      emit('update:open', value)
    }
  }
})

const productFormRef = ref<InstanceType<typeof ProductForm> | null>(null)
const showConfirmDialog = ref(false)
const pendingClose = ref(false)

// Load existing product if editing
const { data: existingProduct } = useProduct(props.productId?.toString() || '')

// Track form dirty state
const { isDirty, resetDirty, markClean } = useFormDirty(
  computed(() => productFormRef.value?.form || {})
)

// Mutations
const createMutation = useCreateProduct()
const updateMutation = useUpdateProduct()
const mutation = computed(() => props.productId ? updateMutation : createMutation)

// Reset dirty state when product data loads
watch(existingProduct, () => {
  if (existingProduct.value) {
    resetDirty()
  }
})

// Handle form submission
async function handleSubmit(formData: any) {
  try {
    if (props.productId) {
      await updateMutation.mutateAsync({
        id: props.productId,
        data: { product: formData }
      })
    } else {
      await createMutation.mutateAsync({ product: formData })
    }
    markClean()
    emit('update:open', false)
    emit('success')
  } catch (error) {
    console.error('Error saving product:', error)
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
