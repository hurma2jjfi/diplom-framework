<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddLicenseFieldsToCarBookingsTable extends Migration
{
    public function up()
    {
        Schema::table('car_bookings', function (Blueprint $table) {
            $table->string('license_series', 10)->after('user_id');
            $table->string('license_number', 20)->after('license_series');
        });
    }

    public function down()
    {
        Schema::table('car_bookings', function (Blueprint $table) {
            $table->dropColumn(['license_series', 'license_number']);
        });
    }
}
