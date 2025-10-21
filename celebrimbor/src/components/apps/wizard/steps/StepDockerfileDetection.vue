<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Dockerfile Detection</h2>
      <p class="text-muted-foreground mt-1">Scanning your repository for Dockerfiles...</p>
    </div>

    <!-- Loading State -->
    <div v-if="isDetecting" class="flex flex-col items-center justify-center py-12">
      <div class="animate-spin rounded-full h-12 w-12 border-b-2 border-orange-600"></div>
      <p class="mt-4 text-sm text-stone-600">Analyzing repository...</p>
      <p class="text-xs text-stone-500">{{ statusMessage }}</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="rounded-xl border border-red-200 bg-red-50 p-6">
      <div class="flex items-start gap-3">
        <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-red-100">
          <span class="text-xl">⚠️</span>
        </div>
        <div class="flex-1">
          <h3 class="font-semibold text-red-900">{{ error.title }}</h3>
          <p class="text-sm text-red-700 mt-1">{{ error.message }}</p>
          <div v-if="error.suggestion" class="mt-3 text-sm text-red-600">
            <strong>Suggestion:</strong> {{ error.suggestion }}
          </div>
        </div>
      </div>
    </div>

    <!-- Detected Dockerfiles -->
    <div v-else-if="detectedDockerfiles.length > 0" class="space-y-4">
      <div class="flex items-center justify-between mb-2">
        <p class="text-sm font-medium text-stone-700">
          Found {{ detectedDockerfiles.length }} Dockerfile{{ detectedDockerfiles.length > 1 ? 's' : '' }}
        </p>
        <p class="text-xs text-stone-500">
          Select which ones to deploy
        </p>
      </div>

      <div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        <div
          v-for="dockerfile in detectedDockerfiles"
          :key="dockerfile.path"
          class="relative rounded-lg border-2 transition-all cursor-pointer"
          :class="isSelected(dockerfile.path)
            ? 'border-orange-500 bg-orange-50'
            : 'border-stone-200 bg-white hover:border-orange-300 hover:shadow-sm'"
          @click="toggleSelection(dockerfile.path)"
        >
          <div class="p-3">
            <!-- Checkbox & Path -->
            <div class="flex items-start gap-2 mb-3">
              <input
                type="checkbox"
                :checked="isSelected(dockerfile.path)"
                class="mt-0.5 h-4 w-4 rounded border-stone-300 text-orange-600 focus:ring-orange-500 flex-shrink-0"
                @click.stop="toggleSelection(dockerfile.path)"
              />
              <div class="flex-1 min-w-0">
                <div class="flex items-center justify-between gap-2">
                  <span class="text-xs font-mono bg-stone-100 px-2 py-0.5 rounded text-stone-900 truncate block">
                    {{ dockerfile.path }}
                  </span>
                  <span class="text-xl flex-shrink-0">🐳</span>
                </div>
              </div>
            </div>

            <!-- Runtime Info -->
            <div class="space-y-1.5 text-xs">
              <div class="flex items-start gap-2">
                <span class="text-stone-500 font-medium min-w-[70px]">Base:</span>
                <code class="font-mono text-stone-900 break-all flex-1">{{ dockerfile.base_image }}</code>
              </div>

              <div v-if="dockerfile.runtime" class="flex items-center gap-2">
                <span class="text-stone-500 font-medium min-w-[70px]">Runtime:</span>
                <span class="font-semibold text-green-700">
                  {{ dockerfile.runtime }} {{ dockerfile.version }}
                </span>
              </div>

              <div v-if="dockerfile.port" class="flex items-center gap-2">
                <span class="text-stone-500 font-medium min-w-[70px]">Port:</span>
                <code class="font-mono text-stone-900">{{ dockerfile.port }}</code>
              </div>

              <div v-if="dockerfile.start_command" class="pt-1 border-t border-stone-200">
                <span class="text-stone-500 font-medium block mb-1">Start:</span>
                <code class="font-mono bg-stone-50 px-2 py-1 rounded block text-stone-900 break-all text-[10px] leading-tight">
                  {{ dockerfile.start_command }}
                </code>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Selection Warning -->
      <div v-if="selectedDockerfiles.length === 0" class="rounded-lg border border-amber-300 bg-amber-50 p-3">
        <div class="flex items-center gap-2">
          <span class="text-lg">⚠️</span>
          <p class="text-sm text-amber-900 font-medium">
            Please select at least one Dockerfile to proceed
          </p>
        </div>
      </div>

      <!-- Multi-App Notice -->
      <div v-if="selectedDockerfiles.length > 1" class="rounded-lg border border-blue-300 bg-blue-50 p-3">
        <div class="flex items-center gap-2">
          <span class="text-lg">ℹ️</span>
          <p class="text-sm text-blue-900">
            Multiple Dockerfiles selected — <strong>{{ selectedDockerfiles.length }} separate apps</strong> will be created
            <span class="text-blue-700">(e.g., {{ appBaseName }}-frontend, {{ appBaseName }}-backend)</span>
          </p>
        </div>
      </div>
    </div>

    <!-- No Dockerfiles Found -->
    <div v-else class="rounded-xl border border-stone-200 bg-stone-50 p-6 text-center">
      <div class="flex flex-col items-center">
        <span class="text-4xl mb-3">📄</span>
        <h3 class="font-semibold text-stone-900">No Dockerfiles Found</h3>
        <p class="text-sm text-stone-600 mt-2">
          We couldn't find any Dockerfiles in your repository.
        </p>
        <p class="text-sm text-stone-500 mt-4">
          Please add a <code class="bg-stone-200 px-2 py-0.5 rounded">Dockerfile</code> or
          <code class="bg-stone-200 px-2 py-0.5 rounded">Dockerfile.prod</code> to your repository root.
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, watch, onMounted, onUnmounted, computed } from 'vue'
import type { Subscription } from '@rails/actioncable'
import cable from '@/utils/actioncable'

