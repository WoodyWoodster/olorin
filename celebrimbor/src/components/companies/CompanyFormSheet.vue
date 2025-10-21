<template>
  <Sheet v-model:open="isOpen">
    <SheetContent class="sm:max-w-2xl overflow-y-auto">
      <SheetHeader>
        <SheetTitle>{{ companyId ? 'Edit Company' : 'New Company' }}</SheetTitle>
        <SheetDescription>
          {{ companyId ? 'Update company information below.' : 'Fill out the form to create a new company.' }}
        </SheetDescription>
      </SheetHeader>

      <div class="mt-6 px-6">
        <CompanyForm
          ref="companyFormRef"
          :company="existingCompany"
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
import { useCompany, useCreateCompany, useUpdateCompany } from '@/composables/useCompanies'
import { useFormDirty } from '@/composables/useFormDirty'
import CompanyForm from './CompanyForm.vue'
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
  companyId?: number | null
  open?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  companyId: null,
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

const companyFormRef = ref<InstanceType<typeof CompanyForm> | null>(null)
const showConfirmDialog = ref(false)
const pendingClose = ref(false)

// Load existing company if editing
const { data: existingCompany } = useCompany(props.companyId?.toString() || '')

// Track form dirty state
const { isDirty, resetDirty, markClean } = useFormDirty(
  computed(() => companyFormRef.value?.form || {})
)

// Mutations
const createMutation = useCreateCompany()
const updateMutation = useUpdateCompany()
const mutation = computed(() => props.companyId ? updateMutation : createMutation)

// Reset dirty state when company data loads
watch(existingCompany, () => {
  if (existingCompany.value) {
    resetDirty()
  }
})

// Handle form submission
async function handleSubmit(formData: any) {
  try {
    if (props.companyId) {
      await updateMutation.mutateAsync({
        id: props.companyId,
        data: { company: formData }
      })
    } else {
      await createMutation.mutateAsync({ company: formData })
    }
    markClean()
    emit('update:open', false)
    emit('success')
  } catch (error) {
    console.error('Error saving company:', error)
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
