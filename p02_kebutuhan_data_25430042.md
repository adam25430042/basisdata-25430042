# DOKUMEN KEBUTUHAN DATA - KLINIK B_AMF

- **Nama:** ADAM MAULANA FIRMANSYAH
- **NIM:** 25430042
- **Kelas:** B
- **Tema:** Klinik
- **Basis data proyek (rencana):** `klinik_042`

## 1. Latar belakang dan aktivitas organisasi

Klinik Bunda_AMF menyediakan layanan kesehatan ibu dan anak secara terpadu, meliputi pendaftaran pasien, rekam medis pengobatan, jadwal dokter, serta transaksi pembayaran layanan dan obat. Dokter praktik dalam tiga sesi per hari, yaitu mulai pukul 07.00, 15.30, dan 20.00, dengan perkiraan 75 kunjungan per hari (perhitungan pada bagian 9).

Saat ini data dicatat pada **lembar kunjungan kertas**. Pencatatan itu menimbulkan enam masalah (rinci pada bagian 3 dan 10): data pasien ditulis ulang di setiap kunjungan, beberapa obat ditulis dalam satu kolom resep, nama dokter dan poli ditulis manual, pasien sering dicari hanya dari nama, total biaya dihitung manual, dan harga lama tidak terjaga ketika harga atau tarif berubah.

Dokumen ini mencatat kebutuhan data klinik sebelum perancangan basis data: aktor dan proses bisnis, dokumen sumber, entitas kandidat, aturan bisnis, kebutuhan informasi, matriks CRUD, kamus data awal, kebutuhan non-fungsional, dan isu kualitas data.

## 2. Aktor dan proses bisnis

Aktor: **Petugas pendaftaran**, **Dokter**, **Kasir**, **Petugas obat**, dan **Admin klinik**. Pasien adalah pihak luar yang dilayani, bukan pengguna data.

| Kode | Proses bisnis | Aktor | Pemicu |
|---|---|---|---|
| PB-01 | Mendaftarkan pasien baru | Petugas pendaftaran | Pasien datang dan belum punya nomor rekam medis |
| PB-02 | Mencatat kunjungan | Petugas pendaftaran | Pasien ingin berobat pada sesi dokter tertentu |
| PB-03 | Memeriksa pasien dan mencatat diagnosa | Dokter | Pasien dipanggil sesuai antrean sesi |
| PB-04 | Meresepkan obat | Dokter | Diagnosa selesai dan pasien memerlukan obat |
| PB-05 | Menerima pembayaran | Kasir | Pemeriksaan dan resep selesai, biaya siap dihitung |
| PB-06 | Menyerahkan obat | Petugas obat | Pembayaran selesai dan pasien membawa resep |
| PB-07 | Mengelola jadwal praktik dokter | Admin klinik | Jadwal sesi baru atau berubah |
| PB-08 | Mengelola data dokter, poli, obat, tarif, dan petugas | Admin klinik | Dokter, obat, atau tarif baru atau berubah |
| PB-09 | Memperbarui data pasien | Petugas pendaftaran | Pasien lama mengubah alamat atau nomor HP |
| PB-10 | Menyusun laporan bulanan | Admin klinik | Awal bulan |

## 3. Dokumen sumber yang dianalisis

### 3.1 Lembar Kunjungan Pasien

Lembar kunjungan diisi pada setiap kunjungan: bagian identitas dan dokter oleh petugas pendaftaran, bagian keluhan, diagnosa, dan resep oleh dokter, dan bagian biaya oleh kasir. Contoh lembar yang sudah terisi (data fiktif):

