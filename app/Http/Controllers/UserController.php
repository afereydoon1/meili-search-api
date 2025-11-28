<?php

namespace App\Http\Controllers;

use App\Http\Requests\StoreUserRequest;
use App\Http\Requests\UpdateUserRequest;
use Illuminate\Http\Request;
use Inertia\Inertia;
use App\Services\UserService;

class UserController extends Controller
{
    public function __construct(protected UserService $service) {}

    public function index(Request $request)
    {
        $perPage = $request->input('per_page', 15);
        $q = $request->input('q');

        $users = $this->service->paginateUsers($perPage, $q);

        return Inertia::render('users/Index', [
            'users' => $users,
            'filters' => ['q' => $q],
        ]);
    }

    public function show(string $id)
    {
        $user = $this->service->findUser($id);

        return Inertia::render('users/Show', [
            'user' => $user
        ]);
    }

    public function create()
    {
        return Inertia::render('users/Create',[]);
    }
    public function store(StoreUserRequest $request)
    {

    }
    public function edit(string $id)
    {
        $user = $this->service->findUser($id);

        return Inertia::render('users/Edit', [
            'user' => $user
        ]);
    }

    public function update(UpdateUserRequest $request, string $id)
    {
        $this->service->updateUser($id, $request->validated());

        return redirect()->route('users.index');
    }

    public function destroy(string $id)
    {
        $this->service->deleteUser($id);

        return redirect()->back();
    }
}

