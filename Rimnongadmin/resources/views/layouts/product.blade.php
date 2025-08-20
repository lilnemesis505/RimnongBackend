<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AdminLTE Template</title>
    <!-- AdminLTE CSS via CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css">
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">
    <!-- Navbar -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <!-- ...navbar content... -->
        <span class="navbar-brand">My Admin</span>
    </nav>
    <!-- Sidebar -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="#" class="brand-link">AdminLTE</a>
        <div class="sidebar">
            <!-- Sidebar Menu -->
            <nav>
                <ul class="nav nav-pills nav-sidebar flex-column">
                    <li class="nav-item">
                        <a href="{{ route('welcome') }}" class="nav-link" style="background: none; color: #fff;">
                            <i class="nav-icon fas fa-home-alt"></i> <p>หน้าหลัก</p>
                        </a>
                    </li>
                </ul>
                <hr style="border-top: 1px solid #fff;">
                <ul class="nav nav-pills nav-sidebar flex-column">
                    <li class="nav-item">
                        <a href="#" class="nav-link active" style="background-color: #007bff; color: #fff;">
                            <i class="nav-icon fas fa-shopping-cart"></i> <p>ข้อมูลสินค้า</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link" style="background: none; color: #fff;">
                            <i class="nav-icon fas fa-plus"></i> <p>เพิ่มข้อมูลสินค้า</p>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>
    <!-- Content Wrapper -->
    <div class="content-wrapper p-3">
        @yield('content')
    </div>
</div>
<!-- AdminLTE JS via CDN -->
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>