| Isian | Keterangan | Diisi oleh |
|---|---|---|
| No. Kunjungan / Tanggal | KJ-0007 / 14 Oktober 2026 | Petugas pendaftaran |
| No. Rekam Medis | RM-00123 | Petugas pendaftaran |
| Nama Pasien | Siti Rahmawati | Petugas pendaftaran |
| Jenis Kelamin / Tgl Lahir | Perempuan / 12 Maret 1995 | Petugas pendaftaran |
| Alamat / No. HP | Jl. Melati No. 5, Terbanggi Besar / 0812-0000-0001 | Petugas pendaftaran |
| Dokter / Poli | dr. Budi Santoso / Poli Umum | Petugas pendaftaran |
| Keluhan | Demam 3 hari, batuk, pusing | Dokter |
| Diagnosa | Infeksi saluran pernapasan atas (ISPA) | Dokter |
| Resep | Paracetamol 500 mg, 3x1, 10 tablet @Rp500; Amoxicillin 500 mg, 3x1, 15 kapsul @Rp1.500; Vitamin C 50 mg, 1x1, 10 tablet @Rp1.000 (harga satuan saat kunjungan) | Dokter |
| Biaya Konsultasi | Rp50.000 + obat Rp37.500 = Rp87.500 | Kasir |
| Penerima Pembayaran | Ajeng (kasir) | Kasir |

Pemeriksaan hitungan: 10 x Rp500 + 15 x Rp1.500 + 10 x Rp1.000 = Rp37.500; ditambah konsultasi Rp50.000 menjadi Rp87.500.

**Masalah yang ditemukan pada lembar:**

| No | Masalah | Akibatnya |
|---|---|---|
| 1 | Data pasien (nama, alamat, HP) ditulis ulang di setiap kunjungan | Boros waktu, rawan salah ketik, data satu pasien bisa berbeda di tiap lembar |
| 2 | Beberapa obat ditulis dalam satu kolom "Resep" | Sulit dicari, dihitung, dan dibuat laporan, misalnya obat yang paling sering diresepkan |
| 3 | Nama dokter dan poli ditulis manual di tiap lembar | Jika dokter ganti poli atau nama, banyak lembar harus diubah satu per satu |
| 4 | Nomor rekam medis ada, tetapi tidak selalu dipakai karena pasien lama sering lupa nomornya | Pasien dicari dari nama, pasien bernama sama bisa tertukar, riwayat tercampur |
| 5 | Total biaya dihitung manual | Mudah salah hitung dan sulit dicek ulang |
| 6 | Harga obat dan tarif konsultasi bisa berubah, tetapi lembar lama harus tetap menunjukkan harga saat kunjungan | Total yang dihitung ulang dari harga terbaru membuat biaya kunjungan lama berubah dan tidak cocok dengan kuitansi |

**Pembedahan isian lembar** (tiap sel yang memuat lebih dari satu hal dipecah):

