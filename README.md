# Course Data Manager (Course Explorer v2)

Aplikasi manajemen data mata kuliah (Course Data Manager) berbasis Flutter yang mengintegrasikan REST API dummy dan backend database persisten PostgreSQL Supabase menggunakan arsitektur modular (Repository Pattern & Provider).

## Identitas Pengembang
- **Nama:** I Kadek Dimas Pradana
- **NIM:** 2415051046
- **Program Studi:** Pendidikan Teknik Informatika
- **Institusi:** Universitas Pendidikan Ganesha (Undiksha)

---

## Fitur Utama
- **Operasi CRUD Lengkap:**
  - **Create:** Menambahkan data mata kuliah baru dengan validasi form (kode, judul, SKS, status).
  - **Read:** Menampilkan daftar mata kuliah dari database beserta indikator loading, state kosong, dan error handling.
  - **Update:** Memperbarui judul, bobot SKS, dan status course berdasarkan identifier database.
  - **Delete:** Menghapus data course yang dilengkapi dialog konfirmasi (`AlertDialog`) untuk mencegah ketidaksengajaan.
- **Manajemen Favorit Konsisten:** Fitur bookmark mata kuliah favorit berbasis kode unik (`code`) yang tetap sinkron antar-layar dan tahan terhadap refresh database.
- **Tampilan Responsif:** Menggunakan `NavigationBar` untuk tampilan mobile (< 600dp) dan `NavigationRail` adaptif untuk layar lebar/tablet/desktop (>= 600dp).
- **Graceful Error Handling:** Dilengkapi penanganan HTTP 404, kegagalan koneksi internet (offline), kendala parsing JSON, dan violation constraint database tanpa crash.

---

## Arsitektur Sistem & Repository Pattern
Aplikasi dirancang dengan pemisahan dependensi secara ketat:
```text
UI (Screens & Widgets) 
       ↓
State Management (CourseProvider) 
       ↓
Abstraksi Repository (CourseRepository)
       ↓
Kontrak Sumber Data (CourseDataSource)
     ↙                     ↘
REST API Service         Supabase Service
(CourseApiService)     (CourseSupabaseService)
```
- **Prinsip Modular:** Provider dan UI tidak memiliki ketergantungan langsung (`import`) terhadap package jaringan (`http` atau `supabase_flutter`).
- **Plug-and-Play DataSource:** Pergantian sumber data antara REST API Vercel dan PostgreSQL Supabase dilakukan hanya melalui satu baris inisialisasi pada `lib/main.dart`.

---

## Backend & Basis Data
1. **REST API Latihan:** `https://course-api-pearl.vercel.app`
2. **Database Persisten:** PostgreSQL pada Supabase
   - **Tabel:** `public.courses`
   - **Kolom:** `id` (bigint PK), `code` (text unique), `title` (text), `credits` (integer), `status` (text check: planned, active, done), `created_at` (timestamptz).
   - **Security:** Row Level Security (RLS) diaktifkan.

---

## Cara Menjalankan Aplikasi
1. **Clone repositori:**
   ```bash
   git clone [https://github.com/MARU-LENATHEA/course_explorer.git](https://github.com/MARU-LENATHEA/course_explorer.git)
   cd course_explorer
   ```
2. **Pasang dependency:**
   ```bash
   flutter pub get
   ```
3. **Konfigurasi Kredensial:**
   Pastikan file `lib/constants/supabase_constants.dart` telah terkonfigurasi dengan URL dan Publishable/Anon Key Supabase Anda.
4. **Jalankan aplikasi:**
   ```bash
   flutter run
   ```