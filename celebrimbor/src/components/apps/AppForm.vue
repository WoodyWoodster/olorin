<template>
  <form @submit.prevent="handleSubmit" class="space-y-6">
    <!-- Name -->
    <div class="space-y-2">
      <Label for="name">App Name</Label>
      <Input
        id="name"
        v-model="form.name"
        placeholder="my-awesome-app"
        required
      />
    </div>

    <!-- Subdomain -->
    <div class="space-y-2">
      <Label for="subdomain">Subdomain</Label>
      <Input
        id="subdomain"
        v-model="form.subdomain"
        placeholder="my-app"
        :disabled="!!app"
        required
      />
      <p class="text-sm text-muted-foreground">
        Your app will be available at {{ form.subdomain || 'your-app' }}.yourplatform.com
      </p>
    </div>

    <!-- Git URL -->
    <div class="space-y-2">
      <Label for="git_url">Git Repository URL</Label>
      <Input
        id="git_url"
        v-model="form.git_url"
        placeholder="https://github.com/username/repo.git"
      />
    </div>

    <!-- Description -->
    <div class="space-y-2">
      <Label for="description">Description</Label>
      <Input
        id="description"
        v-model="form.description"
        placeholder="A brief description of your app"
      />
    </div>

    <!-- Actions -->
    <div class="flex justify-end gap-3 pt-4">
      <Button
        type="button"
        variant="outline"
        @click="handleCancel"
        :disabled="isSubmitting"
      >
        Cancel
      </Button>
      <Button
        type="submit"
        :disabled="isSubmitting"
      >
        {{ isSubmitting ? 'Saving...' : (app ? 'Update App' : 'Create App') }}
      </Button>
    </div>
  </form>
</template>

<script setup lang="ts">
import { ref, watch } from 'vue'
import type { App } from '@/types/api'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'

interface Props {
  app?: App | null
  isSubmitting?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  app: null,
  isSubmitting: false
})

const emit = defineEmits<{
  'submit': [formData: any]
  'cancel': []
}>()

const form = ref({
  name: '',
  subdomain: '',
  git_url: '',
  description: '',
  status: 'stopped'
})

// Watch for app changes and populate form
watch(() => props.app, (newApp) => {
  if (newApp) {
    form.value = {
      name: newApp.name || '',
      subdomain: newApp.subdomain || '',
      git_url: newApp.git_url || '',
      description: newApp.description || '',
      status: newApp.status || 'stopped'
    }
  } else {
    // Reset form for new app
    form.value = {
      name: '',
      subdomain: '',
      git_url: '',
      description: '',
      status: 'stopped'
    }
  }
}, { immediate: true })

function handleSubmit() {
  emit('submit', form.value)
}

function handleCancel() {
  emit('cancel')
}

// Expose form for dirty checking
defineExpose({ form })
</script>
