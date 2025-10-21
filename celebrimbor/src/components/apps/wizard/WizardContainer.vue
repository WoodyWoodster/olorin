<template>
  <div class="space-y-8">
    <!-- Progress Stepper -->
    <div class="flex items-center justify-center max-w-2xl mx-auto">
      <div
        v-for="(step, index) in steps"
        :key="step.id"
        class="flex items-center"
      >
        <!-- Step Circle -->
        <button
          @click="canNavigateToStep(index) && goToStep(index)"
          :disabled="!canNavigateToStep(index)"
          class="group flex flex-col items-center gap-2 transition-all"
        >
          <div
            class="flex h-10 w-10 items-center justify-center rounded-full border-2 transition-all"
            :class="{
              'border-primary bg-primary text-primary-foreground': currentStep === index,
              'border-secondary bg-secondary text-secondary-foreground': currentStep > index,
              'border-muted-foreground/30 bg-background text-muted-foreground': currentStep < index
            }"
          >
            <Check
              v-if="currentStep > index"
              class="h-5 w-5"
            />
            <span v-else class="text-sm font-medium">{{ index + 1 }}</span>
          </div>
          <span
            class="text-xs font-medium transition-colors whitespace-nowrap"
            :class="{
              'text-foreground': currentStep >= index,
              'text-muted-foreground': currentStep < index
            }"
          >
            {{ step.label }}
          </span>
        </button>

        <!-- Connector Line -->
        <div
          v-if="index < steps.length - 1"
          class="mx-4 h-0.5 w-32 transition-colors"
          :class="{
            'bg-secondary': currentStep > index,
            'bg-muted-foreground/20': currentStep <= index
          }"
        />
      </div>
    </div>

    <!-- Step Content -->
    <div class="min-h-[400px]">
      <Transition
        :name="transitionName"
        mode="out-in"
      >
        <div :key="currentStep">
          <slot :current-step="currentStep" />
        </div>
      </Transition>
    </div>

    <!-- Navigation -->
    <div class="flex items-center justify-between border-t pt-6">
      <Button
        v-if="currentStep > 0"
        variant="outline"
        @click="previousStep"
        :disabled="isSubmitting"
      >
        <ChevronLeft class="mr-2 h-4 w-4" />
        Back
      </Button>
      <Button
        v-else
        variant="ghost"
        @click="$emit('cancel')"
        :disabled="isSubmitting"
      >
        Cancel
      </Button>

      <div class="flex gap-3">
        <Button
          v-if="currentStep < steps.length - 1"
          @click="nextStep"
          :disabled="!canProceed || isSubmitting"
        >
          Continue
          <ChevronRight class="ml-2 h-4 w-4" />
        </Button>
        <Button
          v-else
          @click="$emit('submit')"
          :disabled="isSubmitting"
        >
          {{ isSubmitting ? 'Creating...' : 'Create App' }}
        </Button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { Check, ChevronLeft, ChevronRight } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'

interface WizardStep {
  id: string
  label: string
  isValid: boolean
}

interface Props {
  steps: WizardStep[]
  modelValue: number
  canProceed?: boolean
  isSubmitting?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  canProceed: true,
  isSubmitting: false
})

const emit = defineEmits<{
  'update:modelValue': [value: number]
  'submit': []
  'cancel': []
}>()

const transitionDirection = ref<'forward' | 'backward'>('forward')

const currentStep = computed({
  get: () => props.modelValue,
  set: (value) => emit('update:modelValue', value)
})

const transitionName = computed(() => {
  return transitionDirection.value === 'forward' ? 'slide-left' : 'slide-right'
})

function canNavigateToStep(stepIndex: number): boolean {
  // Can only go back to completed steps
  return stepIndex < currentStep.value
}

function goToStep(stepIndex: number) {
  if (stepIndex < currentStep.value) {
    transitionDirection.value = 'backward'
    currentStep.value = stepIndex
  }
}

function nextStep() {
  if (currentStep.value < props.steps.length - 1) {
    transitionDirection.value = 'forward'
    currentStep.value++
  }
}

function previousStep() {
  if (currentStep.value > 0) {
    transitionDirection.value = 'backward'
    currentStep.value--
  }
}
</script>

<style scoped>
/* Slide Left (Forward) */
.slide-left-enter-active,
.slide-left-leave-active {
  transition: all 0.3s ease-in-out;
}

.slide-left-enter-from {
  opacity: 0;
  transform: translateX(20px);
}

.slide-left-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}

/* Slide Right (Backward) */
.slide-right-enter-active,
.slide-right-leave-active {
  transition: all 0.3s ease-in-out;
}

.slide-right-enter-from {
  opacity: 0;
  transform: translateX(-20px);
}

.slide-right-leave-to {
  opacity: 0;
  transform: translateX(20px);
}
</style>
