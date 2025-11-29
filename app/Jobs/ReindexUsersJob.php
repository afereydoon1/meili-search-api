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

    public array $ids;

    public function __construct(array $ids)
    {
        $this->ids = $ids;
    }

    public function handle(): void
    {
        User::with('address')
            ->whereIn('id', $this->ids)
            ->get()
            ->each->searchable();
    }
}
