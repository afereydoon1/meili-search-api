<?php

namespace App\Jobs;

use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use App\Models\User;
use App\Models\Address;

class InsertUserChunk implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public $batchSize;

    public function __construct($batchSize = 1000)
    {
        $this->batchSize = $batchSize;
    }

    public function handle(): void
    {
        DB::transaction(function () {
            $users = [];
            $userIds = [];

            for ($i = 0; $i < $this->batchSize; $i++) {
                $userId = (string) Str::uuid();
                $userIds[] = $userId;

                $users[] = [
                    'id' => $userId,
                    'first_name' => fake()->firstName(),
                    'last_name' => fake()->lastName(),
                    'email' => fake()->unique()->safeEmail(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }

            User::insert($users);

            $addresses = [];

            foreach ($userIds as $userId) {
                $addresses[] = [
                    'id' => (string) Str::uuid(),
                    'user_id' => $userId,
                    'country' => fake()->country(),
                    'city' => fake()->city(),
                    'post_code' => fake()->postcode(),
                    'street' => fake()->streetAddress(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ];
            }

            Address::insert($addresses);
        });
    }
}
