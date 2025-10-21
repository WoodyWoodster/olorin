<template>
  <div class="space-y-6">
    <!-- Header -->
    <div>
      <h1 class="text-3xl font-bold text-stone-900">Dashboard</h1>
      <p class="mt-2 text-sm text-stone-600">
        Welcome to Olorin PaaS - Deploy and manage your applications
      </p>
    </div>

    <!-- Quick Actions -->
    <div class="grid gap-6 md:grid-cols-3">
      <div class="rounded-xl border border-stone-200 bg-white p-6 transition-shadow hover:shadow-md cursor-pointer" @click="openNewAppWizard">
        <div class="flex items-center gap-3">
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-orange-100">
            <Rocket class="h-6 w-6 text-orange-600" />
          </div>
          <div>
            <h3 class="font-semibold text-stone-900">Deploy New App</h3>
            <p class="text-sm text-stone-600">Create and deploy a new application</p>
          </div>
        </div>
      </div>

      <div class="rounded-xl border border-stone-200 bg-white p-6 transition-shadow hover:shadow-md cursor-pointer" @click="viewApps">
        <div class="flex items-center gap-3">
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-100">
            <LayoutGrid class="h-6 w-6 text-green-700" />
          </div>
          <div>
            <h3 class="font-semibold text-stone-900">View All Apps</h3>
            <p class="text-sm text-stone-600">Manage your deployed applications</p>
          </div>
        </div>
      </div>

      <div class="rounded-xl border border-stone-200 bg-white p-6 transition-shadow hover:shadow-md cursor-pointer">
        <div class="flex items-center gap-3">
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-100">
            <Database class="h-6 w-6 text-amber-600" />
          </div>
          <div>
            <h3 class="font-semibold text-stone-900">Provision Add-on</h3>
            <p class="text-sm text-stone-600">Add databases and services</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Stats -->
    <div class="grid gap-6 md:grid-cols-4">
      <div class="rounded-xl border border-stone-200 bg-white p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-stone-600">Total Apps</p>
            <p class="mt-2 text-3xl font-bold text-stone-900">{{ apps?.length || 0 }}</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-orange-100">
            <Rocket class="h-6 w-6 text-orange-600" />
          </div>
        </div>
      </div>

      <div class="rounded-xl border border-stone-200 bg-white p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-stone-600">Running</p>
            <p class="mt-2 text-3xl font-bold text-stone-900">{{ runningApps }}</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-100">
            <Activity class="h-6 w-6 text-green-700" />
          </div>
        </div>
      </div>

      <div class="rounded-xl border border-stone-200 bg-white p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-stone-600">Deployments</p>
            <p class="mt-2 text-3xl font-bold text-stone-900">0</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-green-100">
            <GitBranch class="h-6 w-6 text-green-600" />
          </div>
        </div>
      </div>

      <div class="rounded-xl border border-stone-200 bg-white p-6">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-sm font-medium text-stone-600">Add-ons</p>
            <p class="mt-2 text-3xl font-bold text-stone-900">0</p>
          </div>
          <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-amber-100">
            <Database class="h-6 w-6 text-amber-600" />
          </div>
        </div>
      </div>
    </div>

    <!-- Recent Apps -->
    <div class="rounded-xl border border-stone-200 bg-white">
      <div class="flex items-center justify-between border-b border-stone-200 px-4 py-3">
        <h2 class="font-semibold text-stone-900">Recent Apps</h2>
        <div class="flex items-center space-x-2">
          <button
            @click="openNewAppWizard"
            class="rounded-lg bg-orange-600 px-3 py-1.5 text-sm font-medium text-white transition-colors hover:bg-orange-700"
          >
            <Plus class="mr-1 inline h-4 w-4" />
            New App
          </button>
          <router-link
            to="/apps"
            class="text-sm font-medium text-orange-600 hover:text-orange-700"
          >
            View All →
          </router-link>
        </div>
      </div>
      <div class="p-4">
        <div v-if="!apps || apps.length === 0" class="py-12 text-center">
          <Rocket class="mx-auto h-12 w-12 text-stone-300" />
          <p class="mt-2 text-sm text-stone-500 mb-4">No apps yet</p>
          <button
            @click="openNewAppWizard"
            class="rounded-lg bg-orange-600 px-4 py-2 text-sm font-medium text-white transition-colors hover:bg-orange-700"
          >
            <Rocket class="mr-2 inline h-4 w-4" />
            Deploy Your First App
          </button>
        </div>

        <div v-else class="space-y-3">
          <div
            v-for="app in recentApps"
            :key="app.id"
            class="flex items-center justify-between rounded-xl border border-stone-200 p-4 transition-colors hover:bg-stone-50 cursor-pointer"
            @click="viewApp(app.id)"
          >
            <div class="flex items-center gap-3">
              <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-orange-100">
                <Rocket class="h-5 w-5 text-orange-600" />
              </div>
              <div>
                <p class="font-medium text-stone-900">{{ app.name }}</p>
                <p class="text-sm text-stone-500">{{ app.subdomain }}.yourplatform.com</p>
              </div>
            </div>
            <span
              class="inline-flex rounded-full px-2 py-1 text-xs font-semibold"
              :class="{
                'bg-green-100 text-green-800': app.status === 'running',
                'bg-orange-100 text-orange-800': app.status === 'building',
                'bg-stone-100 text-stone-800': app.status === 'stopped',
                'bg-red-100 text-red-800': app.status === 'failed',
              }"
            >
              {{ app.status }}
            </span>
          </div>
        </div>
      </div>
    </div>

    <!-- App Creation Wizard -->
    <AppCreationWizard
      v-model:open="isNewAppWizardOpen"
      :is-submitting="createMutation.isPending.value"
      @submit="handleCreateApp"
      @cancel="isNewAppWizardOpen = false"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRouter } from 'vue-router'
import { Rocket, Database, LayoutGrid, Activity, GitBranch, Plus } from 'lucide-vue-next'
import { toast } from 'vue-sonner'
import { useApps, useCreateApp } from '@/composables/useApps'
import AppCreationWizard from '@/components/apps/AppCreationWizard.vue'

const router = useRouter()
const isNewAppWizardOpen = ref(false)

const { data: apps } = useApps()
const createMutation = useCreateApp()

const runningApps = computed(() => {
  return apps.value?.filter(app => app.status === 'running').length || 0
})

const recentApps = computed(() => {
  return apps.value?.slice(0, 5) || []
})

function openNewAppWizard() {
  isNewAppWizardOpen.value = true
}

function viewApps() {
  router.push('/apps')
}

function viewApp(id: number) {
  router.push(`/apps/${id}`)
}

async function handleCreateApp(formData: any) {
  try {
    await createMutation.mutateAsync({ app: formData })
    const time = new Date().toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })
    toast.success('App created successfully', {
      description: `${formData.name} (${formData.subdomain}) - ${time}`
    })
    isNewAppWizardOpen.value = false
  } catch (error: any) {
    console.error('Error creating app:', error)
    toast.error('Failed to create app', {
      description: error?.message || 'An unexpected error occurred'
    })
  }
}

function handleAppCreated() {
  // Apps will auto-refresh due to query invalidation
}
</script>
