<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">App Basics</h2>
      <p class="text-muted-foreground mt-1">Let's start with the basic information about your app</p>
    </div>

    <div class="space-y-4">
      <!-- App Name -->
      <div class="space-y-2">
        <Label for="name">App Name *</Label>
        <Input
          id="name"
          v-model="localData.name"
          placeholder="my-awesome-app"
          @input="updateSubdomain"
          required
        />
        <p class="text-sm text-muted-foreground">A friendly name for your application</p>
      </div>

      <!-- Subdomain -->
      <div class="space-y-2">
        <Label for="subdomain">Subdomain *</Label>
        <div class="flex items-center gap-2">
          <Input
            id="subdomain"
            v-model="localData.subdomain"
            placeholder="my-app"
            required
            class="flex-1"
            @input="sanitizeSubdomain"
          />
          <span class="text-sm text-muted-foreground whitespace-nowrap">.yourplatform.com</span>
        </div>
        <p class="text-sm text-muted-foreground">
          Your app will be available at <span class="font-medium">{{ sanitizedSubdomain }}.yourplatform.com</span>
        </p>
      </div>

      <!-- Description -->
      <div class="space-y-2">
        <Label for="description">Description</Label>
        <Input
          id="description"
          v-model="localData.description"
          placeholder="A brief description of your app"
        />
        <p class="text-sm text-muted-foreground">Optional: Describe what this app does</p>
      </div>

      <!-- Git Repository -->
      <div class="space-y-2">
        <Label for="git-url">Git Repository URL *</Label>
        <Input
          id="git-url"
          v-model="localData.gitUrl"
          placeholder="https://github.com/username/repo.git"
          required
        />
        <p class="text-sm text-muted-foreground">HTTPS or SSH URL to your repository</p>
      </div>

      <!-- Branch -->
      <div class="space-y-2">
        <Label for="branch">Branch</Label>
        <Input
          id="branch"
          v-model="localData.branch"
          placeholder="main"
        />
        <p class="text-sm text-muted-foreground">The branch to deploy (defaults to main)</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, watch, computed } from 'vue'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

interface BasicsData {
  name: string
  subdomain: string
  description: string
  gitUrl: string
  branch: string
}

interface Props {
  modelValue: BasicsData
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: BasicsData]
}>()

const localData = reactive<BasicsData>({
  name: props.modelValue.name || '',
  subdomain: props.modelValue.subdomain || '',
  description: props.modelValue.description || '',
  gitUrl: props.modelValue.gitUrl || '',
  branch: props.modelValue.branch || 'main'
})

let isSubdomainManuallyEdited = false

// Computed property for sanitized subdomain display
const sanitizedSubdomain = computed(() => {
  if (!localData.subdomain) return 'your-app'
  return localData.subdomain
    .toLowerCase()
    .replace(/\s+/g, '-')  // Replace spaces with hyphens
    .replace(/[^a-z0-9-]/g, '-')  // Replace invalid chars with hyphens
    .replace(/-+/g, '-')  // Collapse multiple hyphens
    .replace(/^-|-$/g, '')  // Remove leading/trailing hyphens
})

function sanitizeSubdomain() {
  // Sanitize subdomain as user types
  const cursorPosition = (event?.target as HTMLInputElement)?.selectionStart || 0
  const sanitized = localData.subdomain
    .toLowerCase()
    .replace(/\s+/g, '-')
    .replace(/[^a-z0-9-]/g, '-')
    .replace(/-+/g, '-')
    .replace(/^-|-$/g, '')

  if (sanitized !== localData.subdomain) {
    localData.subdomain = sanitized
    // Restore cursor position
    setTimeout(() => {
      const input = document.getElementById('subdomain') as HTMLInputElement
      if (input) {
        input.setSelectionRange(cursorPosition, cursorPosition)
      }
    }, 0)
  }
}

function updateSubdomain() {
  if (!isSubdomainManuallyEdited && localData.name) {
    localData.subdomain = localData.name
      .toLowerCase()
      .replace(/\s+/g, '-')
      .replace(/[^a-z0-9-]/g, '-')
      .replace(/-+/g, '-')
      .replace(/^-|-$/g, '')
  }
}

watch(() => localData.subdomain, () => {
  isSubdomainManuallyEdited = true
})

watch(localData, (newValue) => {
  emit('update:modelValue', { ...newValue })
}, { deep: true })
</script>
