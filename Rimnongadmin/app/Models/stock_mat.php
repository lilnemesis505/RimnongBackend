<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class stock_mat extends Model
{
    protected $fillable = [
    'name', 'type_id', 'import_date', 'quantity', 'exp_date', 'remain', 'unitcost', 'status'
];

public function type()
{
    return $this->belongsTo(Protype::class);
}

}
