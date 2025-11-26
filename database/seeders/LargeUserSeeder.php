<?php

namespace Database\Seeders;

use App\Jobs\InsertUserChunk;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class LargeUserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run()
    {
        $total = 1_000_000;
        $batch = 1_000;

        $batches = $total / $batch;

        for ($i = 0; $i < $batches; $i++) {
            dispatch(new InsertUserChunk($batch))
                ->onQueue('seeding');
        }
    }
}
