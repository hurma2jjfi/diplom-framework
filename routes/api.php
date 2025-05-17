<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\MailController;
use App\Http\Controllers\CarController;

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Защищённые маршруты
Route::middleware('auth:sanctum')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    Route::put('/me', [AuthController::class, 'update']);
    Route::delete('/me', [AuthController::class, 'destroy']);
    Route::post('/me/avatar', [AuthController::class, 'uploadAvatar']);
    Route::post('/email/verification-notification', [AuthController::class, 'sendVerificationNotification']);
});

Route::post('/send-mail', [MailController::class, 'send']);

// Автомобили с фильтрацией
Route::get('/cars', [CarController::class, 'index']);
Route::get('/cars/{car}', [CarController::class, 'show']);
Route::middleware('auth:sanctum')->post('/cars', [CarController::class, 'store']);
Route::middleware('auth:sanctum')->put('/cars/{car}', [CarController::class, 'update']);
Route::middleware('auth:sanctum')->delete('/cars/{car}', [CarController::class, 'destroy']);
