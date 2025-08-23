<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Admin;

class AdminLoginController extends Controller
{
    public function showLoginForm()
    {
        return view('admin.login'); // สร้าง view นี้ด้านล่าง
    }

    public function login(Request $request)
    {
        $request->validate([
            'username' => 'required',
            'password' => 'required',
        ]);

        $admin = Admin::where('username', $request->username)
                      ->where('password', $request->password) // ❗ plain text
                      ->first();

        if ($admin) {
            session(['admin_id' => $admin->admin_id]);
            return redirect()->route('welcome');
        }

        return back()->withErrors(['login' => 'ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง']);
    }

    public function logout(Request $request)
{
    session()->forget('admin_id');
    $request->session()->invalidate();
    $request->session()->regenerateToken();

    return redirect()->route('login');
}

}



