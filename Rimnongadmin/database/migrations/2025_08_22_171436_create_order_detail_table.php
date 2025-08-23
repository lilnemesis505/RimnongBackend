<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateOrderDetailTable extends Migration
{
    public function up()
    {
        Schema::create('order_detail', function (Blueprint $table) {
            $table->unsignedBigInteger('order_id'); // PK, FK → order
            $table->unsignedBigInteger('pro_id');         // PK, FK → product

            $table->integer('amount');         // จำนวนสินค้า
            $table->decimal('price_list', 10, 2); // ราคาต่อหน่วย
            $table->decimal('pay_total', 10, 2);  // ราคารวมต่อรายการ

            // Composite Primary Key (order_id + pro_id)
            $table->primary(['order_id', 'pro_id']);

            // Foreign Keys
            $table->foreign('order_id')->references('order_id')->on('order')->onDelete('cascade');
            $table->foreign('pro_id')->references('pro_id')->on('product')->onDelete('cascade');
        });
    }

    public function down()
    {
        Schema::dropIfExists('order_detail');
    }
};
