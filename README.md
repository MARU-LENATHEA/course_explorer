# Course Data Manager - REST API & Backend Integration

* **Nama:** I Kadek Dimas Pradana
* **NIM:** 2415051046
* **Kelas:** PTI

---

## Dokumentasi REST Endpoint (Tahap 1)
* **Base URL:** `https://course-api-pearl.vercel.app`
* **Endpoint URL:** `https://course-api-pearl.vercel.app/courses`
* **HTTP Method:** `GET`
* **Status Code:** `200 OK`
* **Resource:** `courses`
* **Field JSON:**
  1. `id` (integer) - Identifier unik course
  2. `code` (string) - Kode mata kuliah (contoh: "MOB01")
  3. `title` (string) - Judul / nama course
  4. `credits` (integer) - Jumlah SKS
  5. `status` (string) - Status course (`planned`, `active`, `done`)