interface DetectedDockerfile {
  path: string
  base_image: string
  runtime?: string
  version?: string
  port?: number
  start_command?: string
}

interface DockerfileData {
  detectedDockerfiles: DetectedDockerfile[]
  selectedDockerfiles: string[]
  gitUrl: string
  branch: string
  appBaseName: string
}

interface ChannelMessage {
  status: 'detecting' | 'found' | 'completed' | 'error'
  message?: string
  dockerfile?: DetectedDockerfile
  error?: string
  suggestion?: string
}

interface Props {
  modelValue: DockerfileData
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: DockerfileData]
}>()

const isDetecting = ref(false)
const statusMessage = ref('Connecting to repository...')
const detectedDockerfiles = ref<DetectedDockerfile[]>(props.modelValue.detectedDockerfiles || [])
const selectedDockerfiles = ref<string[]>(props.modelValue.selectedDockerfiles || [])
const error = ref<{ title: string; message: string; suggestion?: string } | null>(null)

let subscription: Subscription | null = null

const appBaseName = computed(() => props.modelValue.appBaseName || 'app')

function isSelected(path: string): boolean {
  return selectedDockerfiles.value.includes(path)
}

function toggleSelection(path: string) {
  const index = selectedDockerfiles.value.indexOf(path)
  if (index > -1) {
    selectedDockerfiles.value.splice(index, 1)
  } else {
    selectedDockerfiles.value.push(path)
  }
  emitUpdate()
}

function emitUpdate() {
  emit('update:modelValue', {
    detectedDockerfiles: detectedDockerfiles.value,
    selectedDockerfiles: selectedDockerfiles.value,
    gitUrl: props.modelValue.gitUrl,
    branch: props.modelValue.branch,
    appBaseName: props.modelValue.appBaseName
  })
}

function startDetection() {
  if (!props.modelValue.gitUrl) {
    error.value = {
      title: 'Missing Git URL',
      message: 'Please provide a Git repository URL in the previous step.',
      suggestion: 'Go back and enter your repository URL.'
    }
    return
  }

  isDetecting.value = true
  error.value = null
  detectedDockerfiles.value = []
  selectedDockerfiles.value = []

  subscription = cable.subscriptions.create(
    {
      channel: 'DockerfileDetectionChannel',
      git_url: props.modelValue.gitUrl,
      branch: props.modelValue.branch || 'main'
    },
    {
      connected() {
        statusMessage.value = 'Connected. Scanning repository...'
      },

      disconnected() {
      },

      received(data: ChannelMessage) {
        if (data.status === 'detecting') {
          statusMessage.value = data.message || 'Scanning for Dockerfiles...'
        }

        if (data.status === 'found' && data.dockerfile) {
          detectedDockerfiles.value.push(data.dockerfile)
          statusMessage.value = `Found ${detectedDockerfiles.value.length} Dockerfile(s)...`
        }

        if (data.status === 'completed') {
          isDetecting.value = false
          statusMessage.value = 'Scan complete'

          if (detectedDockerfiles.value.length === 1 && detectedDockerfiles.value[0]) {
            selectedDockerfiles.value = [detectedDockerfiles.value[0].path]
          }

          emitUpdate()

          if (subscription) {
            subscription.unsubscribe()
            subscription = null
          }
        }

        if (data.status === 'error') {
          isDetecting.value = false
          error.value = {
            title: data.error || 'Detection Failed',
            message: data.message || 'Could not scan the repository.',
            suggestion: data.suggestion || 'Please check that the repository URL is correct and accessible.'
          }

          if (subscription) {
            subscription.unsubscribe()
            subscription = null
          }
        }
      }
    }
  )
}

onMounted(() => {
  if (props.modelValue.gitUrl && detectedDockerfiles.value.length === 0) {
    startDetection()
  }
})

watch(() => props.modelValue.gitUrl, (newUrl) => {
  if (newUrl && newUrl !== props.modelValue.gitUrl) {
    startDetection()
  }
})

onUnmounted(() => {
  if (subscription) {
    subscription.unsubscribe()
  }
})

watch(selectedDockerfiles, () => {
  emitUpdate()
}, { deep: true })
</script>
