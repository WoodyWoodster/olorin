<template>
  <Sheet v-model:open="isOpen">
    <SheetContent class="sm:max-w-2xl overflow-y-auto">
      <SheetHeader>
        <SheetTitle>{{ appId ? 'Edit App' : 'New App' }}</SheetTitle>
        <SheetDescription>
          {{ appId ? 'Update app information below.' : 'Fill out the form to create a new app.' }}
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
import { useApp, useCreateApp, useUpdateApp } from '@/composables/useApps'
import { useFormDirty } from '@/composables/useFormDirty'
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
  appId?: number | null
  open?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  appId: null,
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

// Load existing app if editing
const { data: existingApp } = useApp(props.appId?.toString() || '')

// Track form dirty state
const { isDirty, resetDirty, markClean } = useFormDirty(
  computed(() => appFormRef.value?.form || {})
)

// Mutations
const createMutation = useCreateApp()
const updateMutation = useUpdateApp()
const mutation = computed(() => props.appId ? updateMutation : createMutation)

// Reset dirty state when app data loads
watch(existingApp, () => {
  if (existingApp.value) {
    resetDirty()
  }
})

// Handle form submission
async function handleSubmit(formData: any) {
  try {
    let result
    if (props.appId) {
      result = await updateMutation.mutateAsync({
        id: props.appId,
        data: { app: formData }
      })
      const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      toast.success('App updated successfully', {
        description: `${formData.name} (${formData.subdomain}) - ${time}`
      })
    } else {
      result = await createMutation.mutateAsync({ app: formData })
      const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
      toast.success('App created successfully', {
        description: `${formData.name} (${formData.subdomain}) - ${time}`
      })
    }
    markClean()
    emit('update:open', false)
    emit('success')
  } catch (error: any) {
    console.error('Error saving app:', error)
    toast.error(props.appId ? 'Failed to update app' : 'Failed to create app', {
      description: error?.message || 'An unexpected error occurred'
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
