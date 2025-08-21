<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Employee extends Model
{
    use HasFactory;

    // กำหนดชื่อ table ให้ตรงกับฐานข้อมูลจริง
    protected $table = 'employee';

    protected $primaryKey = 'em_id';

    // กำหนดฟิลด์ที่สามารถเพิ่มข้อมูลได้ (fillable)
    protected $fillable = [
        'em_name',
        'username',
        'password',
        'em_tel',
        'em_email'
    ];
    public $timestamps = false;
}