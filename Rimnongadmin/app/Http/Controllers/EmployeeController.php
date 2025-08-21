<?php

namespace App\Http\Controllers;
use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Employee; 

class EmployeeController extends Controller
{
    public function index()
    {
        $employees = Employee::paginate(50);
        return view('layouts.employee', compact('employees'));
    }
}