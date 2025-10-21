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
          />
          <span class="text-sm text-muted-foreground whitespace-nowrap">.yourplatform.com</span>
        </div>
        <p class="text-sm text-muted-foreground">
          Your app will be available at <span class="font-medium">{{ localData.subdomain || 'your-app' }}.yourplatform.com</span>
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

      <!-- Region -->
      <div class="space-y-2">
        <Label for="region">Region</Label>
        <select
          id="region"
          v-model="localData.region"
          class="flex h-10 w-full rounded-md border border-input bg-background px-3 py-2 text-sm ring-offset-background focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-ring"
        >
          <option value="us-east">US East (Virginia)</option>
          <option value="us-west">US West (Oregon)</option>
          <option value="eu-west">EU West (Ireland)</option>
          <option value="ap-southeast">Asia Pacific (Singapore)</option>
        </select>
        <p class="text-sm text-muted-foreground">Choose the region closest to your users</p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, watch } from 'vue'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

interface BasicsData {
  name: string
  subdomain: string
  description: string
  region: string
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
  region: props.modelValue.region || 'us-east'
})

let isSubdomainManuallyEdited = false

function updateSubdomain() {
  if (!isSubdomainManuallyEdited && localData.name) {
    localData.subdomain = localData.name
      .toLowerCase()
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
