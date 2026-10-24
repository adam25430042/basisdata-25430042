# Dokumen Kebutuhan Data - Koperasi Mahasiswa Sejahtera (Kopma)

- **Nama:** ADAM MAULANA FIRMANSYAH
- **NIM:** 25430042
- **Kelas:** B

## 1. Latar belakang dan aktivitas organisasi

Kopma menjual alat tulis, makanan ringan, dan minuman di lingkungan kampus. Pembeli dapat berupa anggota atau umum. Mahasiswa mendaftar sebagai anggota dengan NIM, nama, program studi, dan nomor HP, lalu memperoleh nomor anggota berformat A-xxxx. Anggota aktif memperoleh diskon 5% untuk setiap nota. Kopma juga memberi poin loyalitas kepada anggota (Latihan E.1).

Tiga kasir bekerja bergantian per sif. Kasir mencatat penjualan dan mencetak nota. Setiap sore petugas gudang memeriksa stok; bila stok suatu barang di bawah batas minimum, ia membuat pesanan pembelian ke pemasok. Ketika barang datang, stok bertambah sesuai faktur pemasok. Setiap awal bulan, ketua koperasi menerima laporan omzet, barang terlaris, barang dengan stok menipis, dan anggota paling aktif.

Keluhan dari wawancara: harga di nota lama tidak bisa dicek lagi, stok di buku catatan kadang minus, dan anggota sering lupa membawa kartu sehingga dicari lewat NIM.

## 2. Aktor dan proses bisnis

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan anggota | Kasir (atas permintaan mahasiswa) | Mahasiswa ingin menjadi anggota |
| PB-02 | Mencatat penjualan | Kasir | Pembeli membayar di kasir |
| PB-03 | Memesan barang ke pemasok | Petugas gudang | Stok di bawah batas minimum |
| PB-04 | Menerima barang dari pemasok | Petugas gudang | Barang datang bersama faktur |
| PB-05 | Menyusun laporan bulanan | Ketua koperasi | Awal bulan |
| PB-06 | Mengelola data pemasok | Petugas gudang | Pemasok baru atau data pemasok berubah |
| PB-07 | Mengelola data barang | Petugas gudang | Barang baru, atau harga dan batas minimum stok berubah |
| PB-08 | Mengelola status anggota | Ketua koperasi | Anggota berhenti atau mendaftar ulang |

PB-06, PB-07, dan PB-08 ditambahkan setelah pemeriksaan matriks CRUD pada bagian 7 (Titik Analisis 3).

## 3. Dokumen sumber yang dianalisis

Dokumen sumber adalah **nota penjualan Kopma**. Setiap isian nota adalah kandidat elemen data. Isian nota diambil dari contoh nota pada buku praktikum.

| No | Elemen nota | Contoh | Disimpan atau turunan? | Catatan |
|---|---|---|---|---|
| 1 | Nomor nota | PJ-2609-0142 | Disimpan | Unik per nota |
| 2 | Tanggal-jam | 2026-09-14 10:21 | Disimpan | Dasar laporan per hari dan per bulan |
| 3 | Kasir | Nama kasir | Disimpan | Penanggung jawab nota |
| 4 | Anggota (opsional) | A-0457 | Disimpan | Kosong untuk pembeli umum |
| 5 | Barang | Pensil 2B | Disimpan | Satu baris per barang |
| 6 | Qty | 3 | Disimpan | Jumlah per baris |
| 7 | Harga satuan saat transaksi | 4000 | Disimpan | Per baris, agar nota lama tidak berubah (AB-04) |
| 8 | Subtotal | 12000 | Turunan | qty x harga satuan |
| 9 | Diskon | 5% (Rp600) | Persentase disimpan, nilainya turunan | Persentase yang berlaku saat nota dibuat disimpan per nota (AB-13); nilai rupiah dihitung dari subtotal |
| 10 | Total | 11400 | Turunan | Subtotal dikurangi diskon |
| 11 | Bayar | 20000 | Disimpan | Uang yang diterima kasir |

