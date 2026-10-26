# Normalisasi Kopma - Pertemuan 04

- **Nama:** ADAM MAULANA FIRMANSYAH
- **NIM:** 25430042
- **Kelas:** B

## 1. Spreadsheet lama dan tiga anomali

Ketua Kopma menyerahkan spreadsheet lama yang menyimpan semua data nota dalam satu tabel besar. Contoh sebagian barisnya (data fiktif):

| no_nota_penjualan | tgl_penjualan | no_anggota | nama_anggota | kode_barang | nama_barang | qty | harga_satuan |
|---|---|---|---|---|---|---|---|
| PJ-2609-0141 | 2026-09-14 | A-0457 | Rina Amelia | BR-001 | Pensil 2B | 3 | 4000 |
| PJ-2609-0141 | 2026-09-14 | A-0457 | Rina Amelia | BR-007 | Buku tulis | 2 | 6000 |
| PJ-2609-0198 | 2026-09-20 | A-0457 | Rina A. | BR-001 | Pensil 2B | 1 | 4500 |
| PJ-2609-0231 | 2026-09-27 | A-0312 | Dimas Pratama | BR-007 | Buku tulis | 1 | 6000 |

| Anomali | Contoh pada tabel di atas |
|---|---|
| **Ubah** | Anggota A-0457 tertulis "Rina Amelia" dan "Rina A." pada baris berbeda. Memperbaiki satu baris tidak memperbaiki baris lain, sehingga satu fakta menjadi tidak konsisten |
| **Sisip** | Mahasiswa yang baru mendaftar menjadi anggota tetapi belum belanja tidak dapat dicatat, karena setiap baris membutuhkan nomor nota dan barang |
| **Hapus** | Menghapus nota PJ-2609-0231 (satu-satunya nota A-0312) ikut menghapus data anggota Dimas Pratama |

Perbedaan harga pensil (4000 dan 4500) pada nota berbeda adalah sah, karena AB-04 menyatakan harga nota dapat berbeda dari harga barang saat ini.

## 2. Dari UNF ke 1NF

**UNF.** Satu nota menyimpan grup berulang barang (ditandai kurung kurawal):

```
NOTA_UNF (no_nota_penjualan, tgl_penjualan, kode_petugas, nama_petugas,
          no_anggota, nama_anggota,
          { kode_barang, nama_barang, qty_detail_penjualan,
            harga_satuan_detail_penjualan, subtotal_detail_penjualan },
          jumlah_penjualan, diskon_penjualan, total_penjualan)
```

**1NF.** Grup berulang dihilangkan: satu baris untuk setiap barang pada setiap nota, dan kunci primer menjadi komposit (no_nota_penjualan, kode_barang).

```
NOTA_1NF (no_nota_penjualan, kode_barang, tgl_penjualan, kode_petugas,
          nama_petugas, no_anggota, nama_anggota, nama_barang,
          qty_detail_penjualan, harga_satuan_detail_penjualan,
          subtotal_detail_penjualan, jumlah_penjualan,
          diskon_penjualan, total_penjualan)
```

Persentase diskon dan poin loyalitas per nota (`persen_diskon_penjualan`, `poin_didapat`, `poin_ditukar`, `bayar_penjualan`) ikut menjadi atribut tingkat nota pada tahap berikutnya.

## 3. Dependensi fungsional

Dependensi diturunkan dari aturan bisnis Pertemuan 2, bukan dari isi spreadsheet.

| Kode | Dependensi fungsional | Dasar |
|---|---|---|
| FD1 | no_nota_penjualan -> tgl_penjualan, kode_petugas, no_anggota, persen_diskon_penjualan, bayar_penjualan, poin_didapat, poin_ditukar | AB-01, AB-11, AB-13 |
| FD2 | kode_petugas -> nama_petugas, peran_petugas | definisi entitas petugas |
| FD3 | no_anggota -> nim_anggota, nama_anggota, prodi_anggota, no_hp_anggota, status_anggota | AB-05 |
| FD3b | nim_anggota -> no_anggota | AB-05 (NIM unik) |
| FD4 | kode_barang -> nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang | AB-03 |
| FD5 | (no_nota_penjualan, kode_barang) -> qty_detail_penjualan, harga_satuan_detail_penjualan | AB-04 |
| FD6 | qty_detail_penjualan, harga_satuan_detail_penjualan -> subtotal_detail_penjualan | nilai turunan |
| FD7 | no_faktur_pembelian -> tanggal_pembelian, kode_pemasok, kode_petugas | AB-06, AB-12 |
| FD8 | kode_pemasok -> nama_pemasok, telepon_pemasok, alamat_pemasok | definisi entitas pemasok |
| FD9 | (no_faktur_pembelian, kode_barang) -> qty_detail_pembelian, harga_beli_detail_pembelian | faktur pemasok |

Dependensi yang **salah** dan tidak dipakai: `kode_barang -> harga_satuan_detail_penjualan`. Contoh data yang kebetulan sama tidak membuktikan dependensi, dan AB-04 justru menyatakan harga pada nota dapat berbeda dari harga barang saat ini.

## 4. Menuju 2NF dan 3NF

