<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Review & Create</h2>
      <p class="text-muted-foreground mt-1">
        {{ data.dockerfileData.selectedDockerfiles.length > 1
          ? `Review configuration - ${data.dockerfileData.selectedDockerfiles.length} apps will be created`
          : 'Review your configuration before creating the app' }}
      </p>
    </div>

    <div class="space-y-4">
      <!-- Basic Information -->
      <Card class="rounded-xl border-stone-200">
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle class="text-stone-900">Basic Information</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 0)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span class="text-stone-600">App Name:</span>
            <span class="font-medium text-stone-900">{{ data.basics.name }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-stone-600">Subdomain:</span>
            <span class="font-medium text-stone-900">{{ data.basics.subdomain }}.yourplatform.com</span>
          </div>
          <div v-if="data.basics.description" class="flex justify-between">
            <span class="text-stone-600">Description:</span>
            <span class="font-medium text-stone-900">{{ data.basics.description }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-stone-600">Repository:</span>
            <span class="font-medium text-stone-900 truncate max-w-xs">{{ data.basics.gitUrl }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-stone-600">Branch:</span>
            <span class="font-medium text-stone-900">{{ data.basics.branch }}</span>
          </div>
        </CardContent>
      </Card>

      <!-- Detected Dockerfiles -->
      <Card class="rounded-xl border-stone-200">
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle class="text-stone-900">Detected Dockerfiles</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 1)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-3">
          <div
            v-for="dockerfile in selectedDockerfiles"
            :key="dockerfile.path"
            class="rounded-lg border border-stone-200 p-3 bg-stone-50"
          >
            <div class="flex items-start justify-between mb-2">
              <code class="text-xs font-mono bg-white px-2 py-1 rounded text-stone-900">
                {{ dockerfile.path }}
              </code>
              <span class="text-xl">🐳</span>
            </div>
            <div class="grid grid-cols-2 gap-2 text-xs">
              <div>
                <span class="text-stone-500">Base Image:</span>
                <p class="font-mono text-stone-900">{{ dockerfile.base_image }}</p>
              </div>
              <div v-if="dockerfile.runtime">
                <span class="text-stone-500">Runtime:</span>
                <p class="font-semibold text-green-700">{{ dockerfile.runtime }} {{ dockerfile.version }}</p>
              </div>
              <div v-if="dockerfile.port">
                <span class="text-stone-500">Port:</span>
                <p class="font-mono text-stone-900">{{ dockerfile.port }}</p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Apps to be Created -->
      <Card v-if="appsToCreate.length > 1" class="rounded-xl border-blue-200 bg-blue-50">
        <CardHeader>
          <CardTitle class="text-blue-900">Multiple Apps Will Be Created</CardTitle>
        </CardHeader>
        <CardContent>
          <p class="text-sm text-blue-800 mb-4">
            Since multiple Dockerfiles are selected, we'll create {{ appsToCreate.length }} separate applications:
          </p>
          <div class="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
            <div
              v-for="app in appsToCreate"
              :key="app.subdomain"
              class="rounded-lg bg-white p-3 border border-blue-200"
            >
              <div class="flex items-start justify-between gap-2 mb-2">
                <div class="flex-1 min-w-0">
                  <p class="font-semibold text-blue-900 truncate">{{ app.name }}</p>
                  <p class="text-xs text-blue-600 truncate">{{ app.subdomain }}.yourplatform.com</p>
                </div>
                <span class="text-xl flex-shrink-0">🐳</span>
              </div>
              <code class="text-xs font-mono bg-blue-100 px-2 py-1 rounded text-blue-800 block truncate">
                {{ app.dockerfile_path }}
              </code>
              <div v-if="app.runtime" class="mt-2 text-xs">
                <span class="font-semibold text-green-700">{{ app.runtime }} {{ app.version }}</span>
                <span v-if="app.port" class="text-stone-600 ml-2">· Port {{ app.port }}</span>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

interface DetectedDockerfile {
  path: string
  base_image: string
  runtime?: string
  version?: string
  port?: number
  start_command?: string
}

interface WizardFormData {
  basics: {
    name: string
    subdomain: string
    description: string
    gitUrl: string
    branch: string
  }
  dockerfileData: {
    detectedDockerfiles: DetectedDockerfile[]
    selectedDockerfiles: string[]
    gitUrl: string
    branch: string
    appBaseName: string
  }
}

interface Props {
  data: WizardFormData
}

const props = defineProps<Props>()

defineEmits<{
  'edit': [step: number]
}>()

const selectedDockerfiles = computed(() => {
  return props.data.dockerfileData.detectedDockerfiles.filter(
    d => props.data.dockerfileData.selectedDockerfiles.includes(d.path)
  )
})

const appsToCreate = computed(() => {
  if (props.data.dockerfileData.selectedDockerfiles.length <= 1) {
    return []
  }

  return props.data.dockerfileData.selectedDockerfiles.map(dockerfilePath => {
    const dockerfile = props.data.dockerfileData.detectedDockerfiles.find(
      d => d.path === dockerfilePath
    )
    const suffix = getSuffixFromPath(dockerfilePath)

    return {
      name: suffix ? `${props.data.basics.name}-${suffix}` : props.data.basics.name,
      subdomain: suffix ? `${props.data.basics.subdomain}-${suffix}` : props.data.basics.subdomain,
      dockerfile_path: dockerfilePath,
      runtime: dockerfile?.runtime,
      version: dockerfile?.version,
      port: dockerfile?.port
    }
  })
})

function getSuffixFromPath(path: string): string {
  // Extract meaningful suffix from Dockerfile path
  // e.g., "./backend/Dockerfile.prod" -> "backend"
  // e.g., "./Dockerfile" -> ""
  const parts = path.split('/')
  const directory = parts[parts.length - 2]

  if (directory && directory !== '.' && directory !== '..') {
    return directory
  }

  const filename = parts[parts.length - 1]
  if (!filename) {
    return ''
  }

  const filenameParts = filename.split('.')
  if (filenameParts.length > 2) {
    return filenameParts[filenameParts.length - 1] || ''
  }

  return ''
}
</script>
