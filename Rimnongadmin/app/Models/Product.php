<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use App\Models\ProductType;

class Product extends Model
{
    use HasFactory;

    protected $table = 'product';
    protected $primaryKey = 'pro_id';
    public $timestamps = false;

    protected $fillable = [
        'pro_name',
        'price',
        'type_id',
    ];

    public function type()
    {
        return $this->belongsTo(ProductType::class, 'type_id');
    }
}