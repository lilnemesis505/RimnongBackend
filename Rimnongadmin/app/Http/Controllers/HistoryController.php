<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\History;
use App\Models\OrderDetail;


class HistoryController extends Controller
{
    public function index()
    {

        // สมมุติว่าเรามีโมเดล History ที่ใช้ดึงข้อมูลประวัติการขาย
        $details = OrderDetail::latest()->paginate(10); // ✅ ดึงข้อมูลจาก order_details
    return view('layouts.history.history', compact('details')); // ✅ ส่งไปยัง view
}

    
}
