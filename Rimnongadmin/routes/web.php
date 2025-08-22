<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\CustomerController;
use App\Http\Controllers\EmployeeController;
use App\Http\Controllers\ProductController;
use App\Http\Controllers\ProtypeController;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/', function () {
    return view('welcome');
})->name('welcome');
//  product
Route::get('/products', [ProductController::class, 'index'])->name('product.index');
Route::get('/products/add', [ProductController::class, 'create'])->name('product.add');
Route::post('/products', [ProductController::class, 'store'])->name('product.store');
Route::get('/products/{product}/edit', [ProductController::class, 'edit'])->name('product.edit');
Route::put('/products/{product}', [ProductController::class, 'update'])->name('product.update');
Route::get('/products/filter', [ProductController::class, 'filter'])->name('product.filter');
Route::delete('/products/{product}', [ProductController::class, 'destroy'])->name('product.destroy');
Route::get('/protype/add', [ProtypeController::class, 'create'])->name('protype.add');
Route::post('/protype', [ProtypeController::class, 'store'])->name('protype.store');
Route::delete('/protype/{id}', [ProtypeController::class, 'destroy'])->name('protype.delete');





//employee


// แสดงรายการพนักงาน
Route::get('/employees', [EmployeeController::class, 'index'])->name('employee.index');
Route::get('/employees/add', [EmployeeController::class, 'create'])->name('employee.add');
Route::post('/employees', [EmployeeController::class, 'store'])->name('employee.store');
Route::get('/employees/{employee}/edit', [EmployeeController::class, 'edit'])->name('employee.edit');
Route::put('/employees/{employee}', [EmployeeController::class, 'update'])->name('employee.update');
//customer
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

