<?php


namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\ProductType;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // แสดงรายการสินค้า
    public function index()
    {
        $types = ProductType::all();
        $products = Product::paginate(10); // แบ่งหน้า
        return view('layouts.products.product', compact('products','types'));
    }

    // ฟอร์มเพิ่มสินค้า
    public function create()
    {
         $types = ProductType::all(); // ดึงประเภทสินค้าทั้งหมด
        return view('layouts.products.add', compact('types'));
    
    }

    // บันทึกสินค้าใหม่
public function store(Request $request)
{
    // Validate ข้อมูล
    $request->validate([
        'pro_name' => 'required|string|max:50',
        'price' => 'required|numeric',
        'type_id' => 'required|integer',
        'image' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
    ]);

    // รับข้อมูลเฉพาะที่มีใน DB
    $data = $request->only('pro_name', 'price', 'type_id');
     $product =Product::create($data);

    // อัปโหลดรูปเก็บใน storage/app/public/products
     if ($request->hasFile('image')) {
    $file = $request->file('image');
    $filename = $product->pro_id . '.jpg'; // ตั้งชื่อไฟล์ตาม pro_id
    $file->storeAs('products', $filename, 'public'); // เก็บไว้ใน storage/app/public/product
}

   

    // Redirect ไปหน้า product.blade.php พร้อม success message
    return redirect()->route('product.index')->with('success', 'เพิ่มสินค้าเรียบร้อยแล้ว');
}
public function filter(Request $request)
{
    $typeId = $request->input('type_id');

    $query = Product::with('type');

    if ($typeId) {
        $query->where('type_id', $typeId);
    }

    $products = $query->paginate(12);
    $types = ProductType::all();

    return view('layouts.products.product', compact('products', 'types'));
}

    public function destroy($id)
    {
        $product = Product::findOrFail($id);
        $product->delete();

        return redirect()->route('products.index')->with('success', 'ลบสินค้าเรียบร้อยแล้ว');
    }
}