**Tambahan elemen untuk poin loyalitas (Latihan E.1):**

| No | Elemen | Contoh | Disimpan atau turunan? | Catatan |
|---|---|---|---|---|
| 12 | Poin didapat | 3 | Disimpan (per nota) | 1 poin tiap kelipatan Rp10.000 dari total belanja anggota (AB-07) |
| 13 | Poin ditukar | 50 | Disimpan (per nota) | Hanya kelipatan 50 poin (AB-08) |
| 14 | Potongan poin | 5000 | Turunan | (poin ditukar / 50) x Rp5.000 |
| 15 | Saldo poin anggota | 12 | Turunan | Poin didapat dikurangi poin ditukar; keputusan disimpan atau tidak dibahas di Modul 4 |

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Anggota | nomor anggota, NIM, nama, program studi, nomor HP, status aktif | Formulir pendaftaran |
| Barang | kode, nama, kategori, harga jual, stok, batas minimum stok | Daftar barang, faktur |
| Penjualan | nomor nota, tanggal-jam, kasir, anggota (opsional), bayar, persen diskon, poin didapat, poin ditukar | Nota penjualan |
| Detail penjualan | nomor nota, barang, qty, harga saat transaksi | Nota penjualan |
| Petugas | kode petugas, nama, peran (kasir, gudang, ketua) | Wawancara |
| Pemasok | kode, nama, telepon, alamat | Faktur pemasok |
| Pembelian dan detailnya | nomor faktur, tanggal, pemasok, barang, qty, harga beli | Faktur pemasok |

## 5. Aturan bisnis

| Kode | Aturan bisnis |
|---|---|
| AB-01 | Setiap nota memiliki nomor unik dan minimal satu baris barang. |
| AB-02 | Penjualan boleh tanpa anggota (pembeli umum); jika ada, anggota harus berstatus aktif untuk memperoleh diskon 5%. |
| AB-03 | Stok barang tidak boleh negatif; penjualan ditolak bila qty melebihi stok tersedia. |
| AB-04 | Harga jual yang dipakai pada nota disimpan per baris dan tidak berubah meski harga barang kemudian naik. |
| AB-05 | NIM anggota unik; pencarian anggota dapat dilakukan lewat nomor anggota atau NIM. |
| AB-06 | Pesanan pembelian dibuat bila stok kurang dari batas minimum barang tersebut. |
| AB-07 | Setiap kelipatan Rp10.000 dari total belanja anggota pada satu nota bernilai 1 poin, dibulatkan ke bawah (total Rp37.500 menghasilkan 3 poin). |
| AB-08 | Penukaran poin hanya dalam kelipatan 50 poin, dan setiap 50 poin bernilai potongan Rp5.000. |
| AB-09 | Poin hanya diberikan kepada anggota yang berstatus aktif; pembeli umum tidak memperoleh poin. |
| AB-10 | Saldo poin anggota tidak boleh negatif, sehingga poin yang ditukar tidak boleh melebihi saldo. |
| AB-11 | Poin yang didapat dan ditukar dicatat per nota dan tidak berubah setelah nota dibuat. |
| AB-12 | Setiap pembelian dari pemasok diterima oleh tepat satu petugas gudang, dan petugas itu dicatat pada faktur pembelian. |
| AB-13 | Persentase diskon yang berlaku saat nota dibuat disimpan pada nota (0% untuk pembeli umum) dan tidak berubah meskipun aturan diskon kemudian diubah. |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan |
|---|---|---|
| KI-01 | Omzet dan jumlah nota per hari dan per bulan | Penjualan, detail penjualan |
| KI-02 | Lima barang terlaris per bulan berdasarkan qty | Detail penjualan, barang |
| KI-03 | Barang dengan stok di bawah batas minimum | Barang |
| KI-04 | Sepuluh anggota dengan belanja terbesar per bulan | Penjualan, detail penjualan, anggota |
| KI-05 | Saldo poin setiap anggota dan jumlah poin yang ditukar per bulan | Anggota, penjualan |
| KI-06 | Rekap omzet dan jumlah nota per minggu | Penjualan, detail penjualan |

