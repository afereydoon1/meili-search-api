<?php

namespace App\Repositories;

use App\Models\User;

class UserRepository
{
    public function paginate(int $perPage)
    {
        return User::with('address')->paginate($perPage);
    }

    public function search(string $q, int $perPage)
    {
        return User::search($q)
            ->take($perPage)
            ->paginate($perPage);
    }

    public function find(string $id)
    {
        return User::with('address')->findOrFail($id);
    }

    public function create(array $data)
    {
        $user = User::create($data);

        if (!empty($data['address'])) {
            $user->address()->create($data['address']);
        }

        return $user;
    }

    public function update(string $id, array $data)
    {
        $user = User::findOrFail($id);
        $user->update($data);

        if (!empty($data['address'])) {
            $user->address()->updateOrCreate([], $data['address']);
        }

        return $user;
    }

    public function delete(string $id)
    {
        User::findOrFail($id)->delete();
    }
}

