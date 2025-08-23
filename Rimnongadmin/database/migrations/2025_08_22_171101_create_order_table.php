<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderTable extends Migration
{
    public function up()
    {
        Schema::create('order', function (Blueprint $table) {
    $table->bigIncrements('order_id'); // PK

    $table->unsignedBigInteger('cus_id'); // FK → customer
    $table->dateTime('order_date');
    $table->dateTime('receive_date')->nullable();

    $table->unsignedBigInteger('em_id'); // ✅ ต้องตรงกับ employee
    $table->unsignedBigInteger('promo_id')->nullable(); // ✅ ต้องตรงกับ promotion

    $table->decimal('price_total', 10, 2);
    $table->timestamps();

    // Foreign Keys
    $table->foreign('cus_id')->references('cus_id')->on('customer')->onDelete('cascade');
    $table->foreign('em_id')->references('em_id')->on('employee')->onDelete('cascade');
    $table->foreign('promo_id')->references('promo_id')->on('promotion')->onDelete('set null');
});
    }

    public function down()
    {
        Schema::dropIfExists('order');
    }
};
