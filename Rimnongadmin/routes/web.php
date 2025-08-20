<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});
Route::get('/', function () {
    return view('welcome');
})->name('welcome');

Route::get('/product', function () {
    return view('layouts.product');
})->name('products.index');

Route::get('/sale', function () {
    return view('layouts.sale');
})->name('sale.index');

Route::get('/customer', function () {
    return view('layouts.customer');
})->name('customer.index');

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