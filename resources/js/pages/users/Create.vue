<script setup lang="ts">
import { useForm } from '@inertiajs/vue3';
import AppLayout from '@/layouts/AppLayout.vue';
import { Head } from '@inertiajs/vue3';
import type { BreadcrumbItem } from '@/types';

const breadcrumbs: BreadcrumbItem[] = [
    {
        title: 'Create User',
        href: '/users/create',
    },
];

const form = useForm({
    first_name: '',
    last_name: '',
    email: '',
    address: {
        country: '',
        city: '',
        post_code: '',
        street: '',
    },
});

const submit = () => {
    form.post('/users');
};
</script>

<template>
    <Head title="Create User" />

    <AppLayout :breadcrumbs="breadcrumbs">
        <div class="p-6 max-w-4xl mx-auto">
            <h1 class="text-2xl font-bold mb-6">Create User</h1>
            <form @submit.prevent="submit" class="space-y-8">
                <!-- USER INFO -->
                <div>
                    <h2 class="text-lg font-semibold mb-4">User Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- First Name -->
                        <div>
                            <label class="block mb-1 font-medium">First Name</label>
                            <input
                                v-model="form.first_name"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors.first_name" class="text-red-600 text-sm mt-1">
                                {{ form.errors.first_name }}
                            </div>
                        </div>

                        <!-- Last Name -->
                        <div>
                            <label class="block mb-1 font-medium">Last Name</label>
                            <input
                                v-model="form.last_name"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors.last_name" class="text-red-600 text-sm mt-1">
                                {{ form.errors.last_name }}
                            </div>
                        </div>

                        <!-- Email -->
                        <div class="md:col-span-2">
                            <label class="block mb-1 font-medium">Email</label>
                            <input
                                v-model="form.email"
                                type="email"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors.email" class="text-red-600 text-sm mt-1">
                                {{ form.errors.email }}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- ADDRESS -->
                <div>
                    <h2 class="text-lg font-semibold mb-4">Address Information</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <!-- Country -->
                        <div>
                            <label class="block mb-1 font-medium">Country</label>
                            <input
                                v-model="form.address.country"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors['address.country']" class="text-red-600 text-sm mt-1">
                                {{ form.errors['address.country'] }}
                            </div>
                        </div>

                        <!-- City -->
                        <div>
                            <label class="block mb-1 font-medium">City</label>
                            <input
                                v-model="form.address.city"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors['address.city']" class="text-red-600 text-sm mt-1">
                                {{ form.errors['address.city'] }}
                            </div>
                        </div>

                        <!-- Post Code -->
                        <div>
                            <label class="block mb-1 font-medium">Post Code</label>
                            <input
                                v-model="form.address.post_code"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors['address.post_code']" class="text-red-600 text-sm mt-1">
                                {{ form.errors['address.post_code'] }}
                            </div>
                        </div>

                        <!-- Street -->
                        <div>
                            <label class="block mb-1 font-medium">Street</label>
                            <input
                                v-model="form.address.street"
                                type="text"
                                class="w-full border rounded-lg p-2"
                            />
                            <div v-if="form.errors['address.street']" class="text-red-600 text-sm mt-1">
                                {{ form.errors['address.street'] }}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="flex justify-end">
                    <button
                        type="submit"
                        class="bg-blue-600 text-white px-6 py-2 rounded-lg hover:bg-blue-700 disabled:opacity-50"
                        :disabled="form.processing"
                    >
                        Create User
                    </button>
                </div>
            </form>
        </div>
    </AppLayout>
</template>
