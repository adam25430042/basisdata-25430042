# Normalisasi Proyek Klinik Bunda_AMF - Pertemuan 04

- **Nama:** ADAM MAULANA FIRMANSYAH
- **NIM:** 25430042
- **Kelas:** B
- **Dokumen sumber:** Lembar Kunjungan Pasien (Pertemuan 2)

## 1. Anomali pada dokumen sumber

Lembar kunjungan menyimpan identitas pasien, dokter, poli, resep, dan pembayaran dalam satu lembar. Jika seluruh lembar disimpan sebagai satu tabel besar, muncul tiga anomali:

| Anomali | Contoh pada klinik |
|---|---|
| **Ubah** | Dokter pindah poli: nama poli tertulis berulang pada setiap kunjungan dokter itu, dan memperbaiki satu baris tidak memperbaiki baris lain |
| **Sisip** | Dokter atau obat baru tidak dapat dicatat sebelum ada kunjungan yang memakainya, dan kunjungan tanpa resep (AB-05) tidak dapat dicatat karena kode obat menjadi bagian kunci |
| **Hapus** | Menghapus satu-satunya kunjungan seorang pasien ikut menghapus data pasien itu |

## 2. Dari UNF ke 1NF

**UNF.** Satu kunjungan memuat grup berulang obat (ditandai kurung kurawal):

```
KUNJUNGAN_UNF (no_kunjungan, tanggal_kunjungan,
               no_rekam_medis, nama_pasien, jenis_kelamin_pasien,
               tanggal_lahir_pasien, alamat_pasien, no_hp_pasien,
               kode_dokter, nama_dokter, kode_poli_dokter,
               kode_jadwal, hari_praktik, jam_mulai_sesi,
               kode_poli_kunjungan, nama_poli, tarif_konsultasi_poli,
               keluhan, diagnosa,
               { kode_obat, nama_obat, kekuatan_obat, satuan_obat,
                 aturan_pakai, jumlah_obat, harga_satuan_saat_kunjungan,
                 subtotal_obat },
               biaya_konsultasi, total_biaya_obat, diskon_konsultasi,
               total_biaya_kunjungan,
               no_kuitansi, tanggal_jam_bayar, kode_kasir, nama_kasir,
               jumlah_dibayar)
```

**1NF.** Grup berulang dihilangkan: satu baris untuk setiap obat pada setiap kunjungan, dengan kunci komposit (no_kunjungan, kode_obat).

```
KUNJUNGAN_1NF (no_kunjungan, kode_obat, tanggal_kunjungan,
               no_rekam_medis, nama_pasien, jenis_kelamin_pasien,
               tanggal_lahir_pasien, alamat_pasien, no_hp_pasien,
               kode_dokter, nama_dokter, kode_poli_dokter,
               kode_jadwal, hari_praktik, jam_mulai_sesi,
               kode_poli_kunjungan, nama_poli, tarif_konsultasi_poli,
               keluhan, diagnosa, nama_obat, kekuatan_obat, satuan_obat,
               aturan_pakai, jumlah_obat, harga_satuan_saat_kunjungan,
               subtotal_obat, biaya_konsultasi, total_biaya_obat,
               diskon_konsultasi, total_biaya_kunjungan,
               no_kuitansi, tanggal_jam_bayar, kode_kasir, nama_kasir,
               jumlah_dibayar)
```

## 3. Dependensi fungsional

Dependensi diturunkan dari aturan bisnis Pertemuan 2 dan 3, bukan dari isi lembar.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_kunjungan -> tanggal_kunjungan, no_rekam_medis, kode_jadwal, kode_poli_kunjungan, keluhan, diagnosa, biaya_konsultasi | AB-01, AB-04, AB-06, AB-13 |
| FD2 | no_rekam_medis -> nama_pasien, jenis_kelamin_pasien, tanggal_lahir_pasien, alamat_pasien, no_hp_pasien | AB-02 |
| FD3 | kode_dokter -> nama_dokter, kode_poli_dokter | Masalah 3 pada dokumen sumber |
| FD4 | kode_poli -> nama_poli, tarif_konsultasi_poli | definisi entitas poli |
| FD5 | kode_jadwal -> kode_dokter, hari_praktik, jam_mulai_sesi | AB-03 |
| FD6 | kode_obat -> nama_obat, kekuatan_obat, satuan_obat, harga_satuan_obat, stok_obat, stok_minimum_obat | AB-07 pada dokumen kebutuhan data |
| FD7 | (no_kunjungan, kode_obat) -> aturan_pakai, jumlah_obat, harga_satuan_saat_kunjungan | AB-05, AB-06 |
| FD8 | jumlah_obat, harga_satuan_saat_kunjungan -> subtotal_obat | nilai turunan |
| FD9 | no_kunjungan -> no_kuitansi, tanggal_jam_bayar, kode_kasir, jumlah_dibayar | AB-11 |
| FD9b | no_kuitansi -> no_kunjungan | AB-11 (kuitansi unik, satu pembayaran per kunjungan) |
| FD10 | kode_petugas -> nama_petugas, peran_petugas | definisi entitas petugas |

