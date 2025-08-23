<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>AdminLTE Template</title>
    <!-- AdminLTE CSS via CDN -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/css/adminlte.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@fortawesome/fontawesome-free/css/all.min.css">
</head>
<body class="hold-transition sidebar-mini layout-fixed">
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
                        <a href="#" class="nav-link active"><i class="nav-icon fas fa-home-alt"></i> <p>หน้าหลัก</p></a>
                    </li>
                </ul>
                <hr style="border-top: 1px solid #fff;">
                <ul class="nav nav-pills nav-sidebar flex-column">
                    <!-- เพิ่มแถบเมนูตรงนี้ -->
                    <li class="nav-item">
                        <a href="{{ route('product.index') }}" class="nav-link"><i class="nav-icon fas fa-shopping-cart"></i> <p>จัดการข้อมูลสินค้า</p></a>
                    </li>
                    <li class="nav-item">
                        <a href="{{ route('employee.index') }}" class="nav-link"><i class="nav-icon fas fa-user"></i> <p>จัดการข้อมูลพนักงาน</p></a>
                    </li>
                    <li class="nav-item">
                        <a href="{{ route('customer.index') }}" class="nav-link"><i class="nav-icon fas fa-users"></i> <p>ข้อมูลลูกค้า</p></a>
                    <li class="nav-item">
                        <a href="{{ route('stock.index') }}" class="nav-link"><i class="nav-icon fas fa-box"></i> <p>จัดการข้อมูลล็อตสินค้า</p></a>
                    </li>
                     <li class="nav-item">
                        <a href="{{ route('promotion.index') }}" class="nav-link"><i class="nav-icon fas fa-ticket"></i> <p>จัดการข้อมูลโปรโมชั่น</p></a>
                    </li>
                    </li>
                </ul>
                <hr style="border-top: 1px solid #fff;">
                 <ul class="nav nav-pills nav-sidebar flex-column">
                    <!-- เพิ่มแถบเมนูตรงนี้ -->
                    <li class="nav-item">
                        <a href="{{ route('history.index') }}" class="nav-link"><i class="nav-icon fas fa-history"></i> <p>ประวัติการขาย</p></a>
                    </li>
                </ul>
                <hr style="border-top: 1px solid #fff;">
                <ul class="nav nav-pills nav-sidebar flex-column">
                    <li class="nav-item">
                        <a href="#" class="nav-link"><i class="nav-icon fas fa-chart-line"></i> <p>รายงานการขาย</p></a>
                    </li>
                     <li class="nav-item">
                        <a href="#" class="nav-link"><i class="nav-icon fas fa-chart-bar"></i> <p>รายงานสินค้าหมดอายุ</p></a>
                    </li>
                </ul>
                <hr style="border-top: 1px solid #fff;">
                <ul class="nav nav-pills nav-sidebar flex-column">
                <li class="nav-item">
                        <a href="#" class="nav-link" data-toggle="modal" data-target="#logoutModal"><i class="nav-icon fas fa-sign-out-alt"></i> <p>ออกจากระบบ</p></a>
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
<!-- Footer -->
<footer class="main-footer bg-secondary"> text-center py-2">
    <strong>&copy; {{ date('Y') }} My Admin.</strong> สงวนลิขสิทธิ์ทั้งหมด
</footer>

<!-- AdminLTE JS via CDN -->
<script src="https://cdn.jsdelivr.net/npm/admin-lte@3.2/dist/js/adminlte.min.js"></script>
<div class="modal fade" id="logoutModal" tabindex="-1" role="dialog" aria-labelledby="logoutModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
      <div class="modal-header bg-warning">
        <h5 class="modal-title" id="logoutModalLabel">ยืนยันการออกจากระบบ</h5>
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
          <span aria-hidden="true">&times;</span>
        </button>
      </div>
      <div class="modal-body">
        คุณแน่ใจหรือไม่ว่าต้องการออกจากระบบ?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-dismiss="modal">ยกเลิก</button>
        <form method="POST" action="{{ route('logout') }}">
            @csrf
            <button type="submit" class="btn btn-danger">ออกจากระบบ</button>
        </form>
      </div>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>