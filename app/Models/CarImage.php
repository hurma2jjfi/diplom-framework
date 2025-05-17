<?php

// App\Models\CarImage.php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CarImage extends Model
{
    protected $table = 'car_images';

    protected $fillable = ['car_id', 'image_url'];

    public function car()
    {
        return $this->belongsTo(Car::class);
    }
}
