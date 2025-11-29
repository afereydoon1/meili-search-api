<script setup lang="ts">
import AppLayout from '@/layouts/AppLayout.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { Button } from '@/components/ui/button';
import { SquarePen,Trash2,Eye } from 'lucide-vue-next';

const props = defineProps({
    users: Object,
    filters: Object,
});

const q = ref(props.filters.q || '');

watch(q, (value) => {
    router.get('/users', { q: value }, {
        preserveState: true,
        replace: true,
    });
});
</script>

<template>
    <Head title="Users" />

    <AppLayout>
        <div class="p-4">
            <div class="flex items-center justify-between mb-4">
                <Link :href="'/users/create'">
                    <Button>Create New</Button>
                </Link>
                <input
                    v-model="q"
                    type="text"
                    placeholder="Search users..."
                    class="w-64 rounded-md border border-gray-300 py-2 px-3"
                />
            </div>

            <div class="overflow-hidden rounded-lg border bg-white">
                <table class="min-w-full text-sm">
                    <thead class="bg-gray-100">
                    <tr>
                        <th class="px-4 py-3">First Name</th>
                        <th class="px-4 py-3">Last Name</th>
                        <th class="px-4 py-3">Email</th>
                        <th class="px-4 py-3">Country</th>
                        <th class="px-4 py-3">City</th>
                        <th class="px-4 py-3">Actions</th>
                    </tr>
                    </thead>

                    <tbody>
                    <tr
                        v-for="u in users.data"
                        :key="u.id"
                        class="border-t hover:bg-gray-50"
                    >
                        <td class="px-4 py-2">{{ u.first_name }}</td>
                        <td class="px-4 py-2">{{ u.last_name }}</td>
                        <td class="px-4 py-2">{{ u.email }}</td>
                        <td class="px-4 py-2">{{ u.address?.country }}</td>
                        <td class="px-4 py-2">{{ u.address?.city }}</td>

                        <td class="px-4 py-2">
                            <div class="flex gap-2">
                                <a :href="`/users/${u.id}/edit`" class="text-blue-600">
                                    <SquarePen />
                                </a>
                                <a :href="`/users/${u.id}`" class="text-gray-600">
                                    <Eye />
                                </a>
                                <form :action="`/users/${u.id}`" method="POST">
                                    <input type="hidden" name="_method" value="DELETE">
                                    <button class="text-red-600">
                                        <Trash2 />
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="mt-4 flex justify-between">
                <div>{{ users.total }} total users</div>

                <div class="flex gap-2">
                    <Component
                        v-for="link in users.links"
                        :is="link.url ? 'a' : 'span'"
                        :href="link.url"
                        v-html="link.label"
                        :class="[
                            'px-3 py-1 rounded border',
                            link.active ? 'bg-gray-300' : 'hover:bg-gray-100',
                        ]"
                    />
                </div>
            </div>
        </div>
    </AppLayout>
</template>
