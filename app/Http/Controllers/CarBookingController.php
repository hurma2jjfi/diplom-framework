<?php

namespace App\Http\Controllers;

use App\Models\CarBooking;
use App\Models\Car;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class CarBookingController extends Controller
{
    public function store(Request $request)
{
    $data = $request->validate([
        'car_id' => 'required|exists:cars,id',
        'start_time' => 'required|date|after:now',
        'end_time' => 'required|date|after:start_time',
        'license_series' => 'required|string|max:10',
        'license_number' => 'required|string|max:20',
    ]);

    $data['start_time'] = date('Y-m-d H:i:s', strtotime($data['start_time']));
    $data['end_time'] = date('Y-m-d H:i:s', strtotime($data['end_time']));

    $car = Car::findOrFail($data['car_id']);

    $overlap = CarBooking::where('car_id', $car->id)
        ->where('status', '!=', 'Отклонено')
        ->where(function($q) use ($data) {
            $q->whereBetween('start_time', [$data['start_time'], $data['end_time']])
              ->orWhereBetween('end_time', [$data['start_time'], $data['end_time']])
              ->orWhere(function($q2) use ($data) {
                  $q2->where('start_time', '<=', $data['start_time'])
                     ->where('end_time', '>=', $data['end_time']);
              });
        })
        ->exists();

    if ($overlap) {
        return response()->json(['error' => 'Даты пересекаются с другой бронью'], 422);
    }

    $hours = (strtotime($data['end_time']) - strtotime($data['start_time'])) / 3600;
    $total_price = $hours * $car->price_per_hour;

    $booking = CarBooking::create([
        'car_id' => $car->id,
        'user_id' => Auth::id(),
        'start_time' => $data['start_time'],
        'end_time' => $data['end_time'],
        'total_price' => $total_price,
        'status' => 'В ожидании',
        'license_series' => $data['license_series'],
        'license_number' => $data['license_number'],
    ]);

    return response()->json($booking, 201);
}

public function userBookings()
{
    $userId = auth()->id();

    $bookings = CarBooking::with('car')
        ->where('user_id', $userId)
        ->orderBy('created_at', 'desc')
        ->get();

    return response()->json($bookings);
}


// В CarBookingController.php

public function cancelBooking($id)
{
    $userId = auth()->id();

    $booking = CarBooking::where('id', $id)->where('user_id', $userId)->first();

    if (!$booking) {
        return response()->json(['error' => 'Заявка не найдена или доступ запрещён'], 404);
    }

    if ($booking->status !== 'В ожидании') {
        return response()->json(['error' => 'Отменить можно только заявки со статусом "В ожидании"'], 400);
    }

    if (strtotime($booking->start_time) <= time()) {
        return response()->json(['error' => 'Нельзя отменить заявку после начала бронирования'], 400);
    }

    $booking->status = 'Отклонено';
    $booking->save();

    return response()->json(['message' => 'Заявка успешно отменена']);
}

public function destroy($id)
{
    $userId = auth()->id();

    $booking = CarBooking::where('id', $id)->where('user_id', $userId)->first();

    if (!$booking) {
        return response()->json(['error' => 'Заявка не найдена или доступ запрещён'], 404);
    }

    // Можно добавить проверку статуса, если нужно запретить удалять определённые заявки

    $booking->delete();

    return response()->json(['message' => 'Заявка успешно удалена']);
}



}
