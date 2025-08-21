<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    protected $table = 'employee';
    protected $primaryKey = 'em_id';
    public $timestamps = false;

    protected $fillable = [
        'em_name', 'username', 'password', 'em_tel', 'em_email'
    ];
}