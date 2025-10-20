<template>
  <Card class="hover:shadow-lg transition-shadow">
    <CardContent class="pt-6">
      <div class="flex items-center justify-between">
        <div class="flex-1">
          <p class="text-sm font-medium text-slate-600">{{ title }}</p>
          <p class="text-2xl font-bold text-slate-900 mt-2">{{ value }}</p>
          <p v-if="subtitle" class="text-xs text-slate-500 mt-1">{{ subtitle }}</p>
        </div>
        <div class="flex-shrink-0">
          <div :class="[
            'inline-flex items-center justify-center w-12 h-12 rounded-lg',
            iconBgClass
          ]">
            <component :is="icon" :class="['w-6 h-6', iconClass]" />
          </div>
        </div>
      </div>
    </CardContent>
  </Card>
</template>

<script setup lang="ts">
import { Card, CardContent } from '@/components/ui/card'
import type { Component } from 'vue'

interface Props {
  title: string
  value: string | number
  subtitle?: string
  icon: Component
  iconClass?: string
  iconBgClass?: string
}

withDefaults(defineProps<Props>(), {
  iconClass: 'text-indigo-600',
  iconBgClass: 'bg-indigo-100'
})
</script>