Dependensi yang **salah** dan tidak dipakai: `kode_poli -> biaya_konsultasi` dan `kode_obat -> harga_satuan_saat_kunjungan`. Tarif poli dan harga obat dapat berubah, sedangkan lembar lama harus tetap menunjukkan harga saat kunjungan (AB-06). Karena itu `biaya_konsultasi` bergantung pada kunjungan (FD1), dan `harga_satuan_saat_kunjungan` bergantung pada pasangan kunjungan dan obat (FD7).

## 4. Menuju 2NF dan 3NF

**2NF.** Pada KUNJUNGAN_1NF dengan kunci komposit (no_kunjungan, kode_obat), FD1, FD2, FD3, FD5, dan FD9 hanya bergantung pada no_kunjungan (sebagian kunci), dan FD6 hanya pada kode_obat. Maka dipisah: `kunjungan`, `obat`, dan sisanya menjadi `detail_resep` (FD7).

**3NF.** Pada `kunjungan` terdapat rantai transitif:

- no_kunjungan -> no_rekam_medis -> data pasien (FD1, FD2), sehingga `pasien` dipisah.
- no_kunjungan -> kode_jadwal -> kode_dokter (FD1, FD5) dan kode_dokter -> nama_dokter, kode_poli_dokter (FD3), sehingga `dokter` dan `jadwal_praktik` dipisah.
- kode_poli -> nama_poli, tarif_konsultasi_poli (FD4), sehingga `poli` dipisah.
- Pembayaran (FD9) dipisah menjadi `pembayaran`, sedangkan nama kasir berasal dari `petugas` (FD10).

**Temuan penting dari pemeriksaan 3NF.** Jika `kunjungan` menyimpan `kode_dokter` bersama `kode_jadwal`, maka terjadi dependensi transitif no_kunjungan -> kode_jadwal -> kode_dokter, karena jadwal sudah menentukan dokter (FD5). Atribut `kode_dokter` pada `kunjungan` melanggar 3NF dan berisiko tidak konsisten dengan dokter pada jadwal (inilah celah yang dijaga sementara oleh AB-13). Keputusannya: **`id_dokter` dihapus dari `kunjungan`**, dan dokter pada sebuah kunjungan ditentukan melalui `jadwal_praktik`.

**Pengecualian yang disengaja: poli pada kunjungan.** `kunjungan` tetap menyimpan `id_poli`. Atribut itu tidak melanggar 3NF karena ia adalah **potret historis** (AB-04): poli tempat kunjungan terjadi tidak boleh ikut berubah ketika dokter pindah poli, sehingga nilainya tidak dapat diturunkan dari `kode_dokter -> kode_poli_dokter`. Alasan yang sama berlaku untuk `biaya_konsultasi` (AB-06): ia adalah potret tarif saat kunjungan, bukan nilai yang dapat diturunkan dari tarif poli saat ini.

| Tahap | Relasi hasil |
|---|---|
| UNF | KUNJUNGAN_UNF (grup berulang obat) |
| 1NF | KUNJUNGAN_1NF (kunci komposit no_kunjungan, kode_obat) |
| 2NF | KUNJUNGAN, DETAIL_RESEP, OBAT |
| 3NF | KUNJUNGAN, PASIEN, DOKTER, POLI, JADWAL_PRAKTIK, DETAIL_RESEP, OBAT, PEMBAYARAN, PETUGAS |

