<?php

namespace App\Listeners;

use Illuminate\Support\Facades\Log;
use Illuminate\Auth\Events\Verified;

class SetUserIsVerified
{


public function handle(Verified $event)
{
    $user = $event->user;
    Log::info("Verified event triggered for user id {$user->id}");
    if (!$user->is_verified) {
        $user->is_verified = 1;
        $user->save();
        Log::info("User id {$user->id} is_verified set to 1");
    }
}


    
}