| No | Elemen | Contoh nilai | Disimpan atau turunan? | Data pribadi? | Catatan |
|---|---|---|---|---|---|
| 1 | Nomor kunjungan | KJ-0007 | Disimpan | Tidak | Pengenal unik tiap kunjungan |
| 2 | Tanggal kunjungan | 14 Oktober 2026 | Disimpan | Tidak | Dasar laporan per hari dan per bulan; lembar tidak mencatat jam |
| 3 | Nomor rekam medis | RM-00123 | Disimpan | Ya (identitas) | Melekat pada pasien, bukan pada kunjungan; harus unik agar Masalah 4 teratasi |
| 4 | Nama pasien | Siti Rahmawati | Disimpan | Ya (identitas) | Cukup disimpan sekali per pasien (Masalah 1) |
| 5 | Jenis kelamin | Perempuan | Disimpan | Ya (identitas) | Tadinya satu sel dengan tanggal lahir, dipecah |
| 6 | Tanggal lahir | 12 Maret 1995 | Disimpan | Ya (identitas) | Usia adalah turunan dari tanggal lahir, jadi tidak disimpan |
| 7 | Alamat | Jl. Melati No. 5, Terbanggi Besar | Disimpan | Ya (identitas) | Tadinya satu sel dengan nomor HP, dipecah |
| 8 | Nomor HP | 0812-0000-0001 | Disimpan | Ya (identitas) | Akses terbatas pada petugas yang berkepentingan |
| 9 | Nama dokter | dr. Budi Santoso | Disimpan | Tidak (data staf) | Cukup disimpan sekali per dokter (Masalah 3) |
| 10 | Poli | Poli Umum | Disimpan | Tidak | Melekat pada dokter; dicatat juga per kunjungan agar riwayat tidak berubah (lihat AB-04) |
| 11 | Keluhan | Demam 3 hari, batuk, pusing | Disimpan | Ya (kesehatan, spesifik) | Hanya dokter dan pihak berwenang yang boleh membaca |
| 12 | Diagnosa | ISPA | Disimpan | Ya (kesehatan, spesifik) | Diisi dokter; akses sangat terbatas |
| 13 | Nama obat | Paracetamol | Disimpan | Tidak | Satu kunjungan bisa banyak obat, jadi satu baris per obat (Masalah 2) |
| 14 | Kekuatan obat | 500 mg | Disimpan | Tidak | Dicatat sebagai elemen terpisah dari nama obat |
| 15 | Aturan pakai | 3x1 | Disimpan | Ya (kesehatan, spesifik) | Bagian dari resep pasien |
| 16 | Jumlah obat | 10 tablet | Disimpan | Ya (kesehatan, spesifik) | Bagian dari resep; satuan dicatat bersama |
| 17 | Harga satuan saat kunjungan | Rp500 | Disimpan (per baris resep) | Tidak | Tidak boleh berubah saat harga naik (Masalah 6) |
| 18 | Total biaya obat | Rp37.500 | Turunan | Tidak | Jumlah x harga satuan; keputusan disimpan atau tidak dibahas di Modul 4 |
| 19 | Biaya konsultasi | Rp50.000 | Disimpan (tarif saat kunjungan) | Tidak | Tarif bisa berubah, jadi disimpan per kunjungan (Masalah 6) |
| 20 | Total biaya kunjungan | Rp87.500 | Turunan | Tidak | Biaya konsultasi + total biaya obat (dikurangi diskon bila berlaku, AB-09) |
| 21 | Petugas pendaftaran | Adil | Disimpan | Tidak (data staf) | Penanggung jawab data pasien dan kunjungan |
| 22 | Penerima pembayaran | Ajeng | Disimpan | Tidak (data staf) | Penanggung jawab data pembayaran |

**Temuan.** Beberapa sel pada lembar memuat dua elemen sekaligus (jenis kelamin dengan tanggal lahir, alamat dengan nomor HP, dan resep dengan banyak obat), sehingga harus dipecah agar dapat dicari dan dihitung. Total biaya obat dan total biaya kunjungan dapat dihitung ulang, tetapi harga satuan dan tarif konsultasi harus tersimpan per kunjungan agar kuitansi lama tetap cocok. Keluhan, diagnosa, dan resep termasuk data kesehatan yang bersifat spesifik, sehingga aksesnya harus dibatasi sejak awal.

### 3.2 Jadwal praktik dokter

Jadwal praktik dokter dibagi tiga sesi per hari. Contoh susunan jadwal (fiktif, untuk menunjukkan data yang dicatat):

| Sesi | Jam mulai | Dokter | Poli |
|---|---|---|---|
| Pagi | 07.00 | dr. Budi Santoso | Poli Umum |
| Sore | 15.30 | dr. Rina Kartika | Poli Kandungan |
| Malam | 20.00 | dr. Fauzi Hakim | Poli Anak |

Jadwal ini menentukan dokter mana yang dapat dipilih saat mencatat kunjungan (AB-03).

**Catatan asumsi:** peran petugas (Adil sebagai petugas pendaftaran, Lisa sebagai petugas obat, Ajeng sebagai kasir, Sofian sebagai admin klinik) dan nama dokter pada jadwal adalah rancangan fiktif untuk dokumen ini.

## 4. Entitas kandidat dan elemen data

