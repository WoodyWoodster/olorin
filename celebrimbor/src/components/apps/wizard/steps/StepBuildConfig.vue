<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Build Configuration</h2>
      <p class="text-muted-foreground mt-1">Configure how your app is built and started</p>
    </div>

    <div class="space-y-4">
      <!-- Install Command -->
      <div class="space-y-2">
        <Label for="install-command">Install Command</Label>
        <Input
          id="install-command"
          v-model="localData.installCommand"
          placeholder="npm install"
        />
        <p class="text-sm text-muted-foreground">Command to install dependencies</p>
      </div>

      <!-- Build Command -->
      <div class="space-y-2">
        <Label for="build-command">Build Command</Label>
        <Input
          id="build-command"
          v-model="localData.buildCommand"
          placeholder="npm run build"
        />
        <p class="text-sm text-muted-foreground">Command to build your application</p>
      </div>

      <!-- Start Command -->
      <div class="space-y-2">
        <Label for="start-command">Start Command *</Label>
        <Input
          id="start-command"
          v-model="localData.startCommand"
          placeholder="npm start"
          required
        />
        <p class="text-sm text-muted-foreground">Command to start your application</p>
      </div>

      <!-- Root Directory -->
      <div class="space-y-2">
        <Label for="root-directory">Root Directory</Label>
        <Input
          id="root-directory"
          v-model="localData.rootDirectory"
          placeholder="/"
        />
        <p class="text-sm text-muted-foreground">Useful for monorepos. Defaults to repository root.</p>
      </div>

      <!-- Environment Variables -->
      <div class="space-y-2">
        <div class="flex items-center justify-between">
          <Label>Environment Variables</Label>
          <Button
            type="button"
            variant="outline"
            size="sm"
            @click="addEnvVar"
          >
            <Plus class="h-4 w-4 mr-1" />
            Add Variable
          </Button>
        </div>

        <div v-if="localData.envVars.length > 0" class="space-y-2">
          <div
            v-for="(envVar, index) in localData.envVars"
            :key="index"
            class="flex items-center gap-2"
          >
            <Input
              v-model="envVar.key"
              placeholder="KEY"
              class="flex-1"
            />
            <Input
              v-model="envVar.value"
              placeholder="value"
              class="flex-1"
            />
            <Button
              type="button"
              variant="ghost"
              size="sm"
              @click="removeEnvVar(index)"
            >
              <X class="h-4 w-4" />
            </Button>
          </div>
        </div>

        <p class="text-sm text-muted-foreground">
          Add environment variables needed for your build
        </p>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { reactive, watch } from 'vue'
import { Plus, X } from 'lucide-vue-next'
import { Input } from '@/components/ui/input'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'

interface EnvVar {
  key: string
  value: string
}

interface BuildConfigData {
  installCommand: string
  buildCommand: string
  startCommand: string
  rootDirectory: string
  envVars: EnvVar[]
}

interface Props {
  modelValue: BuildConfigData
}

const props = defineProps<Props>()

const emit = defineEmits<{
  'update:modelValue': [value: BuildConfigData]
}>()

const localData = reactive<BuildConfigData>({
  installCommand: props.modelValue.installCommand || '',
  buildCommand: props.modelValue.buildCommand || '',
  startCommand: props.modelValue.startCommand || '',
  rootDirectory: props.modelValue.rootDirectory || '/',
  envVars: props.modelValue.envVars || []
})

function addEnvVar() {
  localData.envVars.push({ key: '', value: '' })
}

function removeEnvVar(index: number) {
  localData.envVars.splice(index, 1)
}

watch(localData, (newValue) => {
  emit('update:modelValue', { ...newValue })
}, { deep: true })
</script>
