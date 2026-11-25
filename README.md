# 0071_API_PortfoBalance
**Backend REST API untuk Aplikasi Manajemen Portofolio Multi-Aset dan Perencanaan Rebalancing**

Proyek Tugas Akhir Mata Kuliah Pengembangan Aplikasi Mobile (2026) — Program Studi Teknologi Informasi, Universitas Muhammadiyah Yogyakarta (UMY).

* **Nama:** Muhammad Daffa Azakki
* **NIM:** 20240140071
* **Tema:** Keuangan
* **Mobile Repository:** [0071_PortfoBalance](https://github.com/MuhammadDaffaAzakki/0071_PortfoBalance)

---

## 1. Deskripsi Singkat
`0071_API_PortfoBalance` adalah layanan Backend REST API berbasis **Node.js**, **Express**, dan **PostgreSQL** yang menangani autentikasi pengguna (JWT & RBAC), pencatatan kepemilikan aset lintas sekuritas, riwayat transaksi, serta kalkulasi *rebalancing* untuk aplikasi Android **PortfoBalance**.

## 2. Teknologi yang Digunakan
* **Runtime & Framework:** Node.js, Express.js
* **Database:** PostgreSQL (`pg` connection pool)
* **Keamanan & Autentikasi:** JSON Web Token (`jsonwebtoken`), `bcryptjs`, Role-Based Access Control (`ADMIN` & `INVESTOR`)
* **Konfigurasi:** `dotenv`, `cors`

## 3. Cara Menjalankan Server Secara Lokal
1. Clone repositori ini:
   ```bash
   git clone https://github.com/MuhammadDaffaAzakki/0071_API_PortfoBalance.git
   ```
2. Masuk ke direktori proyek dan pasang *dependencies*:
   ```bash
   cd 0071_API_PortfoBalance
   npm install
   ```
3. Salin file `.env.example` menjadi `.env`, lalu sesuaikan konfigurasi koneksi PostgreSQL (`DB_USER`, `DB_PASSWORD`, `DB_NAME`) dan `JWT_SECRET`.
4. Buat database `portfobalance_db` di PostgreSQL dan jalankan skrip DDL pada file `database/schema.sql`.
5. Jalankan server:
   ```bash
   node index.js
   ```
   Server akan berjalan di `http://localhost:3000`.

## 4. Daftar Endpoint Tersedia
* `GET /` — Cek status server REST API
* `POST /api/auth/register` — Registrasi akun pengguna baru (`INVESTOR` / `ADMIN`)
* `POST /api/auth/login` — Autentikasi pengguna dan penerbitan token JWT

---

## 5. Progress Mingguan (Weekly Progress)

Berikut adalah linimasa pengembangan backend **PortfoBalance** berdasarkan riwayat git commit:

### 🗓️ Minggu 1 — Pertemuan 9 (25 November 2026)
* **Inisialisasi & Setup Lingkungan Backend** ( `c61b9ce` ): Inisialisasi proyek Node.js dan Express, pemasangan *dependencies* utama (`express`, `pg`, `cors`, `dotenv`, `bcryptjs`, `jsonwebtoken`), konfigurasi `.gitignore`, serta template `.env.example`.

### 🗓️ Minggu 2 — Pertemuan 10 (25 November 2026)
* **Skema Database PostgreSQL** ( `6d6d985` ): Pembuatan skrip DDL 8 tabel relasional (`users`, `asset_categories`, `master_assets`, `wallets`, `portfolio_holdings`, `transactions`, `allocation_targets`, `watchlists`) beserta data awal (*seeding*) kategori dan instrumen investasi.
* **Koneksi Database & Autentikasi JWT** ( `167dc80` ): Konfigurasi *connection pool* PostgreSQL (`config/db.js`) serta pembuatan *endpoint* `POST /api/auth/register` (dengan *hashing* `bcryptjs`) dan `POST /api/auth/login` (penerbitan token JWT).