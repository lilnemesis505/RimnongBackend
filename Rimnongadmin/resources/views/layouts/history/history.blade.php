<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Promotion Management</title>
    <!-- AdminLTE CSS via CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css">
</head>
<body class="hold-transition sidebar-mini">
<div class="wrapper">

    <!-- Navbar -->
    <nav class="main-header navbar navbar-expand navbar-white navbar-light">
        <span class="navbar-brand">My Admin</span>
    </nav>

    <!-- Sidebar -->
    <aside class="main-sidebar sidebar-dark-primary elevation-4">
        <a href="#" class="brand-link">AdminLTE</a>
        <div class="sidebar">
            <nav class="mt-2">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">
                    <li class="nav-item">
                        <a href="{{ route('welcome') }}" class="nav-link text-white">
                            <i class="nav-icon fas fa-home-alt"></i> <p>หน้าหลัก</p>
                        </a>
                    </li>
                </ul>
                <hr class="bg-white">
                <ul class="nav nav-pills nav-sidebar flex-column" data-widget="treeview" role="menu">
                    <li class="nav-item">
                        <a href="{{ route('promotion.index') }}" class="nav-link bg-primary text-white">
                            <i class="nav-icon fas fa-ticket"></i> <p>ประวัติการขาย</p>
                        </a>
                    </li>
                    <li class="nav-item">
                        <a href="#" class="nav-link text-white">
                            <i class="nav-icon fas fa-chart-bar"></i> <p>ใบเสร็จ</p>
                        </a>
                    </li>
                </ul>
            </nav>
        </div>
    </aside>

    <!-- Content Wrapper -->
    <div class="content-wrapper">
        <section class="content pt-4">
            <div class="container-fluid">
                <div class="card shadow-sm">
                    <div class="card-header bg-dark text-white">
                        <h4 class="mb-0">📜 ประวัติการขาย</h4>
                    </div>
                    <div class="card-body">
                       @if($details->isEmpty())
    <div class="alert alert-info text-center">ยังไม่มีรายการขายในระบบ</div>
@else
    <div class="table-responsive">
        <table class="table table-bordered table-hover">
            <thead class="table-secondary text-center">
                <tr>
                    <th>#</th>
                    <th>รหัสคำสั่งซื้อ</th>
                    <th>ชื่อสินค้า</th>
                    <th>จำนวน</th>
                    <th>ราคาต่อหน่วย</th>
                    <th>ราคารวม</th>
                    <th>วันที่สั่งซื้อ</th>
                </tr>
            </thead>
            <tbody>
                @foreach($details as $index => $detail)
                    <tr class="text-center">
                        <td>{{ $index + 1 }}</td>
                        <td>{{ $detail->order_id }}</td>
                        <td>{{ $detail->product_name }}</td>
                        <td>{{ $detail->quantity }}</td>
                        <td>{{ number_format($detail->unit_price, 2) }}</td>
                        <td>{{ number_format($detail->quantity * $detail->unit_price, 2) }}</td>
                        <td>{{ \Carbon\Carbon::parse($detail->created_at)->format('d/m/Y H:i') }}</td>
                    </tr>
                @endforeach
            </tbody>
        </table>
        {{ $details->links() }}
    </div>
@endif
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->

    </div>
</div>

<!-- AdminLTE JS via CDN -->
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
</body>
</html>
