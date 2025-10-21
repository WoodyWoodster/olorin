<template>
  <div class="space-y-6">
    <div>
      <h2 class="text-2xl font-bold">Review & Create</h2>
      <p class="text-muted-foreground mt-1">Review your configuration before creating the app</p>
    </div>

    <div class="space-y-4">
      <!-- Basic Information -->
      <Card>
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle>Basic Information</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 0)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span class="text-muted-foreground">App Name:</span>
            <span class="font-medium">{{ data.basics.name }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-muted-foreground">Subdomain:</span>
            <span class="font-medium">{{ data.basics.subdomain }}.yourplatform.com</span>
          </div>
          <div v-if="data.basics.description" class="flex justify-between">
            <span class="text-muted-foreground">Description:</span>
            <span class="font-medium">{{ data.basics.description }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-muted-foreground">Region:</span>
            <span class="font-medium">{{ formatRegion(data.basics.region) }}</span>
          </div>
        </CardContent>
      </Card>

      <!-- Runtime & Framework -->
      <Card>
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle>Runtime & Framework</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 1)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span class="text-muted-foreground">Runtime:</span>
            <span class="font-medium">{{ data.runtime.runtime }} {{ data.runtime.runtimeVersion }}</span>
          </div>
          <div v-if="data.runtime.framework" class="flex justify-between">
            <span class="text-muted-foreground">Framework:</span>
            <span class="font-medium">{{ data.runtime.framework }}</span>
          </div>
        </CardContent>
      </Card>

      <!-- Build Configuration -->
      <Card>
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle>Build Configuration</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 2)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-2 text-sm">
          <div v-if="data.buildConfig.installCommand" class="flex justify-between">
            <span class="text-muted-foreground">Install:</span>
            <code class="font-mono text-xs bg-muted px-2 py-1 rounded">{{ data.buildConfig.installCommand }}</code>
          </div>
          <div v-if="data.buildConfig.buildCommand" class="flex justify-between">
            <span class="text-muted-foreground">Build:</span>
            <code class="font-mono text-xs bg-muted px-2 py-1 rounded">{{ data.buildConfig.buildCommand }}</code>
          </div>
          <div class="flex justify-between">
            <span class="text-muted-foreground">Start:</span>
            <code class="font-mono text-xs bg-muted px-2 py-1 rounded">{{ data.buildConfig.startCommand }}</code>
          </div>
          <div v-if="data.buildConfig.envVars.length > 0" class="pt-2">
            <span class="text-muted-foreground">Environment Variables:</span>
            <div class="mt-1 space-y-1">
              <div
                v-for="(envVar, index) in data.buildConfig.envVars"
                :key="index"
                class="text-xs"
              >
                <code class="bg-muted px-2 py-0.5 rounded">{{ envVar.key }}</code>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      <!-- Git & Deployment -->
      <Card>
        <CardHeader>
          <div class="flex items-center justify-between">
            <CardTitle>Git & Deployment</CardTitle>
            <Button variant="ghost" size="sm" @click="$emit('edit', 3)">
              Edit
            </Button>
          </div>
        </CardHeader>
        <CardContent class="space-y-2 text-sm">
          <div class="flex justify-between">
            <span class="text-muted-foreground">Repository:</span>
            <span class="font-medium truncate max-w-xs">{{ data.gitDeploy.gitUrl }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-muted-foreground">Branch:</span>
            <span class="font-medium">{{ data.gitDeploy.branch }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-muted-foreground">Auto Deploy:</span>
            <span class="font-medium">{{ data.gitDeploy.autoDeploy ? 'Enabled' : 'Disabled' }}</span>
          </div>
        </CardContent>
      </Card>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'

interface Props {
  data: any
}

defineProps<Props>()

defineEmits<{
  'edit': [step: number]
}>()

function formatRegion(region: string): string {
  const regions: Record<string, string> = {
    'us-east': 'US East (Virginia)',
    'us-west': 'US West (Oregon)',
    'eu-west': 'EU West (Ireland)',
    'ap-southeast': 'Asia Pacific (Singapore)'
  }
  return regions[region] || region
}
</script>
