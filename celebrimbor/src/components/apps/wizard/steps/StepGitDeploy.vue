<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Git & Deployment</h2>
      <p class="text-muted-foreground mt-1">Connect your Git repository and configure deployment settings</p>
    </div>

    <div class="space-y-4">
      <!-- Git Repository URL -->
      <div class="space-y-2">
        <Label for="git-url">Git Repository URL *</Label>
        <Input
          id="git-url"
          v-model="localData.gitUrl"
          placeholder="https://github.com/username/repo.git"
          required
        />
        <p class="text-sm text-muted-foreground">
          HTTPS or SSH URL to your Git repository
        </p>
      </div>

      <!-- Branch -->
      <div class="space-y-2">
        <Label for="branch">Branch</Label>
        <Input
          id="branch"
          v-model="localData.branch"
          placeholder="main"
        />
        <p class="text-sm text-muted-foreground">
          The branch to deploy from (defaults to main)
        </p>
      </div>

      <!-- Auto Deploy -->
      <div class="flex items-center space-x-2 rounded-lg border p-4">
        <input
          id="auto-deploy"
          type="checkbox"
          v-model="localData.autoDeploy"
          class="h-4 w-4 rounded border-input"
        />
        <div class="flex-1">
          <Label for="auto-deploy" class="cursor-pointer">
            Automatic Deployments
          </Label>
          <p class="text-sm text-muted-foreground">
            Automatically deploy when you push to the selected branch
          </p>
        </div>
      </div>

      <!-- Build Notifications -->
      <div class="flex items-center space-x-2 rounded-lg border p-4">
        <input
          id="notifications"
          type="checkbox"
          v-model="localData.notifications"
          class="h-4 w-4 rounded border-input"
        />
        <div class="flex-1">
          <Label for="notifications" class="cursor-pointer">
            Build Notifications
          </Label>
          <p class="text-sm text-muted-foreground">
            Receive email notifications about build status
          </p>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, watch } from 'vue'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'

interface GitDeployData {
  gitUrl: string
  branch: string
  autoDeploy: boolean
  notifications: boolean
}

interface Props {
  modelValue: GitDeployData
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: GitDeployData]
}>()

const localData = reactive<GitDeployData>({
  gitUrl: props.modelValue.gitUrl || '',
  branch: props.modelValue.branch || 'main',
  autoDeploy: props.modelValue.autoDeploy ?? true,
  notifications: props.modelValue.notifications ?? false
})

watch(localData, (newValue) => {
  emit('update:modelValue', { ...newValue })
}, { deep: true })
</script>