| Entitas kandidat | Elemen data utama | Sumber |
|---|---|---|
| Pasien | nomor rekam medis, nama, jenis kelamin, tanggal lahir, alamat, nomor HP | Lembar kunjungan |
| Dokter | kode dokter, nama dokter, poli, status aktif | Lembar kunjungan, jadwal |
| Poli | kode poli, nama poli, tarif konsultasi | Lembar kunjungan |
| Jadwal praktik | dokter, hari, sesi, jam mulai | Jadwal praktik |
| Kunjungan | nomor kunjungan, tanggal, pasien, dokter, poli saat kunjungan, jadwal praktik,, keluhan, diagnosa, biaya konsultasi, petugas pendaftaran | Lembar kunjungan |
| Obat | kode obat, nama, kekuatan, satuan, harga satuan, stok, batas minimum stok, status aktif | Lembar kunjungan |
| Detail resep | nomor kunjungan, obat, aturan pakai, jumlah, harga satuan saat kunjungan | Lembar kunjungan |
| Petugas | kode petugas, nama, peran | Lembar kunjungan, wawancara |
| Pembayaran | nomor kuitansi, kunjungan, tanggal-jam bayar, jumlah dibayar, kasir | Lembar kunjungan (Masalah 6) |

Nilai turunan yang tidak dicatat sebagai elemen utama: usia pasien, total biaya obat, total biaya kunjungan, dan besar diskon.

## 5. Aturan bisnis

| Kode | Aturan bisnis | Asal |
|---|---|---|
| AB-01 | Setiap kunjungan memiliki nomor unik (format KJ-xxxx) dan tepat satu pasien, satu dokter, dan satu poli | PB-02 |
| AB-02 | Setiap pasien memiliki nomor rekam medis unik (format RM-xxxxx) yang dibuat sekali saat pendaftaran dan dipakai pada semua kunjungannya; data pasien disimpan sekali, bukan ditulis ulang per kunjungan | PB-01, Masalah 1 dan 4 |
| AB-03 | Kunjungan hanya dapat dicatat dengan dokter yang memiliki jadwal pada sesi tersebut (sesi 07.00, 15.30, atau 20.00) | PB-02, PB-07 |
| AB-04 | Poli pada kunjungan dicatat sebagai poli dokter saat kunjungan; jika dokter pindah poli, kunjungan lama tidak berubah | PB-02, Masalah 3 dan 6 |
| AB-05 | Satu kunjungan boleh tanpa resep, dan paling banyak memuat 9 jenis obat (P + 2); satu obat tidak diresepkan dua kali pada kunjungan yang sama | PB-04, parameter P |
| AB-06 | Harga satuan obat dan tarif konsultasi disimpan per baris resep dan per kunjungan, serta tidak berubah ketika harga atau tarif kemudian naik | PB-04, PB-02, Masalah 6 |
| AB-07 | Stok obat tidak boleh negatif; obat tidak dapat diserahkan melebihi stok yang tersedia | PB-06 |
| AB-08 | Total biaya kunjungan adalah biaya konsultasi ditambah jumlah (jumlah obat x harga satuan saat kunjungan), dihitung otomatis dan tidak diketik manual | PB-05, Masalah 5 |
| AB-09 | Pasien yang kontrol ulang dalam 7 hari sejak kunjungan sebelumnya memperoleh diskon 7% pada biaya konsultasi (nilai 7 berasal dari P) | PB-05, parameter P |
| AB-10 | Keluhan, diagnosa, dan resep hanya dapat dilihat oleh dokter yang menangani; petugas pendaftaran tidak dapat melihatnya dan kasir hanya melihat rincian biaya | Bagian 9 (privasi) |
| AB-11 | Pembayaran dicatat setelah dokter menyelesaikan pemeriksaan dan resep; jumlah dibayar sama dengan total biaya setelah diskon, dan setiap pembayaran memiliki nomor kuitansi unik | PB-05 |
| AB-12 | Data kunjungan, resep, dan pembayaran tidak dihapus; dokter, obat, dan pasien yang tidak lagi aktif ditandai nonaktif | Bagian 9 (retensi) |
| AB-13 | Setiap kunjungan mencatat tepat satu jadwal praktik (sesi) tempat kunjungan terjadi, dan dokter pada kunjungan harus sama dengan dokter pada jadwal itu. | PB-02, AB-03 |

