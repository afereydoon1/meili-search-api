<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue'
import { Head } from '@inertiajs/vue3'
import type { BreadcrumbItem } from '@/types'

const props = defineProps<{
    user: {
        id: number
        first_name: string
        last_name: string
        email: string
        address?: {
            country?: string
            city?: string
            post_code?: string
            street?: string
        }
    }
}>()

// Breadcrumbs
const breadcrumbs: BreadcrumbItem[] = [
    { title: 'Users', href: '/users' },
    { title: 'Show User', href: `/users/${props.user.id}` }
]
</script>

<template>
    <Head title="Show User" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-6">User Details</h1>

            <!-- USER INFO -->
            <div class="space-y-6">
                <div>
                    <h2 class="text-lg font-semibold mb-2">User Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>
                            <label class="block mb-1 font-medium">First Name</label>
                            <input
                                type="text"
                                :value="props.user.first_name"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>

                        <div>
                            <label class="block mb-1 font-medium">Last Name</label>
                            <input
                                type="text"
                                :value="props.user.last_name"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>

                        <div class="md:col-span-2">
                            <label class="block mb-1 font-medium">Email</label>
                            <input
                                type="email"
                                :value="props.user.email"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>
                    </div>
                </div>

                <!-- ADDRESS INFO -->
                <div>
                    <h2 class="text-lg font-semibold mb-2">Address Information</h2>

                    <div v-if="props.user.address" class="grid grid-cols-1 md:grid-cols-2 gap-6">

                        <div>
                            <label class="block mb-1 font-medium">Country</label>
                            <input
                                type="text"
                                :value="props.user.address.country"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>

                        <div>
                            <label class="block mb-1 font-medium">City</label>
                            <input
                                type="text"
                                :value="props.user.address.city"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>

                        <div>
                            <label class="block mb-1 font-medium">Post Code</label>
                            <input
                                type="text"
                                :value="props.user.address.post_code"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>

                        <div>
                            <label class="block mb-1 font-medium">Street</label>
                            <input
                                type="text"
                                :value="props.user.address.street"
                                disabled
                                class="w-full border rounded-lg p-2 bg-gray-100"
                            />
                        </div>
                    </div>

                    <p v-else class="text-gray-500">No address available.</p>
                </div>

                <div class="flex justify-end">
                    <a
                        :href="`/users/${props.user.id}/edit`"
                        class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700"
                    >
                        Edit User
                    </a>
                </div>
            </div>
        </div>
    </AppLayout>
</template>