## 7. Matriks CRUD

| Proses | Anggota | Barang | Penjualan | Detail | Pemasok | Pembelian |
|---|---|---|---|---|---|---|
| PB-01 Daftar anggota | C | | | | | |
| PB-02 Catat penjualan | R | R, U | C | C | | |
| PB-03 Pesan ke pemasok | | R | | | R | C |
| PB-04 Terima barang | | U | | | R | U |
| PB-05 Laporan bulanan | R | R | R | R | | R |
| PB-06 Kelola data pemasok | | | | | C, R, U | |
| PB-07 Kelola data barang | | C, R, U | | | | |
| PB-08 Kelola status anggota | R, U | | | | | |

Matriks awal memperlihatkan dua entitas tanpa huruf C: **Pemasok** dan **Barang**. Karena itu ditambahkan PB-06 (kelola data pemasok) dan PB-07 (kelola data barang). Status aktif anggota juga belum diubah proses mana pun, sehingga ditambahkan PB-08 (kelola status anggota).

Pada Latihan E.1, proses PB-02 juga membaca saldo poin anggota dan membuat catatan poin pada nota (C pada Penjualan). Saldo poin dihitung dari catatan poin per nota, sehingga tidak ada akses U tambahan pada Anggota. Entitas Petugas tidak dicantumkan pada matriks, sama seperti matriks contoh di buku, karena pengelolaan data petugas berada di luar cakupan latihan ini.

## 8. Kamus data awal

| Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|
| no_anggota | Nomor anggota koperasi | A-0457 | Unik, format A-4 digit | Ketua |
| nim_anggota | NIM anggota | 2301010123 | Unik, 10 digit | Ketua |
| no_hp_anggota | Nomor HP anggota | 0812xxxx | Data pribadi, akses terbatas | Ketua |
| no_nota_penjualan | Nomor nota penjualan | PJ-2609-0142 | Unik per nota | Kasir |
| harga_satuan_detail_penjualan | Harga jual saat transaksi | 4000 | Bilangan bulat >= 0 (rupiah) | Kasir |
| stok_barang | Jumlah barang tersedia | 35 | Bilangan bulat >= 0 (AB-03) | Petugas gudang |
| poin_didapat | Poin yang diperoleh pada satu nota | 3 | Bilangan bulat >= 0, dari AB-07 | Kasir |
| poin_ditukar | Poin yang dipakai pada satu nota | 50 | Kelipatan 50 dan tidak melebihi saldo (AB-08, AB-10) | Kasir |
| persen_diskon_penjualan | Persentase diskon yang berlaku pada satu nota | 5 | Bilangan bulat 0 sampai 100; 0 untuk pembeli umum (AB-13) | Kasir |

## 9. Kebutuhan non-fungsional data

- **Volume:** sekitar 150 nota per hari.
- **Retensi:** data transaksi disimpan minimal 5 tahun.
- **Privasi:** nomor HP anggota adalah data pribadi dan hanya boleh dilihat oleh ketua, sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

## 10. Isu kualitas data yang diantisipasi

| Isu | Gejala | Antisipasi |
|---|---|---|
| Harga historis hilang | Nota lama menampilkan harga baru | Simpan harga per baris nota (AB-04) |
| Stok negatif | Stok di buku catatan minus | Stok tidak boleh negatif (AB-03) |
| Anggota sulit dicari | Anggota lupa kartu | Pencarian lewat NIM (AB-05) |
| Poin tidak akurat | Poin ditukar melebihi saldo | Saldo tidak boleh negatif (AB-10) |
