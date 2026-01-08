# UAS_PemrogramanMobile2_Arizal-Junior

# 📅 PLANNO (Plan Now) – Smart Schedule Planner App

**Planno** adalah aplikasi *mobile* berbasis **Flutter** yang dikembangkan untuk membantu pengguna dalam **mengelola jadwal dan perencanaan aktivitas** secara efektif dan terorganisir.

Aplikasi ini dibuat untuk memenuhi tugas **Mata Kuliah Pemrograman Mobile**, dengan fokus utama pada penerapan:
- **Konsumsi REST API**
- **Firebase Authentication**
- **Manajemen State & Navigasi (Drawer)**

---

## 👨‍💻 Pengembang

Dibuat oleh
* **Nama:** Arizal Junior
* **NIM:** 23552011310
* **Kelas:** 23 CNS B
* **Mata Kuliah:** Pemrograman Mobile II

---

## 🎯 Tujuan Pengembangan

Planno dikembangkan dengan tujuan:
- Mengimplementasikan komunikasi data jadwal menggunakan **REST API**.
- Mengelola keamanan akses pengguna menggunakan **Firebase Authentication**.
- Melakukan implementasi **CRUD (Create, Read, Update, Delete)**.

---

## ✨ Fitur Utama

Aplikasi ini memiliki lebih dari **7 Halaman** interaktif dengan fitur-fitur berikut:

### 1. 📝 Manajemen Jadwal (CRUD)
* Menambahkan, mengubah, dan menghapus jadwal aktivitas.
* Setiap jadwal memiliki judul, deskripsi, tanggal, dan waktu.
* User Interface yang ramah pengguna dengan **Date & Time Picker**.

### 2. 🌐 Integrasi REST API
* Seluruh data jadwal disimpan secara terpusat melalui **REST API Endpoint** (MockAPI).
* Mendukung sinkronisasi data (Get, Post, Put, Delete) secara *asynchronous*.
* Pemisahan logika bisnis (*service*) dengan tampilan (*UI*).

### 3. 🔐 Autentikasi Pengguna (Firebase Auth)
* Login dan registrasi aman menggunakan Email & Password.
* Validasi input ganda (*password confirmation*) untuk keamanan registrasi.
* Sistem **Auto-Logout** dan pengecekan status login (*Auth State Changes*).

### 4. 📅 Filter Kalender Interaktif
* Fitur kalender untuk melihat jadwal spesifik pada tanggal tertentu.
* Memudahkan pengguna memantau agenda harian secara visual.

### 5. 👤 Manajemen Profil & Navigasi
* Halaman **Profil Pengguna** yang menampilkan informasi akun login.
* Navigasi aplikasi yang mudah menggunakan **Side Menu (Drawer)**.
* Halaman **Tentang Aplikasi** (*About*) sebagai identitas pengembang.

### 6. 📱 Deployment Multi-Platform
* Aplikasi dirancang responsif dan siap dijalankan pada:
  - **Android**
  - **Web / PWA** 

---

### Catatan
Untuk MockAPI bisa saja kedepannya saya ganti menggunakan Firebase