## 6. Kebutuhan informasi

| Kode | Kebutuhan informasi | Data yang diperlukan | Pengguna |
|---|---|---|---|
| KI-01 | Jumlah kunjungan dan pendapatan (konsultasi + obat) per hari dan per bulan | Kunjungan, detail resep, pembayaran | Admin klinik |
| KI-02 | Lima obat yang paling sering diresepkan per bulan | Detail resep, obat | Admin klinik |
| KI-03 | Riwayat kunjungan satu pasien (tanggal, dokter, diagnosa, obat) | Pasien, kunjungan, detail resep | Dokter |
| KI-04 | Jumlah kunjungan per dokter dan per poli per bulan | Kunjungan, dokter | Admin klinik |
| KI-05 | Obat dengan stok di bawah batas minimum | Obat | Petugas obat |
| KI-06 | Jadwal praktik dokter per hari beserta sesinya | Jadwal praktik, dokter, poli | Petugas pendaftaran |
| KI-07 | Rincian biaya satu kunjungan yang cocok dengan kuitansi (harga saat kunjungan) | Kunjungan, detail resep, pembayaran | Kasir |
| KI-08 | Jumlah kunjungan per sesi praktik (pagi, sore, malam) per bulan | Kunjungan, jadwal praktik | Admin klinik |

## 7. Matriks CRUD

| Proses | Pasien | Dokter | Poli | Jadwal | Kunjungan | Obat | Detail resep | Petugas | Pembayaran |
|---|---|---|---|---|---|---|---|---|---|
| PB-01 Daftar pasien baru | C | | | | | | | R | |
| PB-02 Catat kunjungan | R | R | R | R | C | | | R | |
| PB-03 Periksa dan diagnosa | R | R | | | R, U | | | | |
| PB-04 Resepkan obat | | | | | R | R | C | | |
| PB-05 Terima pembayaran | | | | | R | | R | R | C |
| PB-06 Serahkan obat | | | | | | R, U | R | R | |
| PB-07 Kelola jadwal | | R | R | C, R, U, D | | | | | |
| PB-08 Kelola data master | | C, R, U | C, R, U | | | C, R, U | | C, R, U | |
| PB-09 Perbarui data pasien | R, U | | | | | | | | |
| PB-10 Laporan bulanan | R | R | R | | R | R | R | | R |

Semua entitas memiliki minimal satu huruf C. Huruf D hanya dipakai pada Jadwal praktik; entitas lain tidak dihapus tetapi dinonaktifkan (AB-12).

## 8. Kamus data awal

| Entitas | Elemen | Arti | Contoh | Aturan | Penanggung jawab |
|---|---|---|---|---|---|
| Pasien | no_rekam_medis | Nomor rekam medis pasien | RM-00123 | Unik, format RM- dan 5 digit | Petugas pendaftaran |
| Pasien | nama_pasien | Nama lengkap pasien | Siti Rahmawati | Wajib diisi | Petugas pendaftaran |
| Pasien | jenis_kelamin | Jenis kelamin pasien | Perempuan | Laki-laki atau Perempuan | Petugas pendaftaran |
| Pasien | tanggal_lahir | Tanggal lahir pasien | 1995-03-12 | Tidak boleh di masa depan; usia dihitung dari sini | Petugas pendaftaran |
| Pasien | alamat_pasien | Alamat tinggal pasien | Jl. Melati No. 5, Terbanggi Besar | Data pribadi, akses terbatas | Petugas pendaftaran |
| Pasien | no_hp_pasien | Nomor HP pasien | 0812-0000-0001 | Data pribadi, akses terbatas | Petugas pendaftaran |
| Dokter | kode_dokter | Kode dokter | DR-01 | Unik | Admin klinik |
| Dokter | nama_dokter | Nama dokter | dr. Budi Santoso | Wajib diisi; disimpan sekali | Admin klinik |
| Dokter | status_aktif_dokter | Dokter masih praktik atau tidak | Aktif | Aktif atau Nonaktif (AB-12) | Admin klinik |
| Poli | kode_poli | Kode poli | PL-01 | Unik | Admin klinik |
| Poli | nama_poli | Nama poli | Poli Umum | Wajib diisi | Admin klinik |
| Poli | tarif_konsultasi | Tarif konsultasi saat ini | 50000 | Bilangan bulat >= 0 (rupiah) | Admin klinik |
| Jadwal praktik | hari_praktik | Hari dokter praktik | Senin | Senin sampai Sabtu | Admin klinik |
| Jadwal praktik | jam_mulai_sesi | Jam mulai sesi praktik | 07.00 | Salah satu dari 07.00, 15.30, 20.00 | Admin klinik |
| Kunjungan | no_kunjungan | Nomor kunjungan | KJ-0007 | Unik, format KJ-xxxx | Petugas pendaftaran |
| Kunjungan | tanggal_kunjungan | Tanggal kunjungan | 2026-10-14 | Tidak boleh di masa depan | Petugas pendaftaran |
| Kunjungan | poli_saat_kunjungan | Poli dokter saat kunjungan | Poli Umum | Tidak berubah (AB-04) | Petugas pendaftaran |
| Kunjungan | keluhan | Keluhan pasien | Demam 3 hari, batuk, pusing | Data kesehatan, hanya dokter (AB-10) | Dokter |
| Kunjungan | diagnosa | Diagnosa dokter | ISPA | Data kesehatan, hanya dokter (AB-10) | Dokter |
| Kunjungan | biaya_konsultasi | Tarif konsultasi saat kunjungan | 50000 | Bilangan bulat >= 0, tidak berubah (AB-06) | Kasir |
| Obat | kode_obat | Kode obat | OB-001 | Unik | Petugas obat |
| Obat | nama_obat | Nama obat | Paracetamol | Wajib diisi, ejaan seragam | Petugas obat |
| Obat | kekuatan_obat | Kekuatan sediaan | 500 mg | Wajib diisi | Petugas obat |
| Obat | satuan_obat | Satuan sediaan | tablet | Tablet, kapsul, dan seterusnya | Petugas obat |
| Obat | harga_satuan_obat | Harga satuan saat ini | 500 | Bilangan bulat >= 0 (rupiah) | Admin klinik |
| Obat | stok_obat | Jumlah obat tersedia | 120 | Bilangan bulat >= 0 (AB-07) | Petugas obat |
| Obat | stok_minimum_obat | Batas minimum stok | 20 | Bilangan bulat >= 0 | Petugas obat |
| Detail resep | aturan_pakai | Aturan pakai obat | 3x1 | Data kesehatan, hanya dokter (AB-10) | Dokter |
| Detail resep | jumlah_obat | Jumlah obat diresepkan | 10 | Bilangan bulat > 0, paling banyak 9 jenis per kunjungan (AB-05) | Dokter |
| Detail resep | harga_satuan_saat_kunjungan | Harga satuan saat resep dibuat | 500 | Bilangan bulat >= 0, tidak berubah (AB-06) | Dokter |
| Petugas | kode_petugas | Kode petugas | PT-01 | Unik | Admin klinik |
| Petugas | nama_petugas | Nama petugas | Adil | Wajib diisi | Admin klinik |
| Petugas | peran_petugas | Peran petugas | Petugas pendaftaran | Pendaftaran, obat, kasir, atau admin | Admin klinik |
| Pembayaran | no_kuitansi | Nomor kuitansi | KW-2610-0007 | Unik per pembayaran (AB-11) | Kasir |
| Pembayaran | tanggal_jam_bayar | Waktu pembayaran | 2026-10-14 08:45 | Setelah pemeriksaan selesai | Kasir |
| Pembayaran | jumlah_dibayar | Jumlah yang dibayar pasien | 87500 | Sama dengan total biaya (AB-08, AB-11) | Kasir |

## 9. Kebutuhan non-fungsional data

