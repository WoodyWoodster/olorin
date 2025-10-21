<template>
  <div class="space-y-6">
    <div class="flex items-center justify-between">
      <div>
        <h1 class="text-3xl font-bold text-slate-900">Companies</h1>
        <p class="mt-2 text-sm text-slate-600">Manage customers and suppliers</p>
      </div>
    </div>

    <div class="rounded-lg border border-slate-200 bg-white">
      <div v-if="isLoading" class="p-12 text-center">
        <p class="text-slate-600">Loading companies...</p>
      </div>
      <div v-else-if="error" class="p-12 text-center">
        <p class="text-red-600">Error loading companies</p>
      </div>
      <div v-else-if="!companies?.length" class="p-12 text-center">
        <Building2 class="mx-auto h-12 w-12 text-slate-400" />
        <p class="mt-4 text-lg font-medium text-slate-900">No companies found</p>
        <p class="mt-2 text-sm text-slate-600">Get started by creating a new company</p>
      </div>
      <table v-else class="w-full">
        <thead class="border-b border-slate-200 bg-slate-50">
          <tr>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Name</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Type</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Email</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Phone</th>
            <th class="px-6 py-3 text-left text-xs font-medium uppercase tracking-wider text-slate-600">Status</th>
          </tr>
        </thead>
        <tbody class="divide-y divide-slate-200">
          <tr v-for="company in companies" :key="company.id" class="hover:bg-slate-50">
            <td class="px-6 py-4 text-sm font-medium text-slate-900">{{ company.name }}</td>
            <td class="px-6 py-4 text-sm text-slate-600">
              <span class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="{
                  'bg-blue-100 text-blue-800': company.company_type === 'customer',
                  'bg-purple-100 text-purple-800': company.company_type === 'supplier',
                  'bg-green-100 text-green-800': company.company_type === 'both'
                }">
                {{ company.company_type }}
              </span>
            </td>
            <td class="px-6 py-4 text-sm text-slate-600">{{ company.email || '-' }}</td>
            <td class="px-6 py-4 text-sm text-slate-600">{{ company.phone || '-' }}</td>
            <td class="px-6 py-4 text-sm">
              <span class="inline-flex rounded-full px-2 text-xs font-semibold leading-5"
                :class="company.is_active ? 'bg-green-100 text-green-800' : 'bg-gray-100 text-gray-800'">
                {{ company.is_active ? 'Active' : 'Inactive' }}
              </span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<script setup lang="ts">
import { Building2 } from 'lucide-vue-next'
import { useCompanies } from '@/composables/useCompanies'

const { data: companies, isLoading, error } = useCompanies()
</script>
