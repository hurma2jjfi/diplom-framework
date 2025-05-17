<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateCarsTable extends Migration
{
    public function up()
    {
        Schema::create('cars', function (Blueprint $table) {
            $table->id();

            // Основные поля
            $table->string('brand');              // Марка автомобиля, например, Toyota
            $table->string('model');              // Модель, например, Camry
            $table->string('license_plate')->unique(); // Номерной знак
            $table->string('color')->nullable(); // Цвет автомобиля

            // Технические характеристики
            $table->integer('year')->nullable(); // Год выпуска
            $table->string('transmission')->nullable(); // Коробка передач (автомат, механика)
            $table->string('fuel_type')->nullable();    // Тип топлива (бензин, дизель, электрокар)
            $table->integer('seats')->default(4);       // Количество мест

            // Локация для каршеринга (город, координаты)
            $table->string('city')->nullable();
            $table->decimal('latitude', 10, 7)->nullable();
            $table->decimal('longitude', 10, 7)->nullable();

            // Статус автомобиля (доступен, занят, в ремонте и т.д.)
            $table->enum('status', ['Доступен', 'Занят', 'В ремонте', 'Зарезервирован'])->default('Доступен');

            // Цена аренды
            $table->decimal('price_per_hour', 8, 2)->default(0);

            // Изображение автомобиля (ссылка)
            $table->string('image_url')->nullable();

            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('cars');
    }
}
