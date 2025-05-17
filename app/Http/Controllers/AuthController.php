<?php

namespace App\Http\Controllers;


use Illuminate\Auth\Events\Registered;
use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Mail;

class AuthController extends Controller
{
    public function register(Request $request)
{
    $validated = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|email|string|unique:users,email',
        'phone' => 'nullable|string|max:20', // добавлено поле телефона, можно изменить правила по необходимости
        'password' => 'required|string|min:6|confirmed',
        'avatar' => 'nullable|image|max:2048', // max 2MB
    ]);

    // Обработка аватарки
    $avatarPath = null;
    if ($request->hasFile('avatar')) {
        $avatarPath = $request->file('avatar')->store('avatars', 'public');
    }

    $user = User::create([
        'name' => $validated['name'],
        'email' => $validated['email'],
        'phone' => $validated['phone'] ?? null, // сохраняем телефон
        'password' => Hash::make($validated['password']),
        'avatar_url' => $avatarPath ? '/storage/' . $avatarPath : null,
    ]);

    event(new Registered($user));

    // Создаём токен для пользователя
    $token = $user->createToken('auth_token')->plainTextToken;

    return response()->json([
        'message' => 'Регистрация успешна',
        'access_token' => $token,
        'token_type' => 'Bearer',
        'user' => $user,
    ], 201);
}

    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email|string',
            'password' => 'required|string',
        ]);

        $user = User::where('email', $request->email)->first();

        if (! $user || ! Hash::check($request->password, $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Неверный email или пароль.'],
            ]);
        }

        // Создаём токен
        $token = $user->createToken('auth_token')->plainTextToken;

        return response()->json([
            'message' => 'Вход успешен',
            'access_token' => $token,
            'token_type' => 'Bearer',
            'user' => $user,
        ]);
    }

    public function logout(Request $request)
    {
        // Удаляем текущий токен
        $request->user()->currentAccessToken()->delete();

        return response()->json([
            'message' => 'Успешный выход из системы',
        ]);
    }

    public function me()
    {
        return response()->json([
            'message' => 'Данные о пол-ле',
            'content' => Auth::guard('sanctum')->user()
        ]);
    }


    public function sendVerificationNotification(Request $request)
{
    $user = $request->user();

    if ($user->hasVerifiedEmail()) {
        return response()->json(['message' => 'Email уже подтверждён'], 400);
    }

    $user->sendEmailVerificationNotification();

    return response()->json(['message' => 'Письмо с подтверждением отправлено']);
}

public function update(Request $request)
{
    $user = $request->user();
    $data = $request->validate([
        'name' => 'required|string|max:255',
        'email' => 'required|email|max:255|unique:users,email,' . $user->id,
        'phone' => 'nullable|string|max:50',
        'avatar_url' => 'nullable|string|max:255',
    ]);
    $user->update($data);
    return response()->json(['content' => $user]);
}

public function destroy(Request $request)
{
    $user = $request->user();
    $user->delete();
    return response()->json(['message' => 'Пользователь удалён']);
}


public function uploadAvatar(Request $request)
{
    $user = $request->user();
    $request->validate([
        'avatar' => 'required|image|max:2048', // до 2МБ
    ]);
    $path = $request->file('avatar')->store('avatars', 'public');
    $user->avatar_url = '/storage/' . $path;
    $user->save();

    return response()->json(['avatar_url' => $user->avatar_url]);
}





}
