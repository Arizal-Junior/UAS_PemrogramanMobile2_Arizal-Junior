# uas_planno

# 📅 PLANNO - Personal Schedule Manager

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)
![Firebase Auth](https://img.shields.io/badge/Firebase-Authentication-orange?style=for-the-badge&logo=firebase)
![MockAPI](https://img.shields.io/badge/MockAPI-REST%20Database-green?style=for-the-badge&logo=api)
![Netlify](https://img.shields.io/badge/Netlify-Deployed-00C7B7?style=for-the-badge&logo=netlify)

**Planno** adalah aplikasi manajemen jadwal lintas platform (Mobile & Web) yang dirancang untuk membantu produktivitas harian. Aplikasi ini memungkinkan pengguna mencatat, mengatur, dan memantau agenda harian dengan antarmuka yang modern, responsif, dan terintegrasi dengan layanan cloud.

---

## 👨‍💻 Informasi Pengembang

| Atribut | Keterangan |
| :--- | :--- |
| **Nama** | Arizal Junior |
| **Project** | UAS Pemrograman Mobile |
| **Studi** | Teknik Informatika |
| **Tahun** | 2026 |

---

## 🚀 Fitur Unggulan

Aplikasi ini dilengkapi dengan berbagai fitur modern:

### 🔐 Sistem Autentikasi (Firebase)
* **Secure Login:** Autentikasi aman menggunakan **Firebase Authentication**.
* **Google Sign-In:** Mendukung login cepat menggunakan akun Google.
* **Email & Password:** Pendaftaran akun manual dengan validasi data.

### 📅 Manajemen Jadwal (MockAPI)
* **REST API Integration:** Seluruh data jadwal disimpan dan dikelola menggunakan **MockAPI**.
* **CRUD Operations:** Fitur lengkap *Create, Read, Update, Delete* jadwal secara real-time.
* **Task Categorization:** Pengelompokan tugas otomatis (Kapitalisasi kategori agar rapi).
* **Calendar View:** Integrasi kalender interaktif untuk melihat agenda per tanggal.

### 🎨 Antarmuka & UX
* **Adaptive Theme:** Mendukung **Dark Mode** dan Light Mode.
* **Responsive Design:** Optimal di Layar HP (Android) dan Web Browser.
* **Auto-Refresh Logic:** Pembaruan tampilan otomatis saat data berubah tanpa perlu reload manual.

---

## 🛠️ Teknologi yang Digunakan

* **Framework:** [Flutter](https://flutter.dev/) (Dart)
* **Authentication:** Firebase Auth (Google & Email)
* **Database / API:** [MockAPI.io](https://mockapi.io/) (RESTful API)
* **Hosting (Web):** Netlify
* **State Management:** Native `setState` & `FutureBuilder`
* **Key Packages:**
    * `firebase_auth`, `google_sign_in` (Auth)
    * `http` (Koneksi ke MockAPI)
    * `table_calendar` (Kalender)
    * `shared_preferences` (Local Settings)

---

## 🔗 Tautan Aplikasi

Aplikasi versi Web dapat diakses secara langsung melalui tautan berikut:

👉 **[Buka Planno Web App](https://planno-jun.netlify.app/)**

---

## 📸 Galeri Aplikasi

| Halaman Login | Dashboard Home | Tampilan Kalender |
| :---: | :---: | :---: |
| <img src="assets/screenshots/login.png" width="200" alt="Login Page" /> | <img src="assets/screenshots/home.png" width="200" alt="Home Page" /> | <img src="assets/screenshots/calendar.png" width="200" alt="Calendar Page" /> |

---

## ⚙️ Cara Instalasi (Local)

Jika ingin menjalankan project ini di komputer lokal:
