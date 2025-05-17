<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Car extends Model
{
    use HasFactory;

    protected $fillable = [
        'brand',
        'model',
        'license_plate',
        'color',
        'year',
        'transmission',
        'fuel_type',
        'seats',
        'city',
        'latitude',
        'longitude',
        'status',
        'price_per_hour',
        'image_url',
    ];


    public function images()
{
    return $this->hasMany(CarImage::class);
}
}
