<?php

namespace App\Repositories;

use App\Models\User;
use Illuminate\Support\Facades\DB;

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
        return DB::transaction(function () use ($data) {

            $user = User::create([
                'first_name' => $data['first_name'],
                'last_name'  => $data['last_name'],
                'email'      => $data['email'],
            ]);

            if (!empty($data['address'])) {
                $user->address()->create([
                    'country'   => $data['address']['country'],
                    'city'      => $data['address']['city'],
                    'post_code' => $data['address']['post_code'],
                    'street'    => $data['address']['street'],
                ]);
            }

            return $user;
        });
    }


    public function update(string $id, array $data)
    {
        return DB::transaction(function () use ($id, $data) {

            $user = User::findOrFail($id);

            $addressData = $data['address'] ?? null;
            unset($data['address']);

            $user->update($data);

            if (!empty($addressData)) {
                $user->address()->updateOrCreate([], $addressData);
            }

            return $user->load('address');
        });
    }


    public function delete(string $id)
    {
        User::findOrFail($id)->delete();
    }
}