## 5. Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| usia_pasien | Tidak disimpan | Dihitung dari tanggal_lahir_pasien; nilai yang disimpan akan usang setiap tahun |
| subtotal_obat | Tidak disimpan | Jumlah obat dikali harga satuan saat kunjungan (FD8) |
| total_biaya_obat | Tidak disimpan di kunjungan | Jumlah seluruh subtotal pada detail_resep |
| diskon_konsultasi | Tidak disimpan di kunjungan | Dihitung dari biaya_konsultasi dan aturan diskon kontrol ulang (AB-09); potret historisnya tersimpan pada `jumlah_dibayar` |
| total_biaya_kunjungan | Tidak disimpan di kunjungan | Pada data operasional dihitung dari konsultasi, obat, dan diskon. Potret historisnya disimpan sebagai `jumlah_dibayar` pada `pembayaran` |

Pola keputusannya sama dengan pembahasan buku: data operasional yang masih dapat berubah dihitung, sedangkan potret historis yang tidak boleh berubah disimpan. `pembayaran.jumlah_dibayar` adalah potret historis itu (AB-11).

## 6. Skema relasional akhir

| Tabel | Kunci primer | Kunci unik | Kunci tamu | Atribut lain |
|---|---|---|---|---|
| poli | id_poli | kode_poli | - | nama_poli, tarif_konsultasi_poli |
| dokter | id_dokter | kode_dokter | id_poli | nama_dokter, status_aktif_dokter |
| jadwal_praktik | id_jadwal | (id_dokter, hari_praktik, jam_mulai_sesi) | id_dokter | hari_praktik, jam_mulai_sesi |
| pasien | id_pasien | no_rekam_medis | - | nama_pasien, jenis_kelamin_pasien, tanggal_lahir_pasien, alamat_pasien, no_hp_pasien |
| petugas | id_petugas | kode_petugas | - | nama_petugas, peran_petugas |
| kunjungan | id_kunjungan | no_kunjungan | id_pasien, id_jadwal, id_poli, id_petugas | tanggal_kunjungan, keluhan, diagnosa, biaya_konsultasi |
| obat | id_obat | kode_obat | - | nama_obat, kekuatan_obat, satuan_obat, harga_satuan_obat, stok_obat, stok_minimum_obat, status_aktif_obat |
| detail_resep | (id_kunjungan, id_obat) | - | id_kunjungan, id_obat | aturan_pakai, jumlah_obat, harga_satuan_saat_kunjungan |
| pembayaran | id_pembayaran | no_kuitansi, id_kunjungan | id_kunjungan, id_petugas | tanggal_jam_bayar, jumlah_dibayar |

## 7. Pemeriksaan BCNF

| Tabel | Penentu (determinan) | Kunci kandidat? | Hasil |
|---|---|---|---|
| poli | id_poli, kode_poli | Ya | BCNF |
| dokter | id_dokter, kode_dokter | Ya | BCNF |
| jadwal_praktik | id_jadwal, (id_dokter, hari_praktik, jam_mulai_sesi) | Ya, keduanya kunci kandidat | BCNF |
| pasien | id_pasien, no_rekam_medis | Ya | BCNF |
| petugas | id_petugas, kode_petugas | Ya | BCNF |
| kunjungan | id_kunjungan, no_kunjungan | Ya | BCNF |
| obat | id_obat, kode_obat | Ya | BCNF |
| detail_resep | (id_kunjungan, id_obat) | Ya | BCNF |
| pembayaran | id_pembayaran, no_kuitansi, id_kunjungan | Ya, ketiganya kunci kandidat | BCNF |

## 8. Perubahan pada ERD proyek

| No | Perubahan | Alasan | Dokumen yang ikut diperbarui |
|---|---|---|---|
| 1 | Hapus atribut `id_dokter` dari `kunjungan` dan relasi `dokter menangani kunjungan` | Dependensi transitif no_kunjungan -> kode_jadwal -> kode_dokter melanggar 3NF; dokter ditentukan lewat jadwal | AB-01 dan AB-13 pada dokumen kebutuhan data, penelusuran KI-03 dan KI-04, dan gambar ERD |

Jalur baru untuk kebutuhan informasi yang terdampak:

| KI | Jalur sebelumnya | Jalur sesudah perubahan |
|---|---|---|
| KI-03 Riwayat kunjungan pasien | pasien, kunjungan, dokter, detail_resep, obat | pasien, kunjungan, jadwal_praktik, dokter, detail_resep, obat |
| KI-04 Kunjungan per dokter dan per poli | dokter, kunjungan, poli | kunjungan, jadwal_praktik, dokter, poli |

Skema 3NF ini menjadi dasar skrip DDL Pertemuan 5, sehingga setiap kunci dan aturan di atas harus muncul sebagai constraint.
