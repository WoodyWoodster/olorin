<template>
  <!-- Inline Mode (for embedding in another dialog) -->
  <div v-if="showAsInline" class="grid gap-4 md:grid-cols-2 lg:grid-cols-3 py-4">
        <!-- Custom/Blank Template -->
        <button
          @click="selectTemplate(null)"
          class="group relative flex flex-col items-start gap-3 rounded-lg border-2 border-dashed border-muted-foreground/30 bg-muted/10 p-6 text-left transition-all hover:border-primary hover:bg-muted/20"
        >
          <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-muted text-2xl">
            ✨
          </div>
          <div>
            <h3 class="font-semibold">Start from Scratch</h3>
            <p class="text-sm text-muted-foreground mt-1">
              Configure everything manually
            </p>
          </div>
        </button>

        <!-- Template Cards -->
        <button
          v-for="template in templates"
          :key="template.id"
          @click="selectTemplate(template)"
          class="group relative flex flex-col items-start gap-3 rounded-lg border-2 border-border bg-card p-6 text-left transition-all hover:border-primary hover:shadow-md"
        >
          <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-accent text-2xl">
            {{ template.icon }}
          </div>
          <div>
            <h3 class="font-semibold">{{ template.name }}</h3>
            <p class="text-sm text-muted-foreground mt-1">
              {{ template.description }}
            </p>
          </div>
          <div class="mt-auto flex flex-wrap gap-1.5">
            <span class="inline-flex items-center rounded-full bg-secondary/10 px-2 py-0.5 text-xs font-medium text-secondary">
              {{ template.runtime }} {{ template.runtimeVersion }}
            </span>
            <span class="inline-flex items-center rounded-full bg-muted px-2 py-0.5 text-xs font-medium">
              {{ template.framework }}
            </span>
          </div>
        </button>
      </div>

  <!-- Dialog Mode (standalone) -->
  <Dialog v-else v-model:open="isOpen">
    <DialogContent class="max-w-4xl max-h-[80vh] overflow-y-auto">
      <DialogHeader>
        <DialogTitle>Choose a Template</DialogTitle>
        <DialogDescription>
          Start with a pre-configured template or create a custom app from scratch
        </DialogDescription>
      </DialogHeader>

      <div class="grid gap-4 md:grid-cols-2 lg:grid-cols-3 py-4">
        <!-- Custom/Blank Template -->
        <button
          @click="selectTemplate(null)"
          class="group relative flex flex-col items-start gap-3 rounded-lg border-2 border-dashed border-muted-foreground/30 bg-muted/10 p-6 text-left transition-all hover:border-primary hover:bg-muted/20"
        >
          <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-muted text-2xl">
            ✨
          </div>
          <div>
            <h3 class="font-semibold">Start from Scratch</h3>
            <p class="text-sm text-muted-foreground mt-1">
              Configure everything manually
            </p>
          </div>
        </button>

        <!-- Template Cards -->
        <button
          v-for="template in templates"
          :key="template.id"
          @click="selectTemplate(template)"
          class="group relative flex flex-col items-start gap-3 rounded-lg border-2 border-border bg-card p-6 text-left transition-all hover:border-primary hover:shadow-md"
        >
          <div class="flex h-12 w-12 items-center justify-center rounded-lg bg-accent text-2xl">
            {{ template.icon }}
          </div>
          <div>
            <h3 class="font-semibold">{{ template.name }}</h3>
            <p class="text-sm text-muted-foreground mt-1">
              {{ template.description }}
            </p>
          </div>
          <div class="mt-auto flex flex-wrap gap-1.5">
            <span class="inline-flex items-center rounded-full bg-secondary/10 px-2 py-0.5 text-xs font-medium text-secondary">
              {{ template.runtime }} {{ template.runtimeVersion }}
            </span>
            <span class="inline-flex items-center rounded-full bg-muted px-2 py-0.5 text-xs font-medium">
              {{ template.framework }}
            </span>
          </div>
        </button>
      </div>
    </DialogContent>
  </Dialog>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import type { AppTemplate } from './templates'
import { APP_TEMPLATES } from './templates'
import {
  Dialog,
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from '@/components/ui/dialog'

interface Props {
  open?: boolean
  showAsInline?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  open: false,
  showAsInline: false
})

const emit = defineEmits<{
  'update:open': [value: boolean]
  'select': [template: AppTemplate | null]
}>()

const isOpen = computed({
  get: () => props.open,
  set: (value) => emit('update:open', value)
})

const templates = APP_TEMPLATES

function selectTemplate(template: AppTemplate | null) {
  emit('select', template)
  isOpen.value = false
}
</script>
