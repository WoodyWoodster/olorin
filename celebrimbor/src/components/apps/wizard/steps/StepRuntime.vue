<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Runtime & Framework</h2>
      <p class="text-muted-foreground mt-1">Select the runtime environment and framework for your app</p>
    </div>

    <div class="space-y-4">
      <!-- Runtime -->
      <div class="space-y-2">
        <Label for="runtime">Runtime *</Label>
        <select
          id="runtime"
          v-model="localData.runtime"
          @change="onRuntimeChange"
          class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
          required
        >
          <option value="">Select a runtime...</option>
          <option
            v-for="runtime in runtimeOptions"
            :key="runtime.value"
            :value="runtime.value"
          >
            {{ runtime.label }}
          </option>
        </select>
        <p class="text-sm text-muted-foreground">The programming language/runtime for your app</p>
      </div>

      <!-- Runtime Version -->
      <div v-if="localData.runtime" class="space-y-2">
        <Label for="runtime-version">Version *</Label>
        <select
          id="runtime-version"
          v-model="localData.runtimeVersion"
          class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
          required
        >
          <option value="">Select a version...</option>
          <option
            v-for="version in availableVersions"
            :key="version"
            :value="version"
          >
            {{ version }}
          </option>
        </select>
      </div>

      <!-- Framework -->
      <div v-if="localData.runtime" class="space-y-2">
        <Label for="framework">Framework</Label>
        <select
          id="framework"
          v-model="localData.framework"
          class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
        >
          <option value="">Select a framework...</option>
          <option
            v-for="framework in availableFrameworks"
            :key="framework"
            :value="framework"
          >
            {{ framework }}
          </option>
        </select>
        <p class="text-sm text-muted-foreground">Optional: Choose a framework if you're using one</p>
      </div>

      <!-- Custom Framework -->
      <div v-if="localData.framework && localData.framework !== 'None'" class="space-y-2">
        <Label>
          <input
            type="checkbox"
            v-model="localData.customFramework"
            class="mr-2"
          />
          Using a custom or unlisted framework
        </Label>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, computed, watch } from 'vue'
import { Label } from '@/components/ui/label'
import { RUNTIME_OPTIONS, FRAMEWORK_OPTIONS } from '../templates'

interface RuntimeData {
  runtime: string
  runtimeVersion: string
  framework: string
  customFramework: boolean
}

interface Props {
  modelValue: RuntimeData
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: RuntimeData]
}>()

const localData = reactive<RuntimeData>({
  runtime: props.modelValue.runtime || '',
  runtimeVersion: props.modelValue.runtimeVersion || '',
  framework: props.modelValue.framework || '',
  customFramework: props.modelValue.customFramework || false
})

const runtimeOptions = RUNTIME_OPTIONS

const availableVersions = computed(() => {
  const runtime = runtimeOptions.find(r => r.value === localData.runtime)
  return runtime?.versions || []
})

const availableFrameworks = computed(() => {
  return FRAMEWORK_OPTIONS[localData.runtime] || []
})

function onRuntimeChange() {
  // Reset version and framework when runtime changes
  localData.runtimeVersion = ''
  localData.framework = ''
  localData.customFramework = false
}

watch(localData, (newValue) => {
  emit('update:modelValue', { ...newValue })
}, { deep: true })
</script>
