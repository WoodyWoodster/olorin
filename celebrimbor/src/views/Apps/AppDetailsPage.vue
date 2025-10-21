<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div class="flex items-center gap-4">
        <Button variant="ghost" size="icon" @click="goBack">
          <ArrowLeft class="h-4 w-4" />
        </Button>
        <div>
          <h1 class="text-3xl font-bold tracking-tight">{{ app?.name }}</h1>
          <p class="text-muted-foreground">{{ app?.subdomain }}.yourplatform.com</p>
        </div>
        <Badge v-if="app" :variant="getStatusVariant(app.status)">
          {{ app.status }}
        </Badge>
      </div>
      <Button @click="openEditSheet" v-if="app">
        Edit App
      </Button>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="text-center py-12">
      <p class="text-muted-foreground">Loading app details...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="text-center py-12">
      <p class="text-destructive">Error loading app details</p>
    </div>

    <!-- App Details -->
    <div v-else-if="app" class="grid gap-6">
      <!-- Basic Info -->
      <Card>
        <CardHeader>
          <CardTitle>Basic Information</CardTitle>
        </CardHeader>
        <CardContent class="space-y-4">
          <div>
            <Label class="text-muted-foreground">Name</Label>
            <p class="font-medium">{{ app.name }}</p>
          </div>
          <div>
            <Label class="text-muted-foreground">Subdomain</Label>
            <p class="font-medium">{{ app.subdomain }}</p>
          </div>
          <div v-if="app.git_url">
            <Label class="text-muted-foreground">Git Repository</Label>
            <p class="font-medium">{{ app.git_url }}</p>
          </div>
          <div v-if="app.description">
            <Label class="text-muted-foreground">Description</Label>
            <p class="font-medium">{{ app.description }}</p>
          </div>
        </CardContent>
      </Card>

      <!-- Deployments Section (Placeholder) -->
      <Card>
        <CardHeader>
          <CardTitle>Recent Deployments</CardTitle>
        </CardHeader>
        <CardContent>
          <p class="text-muted-foreground text-center py-4">No deployments yet</p>
        </CardContent>
      </Card>

      <!-- Add-ons Section (Placeholder) -->
      <Card>
        <CardHeader>
          <CardTitle>Add-ons</CardTitle>
        </CardHeader>
        <CardContent>
          <p class="text-muted-foreground text-center py-4">No add-ons configured</p>
        </CardContent>
      </Card>
    </div>

    <!-- Edit App Sheet -->
    <AppFormSheet
      v-if="app"
      v-model:open="isEditSheetOpen"
      :app-id="app.id"
      @success="handleAppUpdated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft } from 'lucide-vue-next'
import { useApp } from '@/composables/useApps'
import AppFormSheet from '@/components/apps/AppFormSheet.vue'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'
import { Label } from '@/components/ui/label'

const route = useRoute()
const router = useRouter()
const isEditSheetOpen = ref(false)

const appId = route.params.id as string
const { data: app, isLoading, error } = useApp(appId)

function goBack() {
  router.push('/apps')
}

function openEditSheet() {
  isEditSheetOpen.value = true
}

function handleAppUpdated() {
  // App will auto-refresh due to query invalidation
}

function getStatusVariant(status: string) {
  switch (status) {
    case 'running':
      return 'default'
    case 'building':
      return 'secondary'
    case 'stopped':
      return 'outline'
    case 'failed':
      return 'destructive'
    default:
      return 'outline'
  }
}
</script>
