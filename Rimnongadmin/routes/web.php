<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\EmployeeController;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/', function () {
    return view('welcome');
})->name('welcome');

Route::get('/product', function () {
    return view('layouts.product');
})->name('products.index');

Route::get('/employee', [EmployeeController::class, 'index'])->name('employee.index');
Route::get('/customers', [CustomerController::class, 'index'])->name('customers.index');

Route::get('/stock', function () {
    return view('layouts.stock');
})->name('stock.index');

Route::get('/pay', function () {
    return view('layouts.pay');
})->name('pay.index');

Route::get('/promotion', function () {
    return view('layouts.promotion');
})->name('promotion.index');

Route::get('/history', function () {
    return view('layouts.history');
})->name('history.index');

Route::get('/salereport', function () {
    return view('layouts.salereport');
})->name('salereport.index');

Route::get('/expreport', function () {
    return view('layouts.expreport');
})->name('expreport.index');