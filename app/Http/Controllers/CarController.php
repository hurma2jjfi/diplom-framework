<?php

namespace App\Http\Controllers;

use App\Models\Car;
use Illuminate\Http\Request;

class CarController extends Controller
{
    /**
     * Получить список автомобилей с фильтрацией по параметрам.
     */
    public function index(Request $request)
    {
        $query = Car::query();

        // Фильтрация по каждому полю, если параметр передан в запросе
        $filters = [
            'id',
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
            'created_at',
            'updated_at',
        ];

        foreach ($filters as $field) {
            if ($request->filled($field)) {
                // Для числовых и точных значений используем where
                // Для строк - where с LIKE для частичного совпадения (кроме id, year, seats, latitude, longitude, price_per_hour)
                $value = $request->input($field);

                if (in_array($field, ['brand', 'model', 'license_plate', 'color', 'transmission', 'fuel_type', 'city', 'status', 'image_url'])) {
                    // Частичное совпадение, регистронезависимое
                    $query->where($field, 'LIKE', '%' . $value . '%');
                } elseif (in_array($field, ['created_at', 'updated_at'])) {
                    // Можно фильтровать по дате (например, exact match или диапазон)
                    // Для простоты - exact match
                    $query->whereDate($field, $value);
                } else {
                    // Точные совпадения для числовых полей
                    $query->where($field, $value);
                }
            }
        }

        // Можно добавить пагинацию, например 20 на страницу
        $cars = $query->paginate(20);

        return response()->json($cars);
    }

    public function show($id)
    {
        $car = Car::with('images')->findOrFail($id);
        return response()->json($car);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'brand' => 'required|string|max:255',
            'model' => 'required|string|max:255',
            'license_plate' => 'required|string|max:20|unique:cars',
            'color' => 'nullable|string|max:50',
            'year' => 'nullable|integer|min:1900|max:' . date('Y'),
            'transmission' => 'nullable|string|max:50',
            'fuel_type' => 'nullable|string|max:50',
            'seats' => 'nullable|integer|min:1|max:20',
            'city' => 'nullable|string|max:100',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'status' => 'nullable|in:available,rented,maintenance,reserved,Доступен',
            'price_per_hour' => 'nullable|numeric|min:0',
            'image_url' => 'nullable|string|max:255',
        ]);

        $car = Car::create($data);

        return response()->json($car, 201);
    }

    public function update(Request $request, $id)
    {
        $car = Car::findOrFail($id);

        $data = $request->validate([
            'brand' => 'sometimes|required|string|max:255',
            'model' => 'sometimes|required|string|max:255',
            'license_plate' => 'sometimes|required|string|max:20|unique:cars,license_plate,' . $car->id,
            'color' => 'nullable|string|max:50',
            'year' => 'nullable|integer|min:1900|max:' . date('Y'),
            'transmission' => 'nullable|string|max:50',
            'fuel_type' => 'nullable|string|max:50',
            'seats' => 'nullable|integer|min:1|max:20',
            'city' => 'nullable|string|max:100',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'status' => 'nullable|in:available,rented,maintenance,reserved,Доступен',
            'price_per_hour' => 'nullable|numeric|min:0',
            'image_url' => 'nullable|string|max:255',
        ]);

        $car->update($data);

        return response()->json($car);
    }

    public function destroy($id)
    {
        $car = Car::findOrFail($id);
        $car->delete();

        return response()->json(['message' => 'Car deleted']);
    }



}
