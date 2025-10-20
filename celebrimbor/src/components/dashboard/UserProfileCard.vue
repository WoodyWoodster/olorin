<template>
  <Card>
    <CardHeader>
      <CardTitle>User Profile</CardTitle>
      <CardDescription>Your account information and activity</CardDescription>
    </CardHeader>
    <CardContent>
      <div class="flex items-start space-x-4">
        <Avatar class="h-16 w-16">
          <AvatarFallback class="bg-indigo-600 text-white text-xl font-bold">
            {{ userInitials }}
          </AvatarFallback>
        </Avatar>
        <div class="flex-1 space-y-3">
          <div>
            <Label class="text-slate-600">Email</Label>
            <p class="text-base font-medium text-slate-900 mt-1">{{ user?.email }}</p>
          </div>
          <div class="grid grid-cols-2 gap-4">
            <div>
              <Label class="text-slate-600">Member Since</Label>
              <p class="text-sm text-slate-900 mt-1">
                {{ memberSince }}
              </p>
            </div>
            <div>
              <Label class="text-slate-600">User ID</Label>
              <p class="text-sm text-slate-900 mt-1">#{{ user?.id }}</p>
            </div>
          </div>
        </div>
      </div>
    </CardContent>
    <CardFooter class="border-t bg-slate-50">
      <Button variant="outline" class="w-full">
        <User class="mr-2 h-4 w-4" />
        Edit Profile
      </Button>
    </CardFooter>
  </Card>
</template>

<script setup lang="ts">
import { computed } from 'vue'
import { User } from 'lucide-vue-next'
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card'
import { Avatar, AvatarFallback } from '@/components/ui/avatar'
import { Label } from '@/components/ui/label'
import { Button } from '@/components/ui/button'
import type { User as UserType } from '@/types/api'

interface Props {
  user: UserType | null
}

const props = defineProps<Props>()

const userInitials = computed(() => {
  if (!props.user?.email) return 'U'
  const email = props.user.email
  const parts = email.split('@')[0]?.split('.')
  const first = parts?.[0]?.[0]
  const second = parts?.[1]?.[0]
  if (first && second) {
    return (first + second).toUpperCase()
  }
  return email.slice(0, 2).toUpperCase()
})

const memberSince = computed(() => {
  if (!props.user?.created_at) return 'N/A'
  return new Date(props.user.created_at).toLocaleDateString('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  })
})
</script>
