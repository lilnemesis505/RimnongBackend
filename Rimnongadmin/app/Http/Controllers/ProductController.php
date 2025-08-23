<?php


namespace App\Http\Controllers;

use App\Models\Product;
use App\Models\Protype;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ProductController extends Controller
{
    // แสดงรายการสินค้า
    public function index()
    {
        $types = Protype::all();
        $products = Product::paginate(10); // แบ่งหน้า
        return view('layouts.products.product', compact('products','types'));
    }

    // ฟอร์มเพิ่มสินค้า
    public function create()
    {
         $types = Protype::all(); // ดึงประเภทสินค้าทั้งหมด
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
    $types = Protype::all();

    return view('layouts.products.product', compact('products', 'types'));
}

    //edit 
    public function edit($pro_id)
{
    $product = Product::with('type')->findOrFail($pro_id);
    $types = Protype::all(); // ถ้ามีประเภทสินค้าให้เลือก
    return view('layouts.products.edit', compact('product', 'types'));
}

public function update(Request $request, $pro_id)
{
    $request->validate([
        'pro_name' => 'required|string|max:255',
        'price' => 'required|numeric',
        'type_id' => 'required|exists:protype,type_id',
        'image' => 'nullable|image|mimes:jpg,jpeg,png|max:2048',
    ]);

    $product = Product::findOrFail($pro_id);
    $product->pro_name = $request->pro_name;
    $product->price = $request->price;
    $product->type_id = $request->type_id;

    if ($request->hasFile('image')) {
        $filename = $product->pro_id . '.jpg';
        $request->file('image')->storeAs('public/products', $filename);
    }

    $product->save();

    return redirect()->route('product.index')->with('success', 'แก้ไขข้อมูลเรียบร้อยแล้ว');
}
    public function destroy($pro_id)
{
    $product = Product::findOrFail($pro_id);

    // ลบรูปจาก storage ถ้ามี
    $imagePath = 'public/products/' . $product->pro_id . '.jpg';
    if (Storage::exists($imagePath)) {
        Storage::delete($imagePath);
    }

    // ลบข้อมูลจาก DB
    $product->delete();

    return redirect()->route('product.index')->with('success', 'ลบสินค้าสำเร็จแล้ว');
}



}
