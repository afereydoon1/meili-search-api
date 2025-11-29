<?php

namespace App\Console\Commands;

use App\Jobs\ReindexUsersJob;
use App\Models\User;
use Illuminate\Console\Command;

class ReindexUsers extends Command
{
    protected $signature = 'app:reindex-users';
    protected $description = 'Reindex all users into Meilisearch safely (UUID compatible)';

    public function handle()
    {
        $batchSize = 1000;

        User::select('id')
            ->orderBy('id')
            ->chunk($batchSize, function ($users) {
                $ids = $users->pluck('id')->toArray();
                ReindexUsersJob::dispatch($ids);
            });

        $this->info('All reindex jobs dispatched.');
    }
}
