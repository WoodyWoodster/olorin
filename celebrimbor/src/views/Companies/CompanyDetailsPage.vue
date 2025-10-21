<template>
  <div class="max-w-4xl space-y-6">
    <!-- Header -->
    <div>
      <router-link to="/companies" class="text-sm text-indigo-600 hover:text-indigo-700">
        ← Back to Companies
      </router-link>
      <div class="mt-4 flex items-center justify-between">
        <div>
          <h1 class="text-3xl font-bold text-slate-900">{{ company?.name || 'Company Details' }}</h1>
          <p class="mt-2 text-sm text-slate-600">
            <span
              class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
              :class="{
                'bg-blue-100 text-blue-800': company?.company_type === 'customer',
                'bg-purple-100 text-purple-800': company?.company_type === 'supplier',
                'bg-green-100 text-green-800': company?.company_type === 'both'
              }"
            >
              {{ formatCompanyType(company?.company_type) }}
            </span>
          </p>
        </div>
        <Button
          @click="openEditSheet"
          class="bg-indigo-600 hover:bg-indigo-700"
        >
          <Pencil class="mr-2 h-4 w-4" />
          Edit Company
        </Button>
      </div>
    </div>

    <!-- Loading State -->
    <div v-if="isLoading" class="rounded-lg border border-slate-200 bg-white p-12 text-center">
      <p class="text-slate-600">Loading company...</p>
    </div>

    <!-- Error State -->
    <div v-else-if="error" class="rounded-lg border border-red-200 bg-red-50 p-12 text-center">
      <p class="text-red-600">Error loading company</p>
    </div>

    <!-- Company Details -->
    <div v-else-if="company" class="space-y-6">
      <!-- Basic Information -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Basic Information</h2>
        </div>
        <div class="grid gap-6 p-6 sm:grid-cols-2">
          <div>
            <label class="block text-sm font-medium text-slate-600">Company Name</label>
            <p class="mt-1 text-sm text-slate-900">{{ company.name }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Type</label>
            <p class="mt-1 text-sm capitalize text-slate-900">{{ company.company_type }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Tax ID</label>
            <p class="mt-1 text-sm text-slate-900">{{ company.tax_id || '-' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Website</label>
            <p class="mt-1 text-sm text-slate-900">
              <a v-if="company.website" :href="company.website" target="_blank" class="text-indigo-600 hover:text-indigo-700">
                {{ company.website }}
              </a>
              <span v-else>-</span>
            </p>
          </div>
        </div>
      </div>

      <!-- Contact Information -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Contact Information</h2>
        </div>
        <div class="grid gap-6 p-6 sm:grid-cols-2">
          <div>
            <label class="block text-sm font-medium text-slate-600">Email</label>
            <p class="mt-1 text-sm text-slate-900">{{ company.email || '-' }}</p>
          </div>
          <div>
            <label class="block text-sm font-medium text-slate-600">Phone</label>
            <p class="mt-1 text-sm text-slate-900">{{ company.phone || '-' }}</p>
          </div>
        </div>
      </div>

      <!-- Status -->
      <div class="rounded-lg border border-slate-200 bg-white">
        <div class="border-b border-slate-200 px-6 py-4">
          <h2 class="text-lg font-semibold text-slate-900">Status</h2>
        </div>
        <div class="p-6">
          <span
            class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
            :class="company.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'"
          >
            {{ company.is_active ? 'Active' : 'Inactive' }}
          </span>
        </div>
      </div>
    </div>

    <!-- Edit Company Sheet -->
    <CompanyFormSheet
      v-model:open="isEditSheetOpen"
      :company-id="company?.id"
      @success="handleEditSuccess"
    />
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'
import { useRoute } from 'vue-router'
import { Pencil } from 'lucide-vue-next'
import { Button } from '@/components/ui/button'
import { useCompany } from '@/composables/useCompanies'
import CompanyFormSheet from '@/components/companies/CompanyFormSheet.vue'

const route = useRoute()
const companyId = computed(() => route.params.id as string)

const { data: company, isLoading, error, refetch } = useCompany(companyId.value)

const isEditSheetOpen = ref(false)

function openEditSheet() {
  isEditSheetOpen.value = true
}

function handleEditSuccess() {
  refetch()
}

function formatCompanyType(type?: string) {
  if (!type) return ''
  return type.charAt(0).toUpperCase() + type.slice(1)
}
</script>
