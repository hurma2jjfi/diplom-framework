<?php

// database/migrations/2024_05_17_000000_create_car_bookings_table.php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCarBookingsTable extends Migration
{
    public function up()
    {
        Schema::create('car_bookings', function (Blueprint $table) {
            $table->id();
            $table->foreignId('car_id')->constrained('cars')->onDelete('cascade');
            $table->foreignId('user_id')->constrained('users')->onDelete('cascade');
            $table->timestamp('start_time');
            $table->timestamp('end_time');
            $table->decimal('total_price', 10, 2);
            $table->enum('status', ['В ожидании', 'Подтверждено', 'Отклонено'])->default('В ожидании');
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('car_bookings');
    }
}
