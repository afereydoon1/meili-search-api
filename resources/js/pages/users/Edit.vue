<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue'
import { type BreadcrumbItem } from '@/types'
import { Head } from '@inertiajs/vue3'

const props = defineProps<{
    user: { id: number, name: string }
}>()

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Users',
        href: '/users'
    },
    {
        title: 'Edit User',
        href: `/users/${props.user.id}/edit`
    }
]
</script>

<template>
    <Head title="Edit User" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-4">
            Edit page for {{ props.user.name }}
        </div>
    </AppLayout>
</template>
