<template>
  <Dialog v-model:open="isOpen">
    <DialogContent class="w-[95vw] max-w-[1600px] max-h-[90vh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>Create New App</DialogTitle>
        <DialogDescription>
          Complete the setup wizard to deploy your app with auto-detected Dockerfiles
        </DialogDescription>
      </DialogHeader>

      <WizardContainer
        v-model="currentStep"
        :steps="wizardSteps"
        :can-proceed="canProceedToNextStep"
        :is-submitting="isSubmitting"
        @submit="handleSubmit"
        @cancel="handleCancel"
      >
        <template #default="{ currentStep: step }">
          <StepBasics
            v-if="step === 0"
            v-model="formData.basics"
          />
          <StepDockerfileDetection
            v-else-if="step === 1"
            v-model="formData.dockerfileData"
          />
          <StepReview
            v-else-if="step === 2"
            :data="formData"
            @edit="goToStep"
          />
        </template>
      </WizardContainer>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { toast } from 'vue-sonner'
import WizardContainer from './wizard/WizardContainer.vue'
import StepBasics from './wizard/steps/StepBasics.vue'
import StepDockerfileDetection from './wizard/steps/StepDockerfileDetection.vue'
import StepReview from './wizard/steps/StepReview.vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import type { AppFormData } from '@/types/api'

interface Props {
  open?: boolean
  isSubmitting?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  open: false,
  isSubmitting: false
})

const emit = defineEmits<{
  'update:open': [value: boolean]
  'submit': [data: AppFormData]
  'submit-multiple': [apps: AppFormData[]]
  'cancel': []
}>()

const isOpen = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

const currentStep = ref(0)

const formData = ref({
  basics: {
    name: '',
    subdomain: '',
    description: '',
    gitUrl: '',
    branch: 'main'
  },
  dockerfileData: {
    detectedDockerfiles: [] as Array<{
      path: string
      base_image: string
      runtime?: string
      version?: string
      port?: number
      start_command?: string
    }>,
    selectedDockerfiles: [] as string[],
    gitUrl: '',
    branch: '',
    appBaseName: ''
  }
})

const wizardSteps = computed(() => [
  { id: 'basics', label: 'Basics', isValid: isBasicsValid.value },
  { id: 'dockerfile', label: 'Dockerfile Detection', isValid: isDockerfileValid.value },
  { id: 'review', label: 'Review', isValid: true }
])

const isBasicsValid = computed(() => {
  return !!(
    formData.value.basics.name &&
    formData.value.basics.subdomain &&
    formData.value.basics.gitUrl
  )
})

const isDockerfileValid = computed(() => {
  return formData.value.dockerfileData.selectedDockerfiles.length > 0
})

const canProceedToNextStep = computed(() => {
  switch (currentStep.value) {
    case 0:
      return isBasicsValid.value
    case 1:
      return isDockerfileValid.value
    default:
      return true
  }
})

function handleCancel() {
  emit('cancel')
  emit('update:open', false)
}

function goToStep(step: number) {
  currentStep.value = step
}

function getSuffixFromPath(path: string): string {
  // Extract meaningful suffix from Dockerfile path
  // e.g., "./backend/Dockerfile.prod" -> "backend"
  // e.g., "./Dockerfile" -> ""
  const parts = path.split('/')
  const directory = parts[parts.length - 2]

  if (directory && directory !== '.' && directory !== '..') {
    return directory
  }

  // Check if filename has a suffix (e.g., "Dockerfile.frontend")
  const filename = parts[parts.length - 1]
  const filenameParts = filename.split('.')
  if (filenameParts.length > 2) {
    return filenameParts[filenameParts.length - 1]
  }

  return ''
}

function handleSubmit() {
  const selectedDockerfiles = formData.value.dockerfileData.selectedDockerfiles

  if (selectedDockerfiles.length === 1) {
    const dockerfilePath = selectedDockerfiles[0]
    const submitData: AppFormData = {
      name: formData.value.basics.name,
      subdomain: formData.value.basics.subdomain,
      description: formData.value.basics.description,
      git_url: formData.value.basics.gitUrl,
      branch: formData.value.basics.branch,
      dockerfile_path: dockerfilePath,
      status: 'stopped'
    }

    emit('submit', submitData)
  } else {
    const apps: AppFormData[] = selectedDockerfiles.map(dockerfilePath => {
      const suffix = getSuffixFromPath(dockerfilePath)

      return {
        name: suffix ? `${formData.value.basics.name}-${suffix}` : formData.value.basics.name,
        subdomain: suffix ? `${formData.value.basics.subdomain}-${suffix}` : formData.value.basics.subdomain,
        description: formData.value.basics.description,
        git_url: formData.value.basics.gitUrl,
        branch: formData.value.basics.branch,
        dockerfile_path: dockerfilePath,
        status: 'stopped'
      }
    })

    emit('submit-multiple', apps)
  }
}

const DRAFT_KEY = 'app-wizard-draft'

function saveDraft() {
  localStorage.setItem(DRAFT_KEY, JSON.stringify({
    currentStep: currentStep.value,
    formData: formData.value,
    timestamp: Date.now()
  }))
}

function loadDraft(): boolean {
  const draft = localStorage.getItem(DRAFT_KEY)
  if (draft) {
    try {
      const parsed = JSON.parse(draft)
      if (Date.now() - parsed.timestamp < 24 * 60 * 60 * 1000) {
        if (parsed.formData?.dockerfileData) {
          currentStep.value = parsed.currentStep || 0
          formData.value = parsed.formData
          toast.success('Draft restored', {
            description: 'Your previous session has been restored'
          })
          return true
        } else {
          clearDraft()
          return false
        }
      } else {
        clearDraft()
        return false
      }
    } catch {
      clearDraft()
      return false
    }
  }
  return false
}

function clearDraft() {
  localStorage.removeItem(DRAFT_KEY)
}

watch([currentStep, formData], () => {
  saveDraft()
}, { deep: true })

watch(() => formData.value.basics.gitUrl, (newUrl) => {
  if (formData.value.dockerfileData) {
    formData.value.dockerfileData.gitUrl = newUrl
  }
})

watch(() => formData.value.basics.branch, (newBranch) => {
  if (formData.value.dockerfileData) {
    formData.value.dockerfileData.branch = newBranch
  }
})

watch(() => formData.value.basics.name, (newName) => {
  if (formData.value.dockerfileData) {
    formData.value.dockerfileData.appBaseName = newName
  }
})

function resetForm() {
  currentStep.value = 0
  formData.value = {
    basics: {
      name: '',
      subdomain: '',
      description: '',
      gitUrl: '',
      branch: 'main'
    },
    dockerfileData: {
      detectedDockerfiles: [],
      selectedDockerfiles: [],
      gitUrl: '',
      branch: '',
      appBaseName: ''
    }
  }
}

watch(() => props.open, (isOpen) => {
  if (isOpen) {
    const hasDraft = localStorage.getItem(DRAFT_KEY)
    if (hasDraft) {
      const loaded = loadDraft()
      if (!loaded) {
        resetForm()
      }
    } else {
      resetForm()
    }
  } else {
    clearDraft()
    resetForm()
  }
})

watch(() => props.isSubmitting, (isSubmitting) => {
  if (!isSubmitting && currentStep.value === 2) {
    clearDraft()
  }
})
</script>
