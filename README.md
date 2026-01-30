<div align="center">

# 📅 PLANNO
**Personal Schedule Manager**

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart)
![Firebase Auth](https://img.shields.io/badge/Firebase-Authentication-orange?style=for-the-badge&logo=firebase)
![MockAPI](https://img.shields.io/badge/MockAPI-REST%20Database-green?style=for-the-badge&logo=api)
![Netlify](https://img.shields.io/badge/Netlify-Deployed-00C7B7?style=for-the-badge&logo=netlify)

<br>

**Planno** adalah aplikasi manajemen jadwal lintas platform (Mobile & Web) yang dirancang untuk membantu produktivitas harian. Aplikasi ini memungkinkan pengguna mencatat, mengatur, dan memantau agenda harian dengan antarmuka yang modern, responsif, dan terintegrasi dengan layanan cloud.

</div>

---

## 🔗 Akses & Demo Aplikasi

Berikut adalah tautan untuk mengakses aplikasi dan melihat demonstrasi penggunaannya:

| Platform | Link Akses |
| :--- | :--- |
| 🌐 **Versi Web** | [**Buka Planno Web App**](https://planno-jun.netlify.app/) |
| 📱 **Download APK** | [**Google Drive - Android APK**](https://drive.google.com/drive/folders/1_84EMmVY77iD_gnxX4Y3i_Ehkb0iXTH1?usp=drive_link) |
| 🎬 **Video Demo** | [**Tonton Video Demo**](https://drive.google.com/drive/folders/1WpwxNCZBVw-vpykvi3d1MT9fg7aY-et1?usp=drive_link) |

> **⚠️ Catatan Penting:**
> Source code ini lengkap dan dapat di-build. Namun, fitur **Google Sign-In** dibatasi (*restricted*) hanya untuk SHA-1 environment pengembangan saya dan domain web produksi demi keamanan API Key.

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

Aplikasi ini dilengkapi dengan berbagai fitur modern untuk menunjang produktivitas:

### 🔐 Sistem Autentikasi
* **Secure Login:** Autentikasi aman terintegrasi dengan **Firebase Authentication**.
* **Google Sign-In:** Mendukung login cepat menggunakan akun Google.
* **Email & Password:** Pendaftaran akun manual dengan validasi data yang ketat.

### 📅 Manajemen Jadwal (Core)
* **REST API Integration:** Seluruh data jadwal disimpan dan dikelola menggunakan **MockAPI**.
* **CRUD Operations:** Fitur lengkap *Create, Read, Update, Delete* jadwal secara real-time.
* **Task Categorization:** Pengelompokan tugas otomatis dengan format teks yang rapi (Kapitalisasi).
* **Calendar View:** Integrasi kalender interaktif untuk memantau agenda berdasarkan tanggal.

### 🎨 Antarmuka & UX
* **Adaptive Theme:** Mendukung **Dark Mode** dan Light Mode mengikuti preferensi sistem/pengguna.
* **Responsive Design:** Tampilan optimal baik di Layar HP (Android) maupun Web Browser.
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

## 📸 Galeri Aplikasi

Berikut adalah tampilan antarmuka aplikasi Planno:

### 1. Onboarding & Autentikasi
| Splash Screen | Login Page | Register Page |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/ee575332-bc83-4a2b-a286-d9d3cf2bb8fd" width="200" /> | <img src="https://github.com/user-attachments/assets/73210b5d-876d-45f0-b6d7-b35451aa6683" width="200" /> | <img src="https://github.com/user-attachments/assets/750f0101-2ae1-4121-8028-ef576ee28af7" width="200" /> |

### 2. Dashboard Home (Beranda)
| Home View 1 | Home View 2 | Home View 3 |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/70a474f5-3c04-49ef-aaba-eb0a43525e20" width="200" /> | <img src="https://github.com/user-attachments/assets/e3e41f50-fee6-4c80-8da3-1dcb5dbd83ef" width="200" /> | <img src="https://github.com/user-attachments/assets/d63ba1cc-88bd-430c-8fb6-8a8386d44115" width="200" /> |
| <img src="https://github.com/user-attachments/assets/f72918e1-70e0-44a2-8cc8-3121fd00a8bd" width="200" /> | <img src="https://github.com/user-attachments/assets/1d8f7208-97ec-4601-8561-5837347ff791" width="200" /> | *(Empty State / Varian)* |

### 3. Kalender & List Jadwal
| Tampilan Kalender | Detail Kalender | List Jadwal |
| :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/aafe9f66-7c19-49d3-928a-8c18c065dc5b" width="200" /> | <img src="https://github.com/user-attachments/assets/cef5e542-7dde-43d7-88a3-07abc454dfd3" width="200" /> | <img src="https://github.com/user-attachments/assets/982cc7e7-986a-4692-985c-2334983bd1a0" width="200" /> |

### 4. Pengaturan & Profil
| List Kosong | Menu Pengaturan | Theme Setting | Profil User |
| :---: | :---: | :---: | :---: |
| <img src="https://github.com/user-attachments/assets/f1312d7d-36bc-4778-afd6-9f3efac6516f" width="180" /> | <img src="https://github.com/user-attachments/assets/14cfb65f-fc5d-4a48-9332-6a9674a171bb" width="180" /> | <img src="https://github.com/user-attachments/assets/c0bdf48f-3265-4491-a951-720610c8e7a6" width="180" /> | <img src="https://github.com/user-attachments/assets/415031c6-e923-4156-87d6-1347f78e94da" width="180" /> |

<br>
