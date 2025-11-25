<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Address extends Model
{
    protected $fillable = [
        'user_id',
        'country',
        'city',
        'post_code',
        'street',
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
