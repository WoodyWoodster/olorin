<template>
  <div class="space-y-6">
    <!-- Header -->
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold tracking-tight">Apps</h1>
        <p class="text-muted-foreground">Manage your deployed applications</p>
      </div>
      <Button @click="openNewAppSheet">
        <Plus class="mr-2 h-4 w-4" />
        New App
      </Button>
    </div>

    <!-- Apps List -->
    <div v-if="isLoading" class="text-center py-12">
      <p class="text-muted-foreground">Loading apps...</p>
    </div>

    <div v-else-if="error" class="text-center py-12">
      <p class="text-destructive">Error loading apps</p>
    </div>

    <div v-else-if="!apps || apps.length === 0" class="text-center py-12 border-2 border-dashed rounded-lg">
      <p class="text-muted-foreground mb-4">No apps yet</p>
      <Button @click="openNewAppSheet">
        <Plus class="mr-2 h-4 w-4" />
        Create your first app
      </Button>
    </div>

    <!-- Apps Grid -->
    <div v-else class="grid gap-4 md:grid-cols-2 lg:grid-cols-3">
      <Card
        v-for="app in apps"
        :key="app.id"
        class="cursor-pointer hover:shadow-md transition-shadow"
        @click="viewApp(app.id)"
      >
        <CardHeader>
          <div class="flex items-start justify-between">
            <div class="flex-1">
              <CardTitle>{{ app.name }}</CardTitle>
              <CardDescription class="mt-1">
                {{ app.subdomain }}.yourplatform.com
              </CardDescription>
            </div>
            <Badge :variant="getStatusVariant(app.status)">
              {{ app.status }}
            </Badge>
          </div>
        </CardHeader>
        <CardContent>
          <p v-if="app.description" class="text-sm text-muted-foreground line-clamp-2">
            {{ app.description }}
          </p>
          <p v-else class="text-sm text-muted-foreground italic">No description</p>
        </CardContent>
        <CardFooter class="text-sm text-muted-foreground">
          Created {{ formatDate(app.created_at) }}
        </CardFooter>
      </Card>
    </div>

    <!-- App Form Sheet -->
    <AppFormSheet
      v-model:open="isNewAppSheetOpen"
      @success="handleAppCreated"
    />
  </div>
</template>

<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { Plus } from 'lucide-vue-next'
import { useApps } from '@/composables/useApps'
import AppFormSheet from '@/components/apps/AppFormSheet.vue'
import { Button } from '@/components/ui/button'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Badge } from '@/components/ui/badge'

const router = useRouter()
const isNewAppSheetOpen = ref(false)

const { data: apps, isLoading, error } = useApps()

function openNewAppSheet() {
  isNewAppSheetOpen.value = true
}

function viewApp(id: number) {
  router.push(`/apps/${id}`)
}

function handleAppCreated() {
  // App list will auto-refresh due to query invalidation
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

function formatDate(dateString: string) {
  const date = new Date(dateString)
  return date.toLocaleDateString()
}
</script>
