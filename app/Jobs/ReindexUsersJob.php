<?php

namespace App\Jobs;

use App\Models\User;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class ReindexUsersJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public int $batchSize;

    /**
     * Create a new job instance.
     */
    public function __construct(int $batchSize = 1000)
    {
        $this->batchSize = $batchSize;
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {

        User::with('address')->chunk($this->batchSize, function ($users) {
            $users->each->searchable();
            info('Indexed batch of ' . $users->count() . ' users');
        });
    }
}
