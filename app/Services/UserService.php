<?php

namespace App\Services;

use App\Repositories\UserRepository;

class UserService
{
    public function __construct(protected UserRepository $repo) {}

    public function paginateUsers(int $perPage, ?string $q)
    {
        return $q
            ? $this->repo->search($q, $perPage)
            : $this->repo->paginate($perPage);
    }

    public function storeUser(array $data)
    {
        return $this->repo->create($data);
    }

    public function updateUser(string $id, array $data)
    {
        return $this->repo->update($id, $data);
    }

    public function deleteUser(string $id)
    {
        return $this->repo->delete($id);
    }

    public function findUser(string $id)
    {
        return $this->repo->find($id);
    }
}

