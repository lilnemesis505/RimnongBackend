<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ProductType extends Model
{
    protected $table = 'protype';
    protected $primaryKey = 'type_id';
    public $timestamps = false;

    protected $fillable = ['type_name'];
}
