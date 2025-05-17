<?php
// app/Models/CarBooking.php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class CarBooking extends Model
{
    use HasFactory;

    protected $fillable = [
        'car_id',
        'user_id',
        'start_time',
        'end_time',
        'total_price',
        'status',
        'license_series',
        'license_number',
    ];
    

    public function car()
    {
        return $this->belongsTo(Car::class);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
