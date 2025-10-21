<template>
  <Dialog v-model:open="isOpen">
    <DialogContent class="max-w-5xl max-h-[90vh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>{{ showTemplateSelector ? 'Create New App' : 'Configure Your App' }}</DialogTitle>
        <DialogDescription>
          {{ showTemplateSelector ? 'Choose a template to get started quickly, or start from scratch' : 'Complete the setup wizard to deploy your app' }}
        </DialogDescription>
      </DialogHeader>

      <!-- Template Selector (First Screen) -->
      <div v-if="showTemplateSelector" class="py-6">
        <TemplateSelector
          :show-as-inline="true"
          @select="handleTemplateSelect"
        />
      </div>

      <!-- Wizard Steps (After Template Selection) -->
      <div v-else>
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
            <StepRuntime
              v-else-if="step === 1"
              v-model="formData.runtime"
            />
            <StepBuildConfig
              v-else-if="step === 2"
              v-model="formData.buildConfig"
            />
            <StepGitDeploy
              v-else-if="step === 3"
              v-model="formData.gitDeploy"
            />
            <StepReview
              v-else-if="step === 4"
              :data="formData"
              @edit="goToStep"
            />
          </template>
        </WizardContainer>
      </div>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import { toast } from 'vue-sonner'
import WizardContainer from './wizard/WizardContainer.vue'
import TemplateSelector from './wizard/TemplateSelector.vue'
import StepBasics from './wizard/steps/StepBasics.vue'
import StepRuntime from './wizard/steps/StepRuntime.vue'
import StepBuildConfig from './wizard/steps/StepBuildConfig.vue'
import StepGitDeploy from './wizard/steps/StepGitDeploy.vue'
import StepReview from './wizard/steps/StepReview.vue'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'
import type { AppTemplate } from './wizard/templates'
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
  'cancel': []
}>()

const isOpen = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

const currentStep = ref(0)
const showTemplateSelector = ref(true)

const formData = ref({
  basics: {
    name: '',
    subdomain: '',
    description: '',
    region: 'us-east'
  },
  runtime: {
    runtime: '',
    runtimeVersion: '',
    framework: '',
    customFramework: false
  },
  buildConfig: {
    installCommand: '',
    buildCommand: '',
    startCommand: '',
    rootDirectory: '/',
    envVars: [] as Array<{ key: string; value: string }>
  },
  gitDeploy: {
    gitUrl: '',
    branch: 'main',
    autoDeploy: true,
    notifications: false
  }
})

const wizardSteps = computed(() => [
  { id: 'basics', label: 'Basics', isValid: isBasicsValid.value },
  { id: 'runtime', label: 'Runtime', isValid: isRuntimeValid.value },
  { id: 'build', label: 'Build', isValid: isBuildValid.value },
  { id: 'deploy', label: 'Deploy', isValid: isDeployValid.value },
  { id: 'review', label: 'Review', isValid: true }
])

const isBasicsValid = computed(() => {
  return !!(formData.value.basics.name && formData.value.basics.subdomain)
})

const isRuntimeValid = computed(() => {
  return !!(formData.value.runtime.runtime && formData.value.runtime.runtimeVersion)
})

const isBuildValid = computed(() => {
  return !!formData.value.buildConfig.startCommand
})

const isDeployValid = computed(() => {
  return !!formData.value.gitDeploy.gitUrl
})

const canProceedToNextStep = computed(() => {
  switch (currentStep.value) {
    case 0:
      return isBasicsValid.value
    case 1:
      return isRuntimeValid.value
    case 2:
      return isBuildValid.value
    case 3:
      return isDeployValid.value
    default:
      return true
  }
})

function handleTemplateSelect(template: AppTemplate | null) {
  // Close template selector and show wizard
  showTemplateSelector.value = false

  if (template) {
    // Pre-fill form with template data
    formData.value.runtime.runtime = template.runtime
    formData.value.runtime.runtimeVersion = template.runtimeVersion
    formData.value.runtime.framework = template.framework
    formData.value.buildConfig.installCommand = template.installCommand
    formData.value.buildConfig.buildCommand = template.buildCommand
    formData.value.buildConfig.startCommand = template.startCommand
    formData.value.gitDeploy.branch = template.branch
    if (template.envVars) {
      formData.value.buildConfig.envVars = [...template.envVars]
    }

    toast.success(`Using ${template.name} template`, {
      description: 'Configuration has been pre-filled for you'
    })
  }
}

function handleCancel() {
  emit('cancel')
  emit('update:open', false)
}

function goToStep(step: number) {
  currentStep.value = step
}

function handleSubmit() {
  // Combine all form data
  const submitData = {
    name: formData.value.basics.name,
    subdomain: formData.value.basics.subdomain,
    description: formData.value.basics.description,
    git_url: formData.value.gitDeploy.gitUrl,
    status: 'stopped'
    // In a real implementation, you'd send runtime, buildConfig, etc. to different endpoints
    // or include them in a more comprehensive app configuration
  }

  emit('submit', submitData)
}

// Draft saving
const DRAFT_KEY = 'app-wizard-draft'

function saveDraft() {
  localStorage.setItem(DRAFT_KEY, JSON.stringify({
    currentStep: currentStep.value,
    formData: formData.value,
    timestamp: Date.now()
  }))
}

function loadDraft() {
  const draft = localStorage.getItem(DRAFT_KEY)
  if (draft) {
    try {
      const parsed = JSON.parse(draft)
      // Only load if draft is less than 24 hours old
      if (Date.now() - parsed.timestamp < 24 * 60 * 60 * 1000) {
        currentStep.value = parsed.currentStep || 0
        formData.value = parsed.formData
        showTemplateSelector.value = false
        toast.success('Draft restored', {
          description: 'Your previous session has been restored'
        })
      } else {
        clearDraft()
      }
    } catch {
      clearDraft()
    }
  }
}

function clearDraft() {
  localStorage.removeItem(DRAFT_KEY)
}

// Auto-save draft
watch([currentStep, formData], () => {
  saveDraft()
}, { deep: true })

// Reset wizard when dialog opens
watch(() => props.open, (isOpen) => {
  if (isOpen) {
    // Check for existing draft
    const hasDraft = localStorage.getItem(DRAFT_KEY)
    if (hasDraft) {
      loadDraft()
    } else {
      // Reset to initial state
      showTemplateSelector.value = true
      currentStep.value = 0
    }
  }
})

// Load draft on mount
onMounted(() => {
  // Check for existing draft
  const hasDraft = localStorage.getItem(DRAFT_KEY)
  if (hasDraft) {
    loadDraft()
  }
})

// Clear draft on successful submit
watch(() => props.isSubmitting, (isSubmitting) => {
  if (!isSubmitting && currentStep.value === 4) {
    clearDraft()
  }
})
</script>
