<?php

namespace App\Observers;

use App\Models\User;

class UserObserver
{
    public function updated(User $user)
    {
        // Если email только что подтвердился
        if ($user->isDirty('email_verified_at') && $user->email_verified_at && !$user->is_verified) {
            $user->is_verified = 1;
            $user->saveQuietly(); // Чтобы не вызвать бесконечный цикл observer'а
        }
    }
}
