<template>
  <Sheet v-model:open="isOpen">
    <SheetContent class="sm:max-w-2xl overflow-y-auto">
      <SheetHeader>
        <SheetTitle>Edit App</SheetTitle>
        <SheetDescription>
          Update app information below.
        </SheetDescription>
      </SheetHeader>

      <div class="mt-6 px-6">
        <AppForm
          ref="appFormRef"
          :app="existingApp"
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
import { toast } from 'vue-sonner'
import { useApp, useUpdateApp } from '@/composables/useApps'
import { useFormDirty } from '@/composables/useFormDirty'
import type { AppFormData } from '@/types/api'
import AppForm from './AppForm.vue'
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
  appId: number
  open?: boolean
}

const props = withDefaults(defineProps<Props>(), {
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

const appFormRef = ref<InstanceType<typeof AppForm> | null>(null)
const showConfirmDialog = ref(false)
const pendingClose = ref(false)

// Load existing app
const { data: existingApp } = useApp(props.appId.toString())

// Track form dirty state
const { isDirty, resetDirty, markClean } = useFormDirty(
  computed(() => appFormRef.value?.form || {})
)

// Mutation
const mutation = useUpdateApp()

// Reset dirty state when app data loads
watch(existingApp, () => {
  if (existingApp.value) {
    resetDirty()
  }
})

// Handle form submission
async function handleSubmit(formData: AppFormData) {
  try {
    await mutation.mutateAsync({
      id: props.appId,
      data: { app: formData }
    })
    const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    toast.success('App updated successfully', {
      description: `${formData.name} (${formData.subdomain}) - ${time}`
    })
    markClean()
    emit('update:open', false)
    emit('success')
  } catch (error: unknown) {
    console.error('Error updating app:', error)
    const errorMessage = error instanceof Error ? error.message : 'An unexpected error occurred'
    toast.error('Failed to update app', {
      description: errorMessage
    })
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