**Perhitungan parameter personal (P).** NIM 25430042, dua digit terakhir 42. 42 mod 9 = 6, sehingga P = 6 + 1 = **7**.

| Parameter | Rumus | Hasil | Dipakai pada |
|---|---|---|---|
| Batas maksimal item per transaksi | P + 2 | 9 | AB-05 (obat per kunjungan) |
| Persentase diskon | P | 7% | AB-09 (kontrol ulang dalam 7 hari) |
| Perkiraan volume transaksi harian | 40 + 5 x P | 75 kunjungan per hari | Volume di bawah |

**Volume.** Sekitar 75 kunjungan per hari dalam tiga sesi praktik, setara sekitar 27.000 kunjungan per tahun. Tiap kunjungan memuat paling banyak 9 baris resep.

**Retensi.** Data kunjungan, resep, dan pembayaran disimpan minimal 5 tahun dan tidak dihapus (AB-12). Lama retensi ini adalah keputusan rancangan fiktif klinik dan perlu disesuaikan dengan ketentuan yang berlaku.

**Data pribadi dan hak akses.** Identitas pasien (nama, tanggal lahir, alamat, nomor HP) adalah data pribadi, dan keluhan, diagnosa, serta resep adalah data kesehatan yang bersifat spesifik. Pembatasan ini sejalan dengan kewajiban pengendali data dalam Undang-Undang Pelindungan Data Pribadi.

| Peran | Boleh melihat | Tidak boleh melihat |
|---|---|---|
| Petugas pendaftaran | Identitas pasien, jadwal, data kunjungan non-klinis | Keluhan, diagnosa, resep |
| Dokter | Data klinis pasien yang ditangani | Data pembayaran rinci |
| Petugas obat | Nama obat dan jumlah pada resep, stok | Diagnosa dan keluhan |
| Kasir | Rincian biaya dan kuitansi | Keluhan dan diagnosa |
| Admin klinik | Data master dan laporan agregat | Data klinis perorangan |

**Ketersediaan.** Data harus dapat diakses selama jam praktik, yaitu tiga sesi per hari mulai pukul 07.00, 15.30, dan 20.00.

## 10. Isu kualitas data yang diantisipasi

| No | Isu | Contoh | Dampak | Antisipasi | Penanggung jawab |
|---|---|---|---|---|---|
| 1 | Data pasien ganda atau berbeda antarlembar | Pasien yang sama tercatat dengan alamat berbeda | Riwayat berobat terpecah | Data pasien disimpan sekali dan dirujuk lewat nomor rekam medis (AB-02) | Petugas pendaftaran |
| 2 | Pasien tertukar karena nama sama | Dua pasien bernama sama | Riwayat tercampur | Pencarian lewat nomor rekam medis atau nama beserta tanggal lahir | Petugas pendaftaran |
| 3 | Resep tidak terstruktur | Banyak obat dalam satu kolom | Sulit dihitung dan dilaporkan | Satu baris per obat (AB-05) | Dokter |
| 4 | Harga historis hilang | Harga obat naik, kunjungan lama berubah total | Total tidak cocok dengan kuitansi | Harga disimpan per baris resep (AB-06) | Admin klinik |
| 5 | Stok obat negatif atau salah | Obat diserahkan melebihi stok | Stok tidak akurat | Stok tidak boleh negatif (AB-07) | Petugas obat |
| 6 | Salah hitung total | Total dihitung manual | Pembayaran tidak sesuai | Total dihitung otomatis (AB-08) | Kasir |
| 7 | Penulisan nama obat atau diagnosa tidak seragam | "Paracetamol" dan "Parasetamol" | Laporan obat terlaris tidak akurat | Nama obat memakai daftar obat resmi klinik; seragamkan ejaan diagnosa | Dokter |
| 8 | Kebocoran data kesehatan | Lembar kertas dilihat pihak tidak berwenang | Pelanggaran privasi pasien | Pembatasan akses per peran (AB-10, bagian 9) | Admin klinik |