**2NF.** FD1 hanya bergantung pada sebagian kunci (no_nota_penjualan) dan FD4 hanya pada kode_barang. Keduanya dipisah menjadi relasi sendiri: `penjualan` (kunci no_nota_penjualan) dan `barang` (kunci kode_barang). Sisanya menjadi `detail_penjualan`.

**3NF.** Pada `penjualan` terdapat rantai no_nota_penjualan -> kode_petugas -> nama_petugas dan no_nota_penjualan -> no_anggota -> nama_anggota. Petugas dan anggota dipisah menjadi relasi sendiri. Dengan cara yang sama, `pembelian` dipisah dari `pemasok` (FD7 dan FD8).

| Tahap | Relasi hasil |
|---|---|
| UNF | NOTA_UNF (grup berulang barang) |
| 1NF | NOTA_1NF (kunci komposit no_nota_penjualan, kode_barang) |
| 2NF | PENJUALAN, DETAIL_PENJUALAN, BARANG |
| 3NF | PENJUALAN, DETAIL_PENJUALAN, BARANG, PETUGAS, ANGGOTA (dan PEMBELIAN, DETAIL_PEMBELIAN, PEMASOK) |

## 5. Keputusan nilai turunan

| Nilai turunan | Keputusan | Alasan |
|---|---|---|
| subtotal_detail_penjualan | Tidak disimpan | Dapat dihitung dari qty dan harga satuan (FD6), sehingga tidak mungkin tidak konsisten |
| jumlah_penjualan (subtotal nota) | Tidak disimpan | Jumlah seluruh subtotal pada detail |
| diskon_penjualan | Tidak disimpan | Dihitung dari subtotal dan `persen_diskon_penjualan` yang tersimpan per nota |
| total_penjualan | Tidak disimpan | Subtotal dikurangi diskon; pada data operasional yang masih dapat berubah, menghitung lebih aman daripada menyimpan |
| potongan_poin | Tidak disimpan | Dihitung dari `poin_ditukar` (setiap 50 poin bernilai Rp5.000) |
| saldo_poin_anggota | Tidak disimpan | Dihitung dari jumlah poin_didapat dikurangi poin_ditukar pada seluruh nota anggota |

`persen_diskon_penjualan` **disimpan** per nota karena ia bukan nilai turunan: aturan diskon dapat berubah, sedangkan nota lama harus tetap sama (AB-13).

## 6. Skema relasional akhir

Garis bawah (di sini ditandai PK) adalah kunci primer, UK kunci unik, dan FK kunci tamu.

| Tabel | Kunci primer | Kunci unik | Kunci tamu | Atribut lain |
|---|---|---|---|---|
| petugas | id_petugas | kode_petugas | - | nama_petugas, peran_petugas |
| anggota | id_anggota | no_anggota, nim_anggota | - | nama_anggota, prodi_anggota, no_hp_anggota, status_anggota, tgl_daftar_anggota |
| barang | id_barang | kode_barang | - | nama_barang, kategori_barang, harga_jual_barang, stok_barang, stok_min_barang |
| pemasok | id_pemasok | kode_pemasok | - | nama_pemasok, telepon_pemasok, alamat_pemasok |
| penjualan | id_penjualan | no_nota_penjualan | id_petugas, id_anggota (boleh kosong) | tgl_penjualan, persen_diskon_penjualan, bayar_penjualan, poin_didapat, poin_ditukar |
| detail_penjualan | (id_penjualan, id_barang) | - | id_penjualan, id_barang | qty_detail_penjualan, harga_satuan_detail_penjualan |
| pembelian | id_pembelian | no_faktur_pembelian | id_pemasok, id_petugas | tanggal_pembelian |
| detail_pembelian | (id_pembelian, id_barang) | - | id_pembelian, id_barang | qty_detail_pembelian, harga_beli_detail_pembelian |

**Perbedaan dengan skema kanonik buku (Tabel 4.2):** skema saya menambah `persen_diskon_penjualan`, `poin_didapat`, dan `poin_ditukar` pada `penjualan` (keputusan Pertemuan 3), serta `id_petugas` pada `pembelian` (AB-12). Pola kunci pengganti `id_*` sebagai kunci primer dan kode alami sebagai kunci unik sama dengan skema kanonik.

## 7. Pemeriksaan BCNF

| Tabel | Penentu (determinan) | Kunci kandidat? | Hasil |
|---|---|---|---|
| petugas | id_petugas, kode_petugas | Ya, keduanya kunci kandidat | BCNF |
| anggota | id_anggota, no_anggota, nim_anggota | Ya, ketiganya kunci kandidat | BCNF |
| barang | id_barang, kode_barang | Ya | BCNF |
| pemasok | id_pemasok, kode_pemasok | Ya | BCNF |
| penjualan | id_penjualan, no_nota_penjualan | Ya | BCNF |
| detail_penjualan | (id_penjualan, id_barang) | Ya | BCNF |
| pembelian | id_pembelian, no_faktur_pembelian | Ya | BCNF |
| detail_pembelian | (id_pembelian, id_barang) | Ya | BCNF |

Kunci pengganti `id_*` tidak menghapus dependensi fungsional. Pemeriksaan tetap dilakukan terhadap kunci alami, misalnya `nim_anggota -> no_anggota` pada `anggota`, yang tetap dijaga sebagai kunci unik.
