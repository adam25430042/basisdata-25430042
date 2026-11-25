-- p05_ddl_kopma_25430042.sql
-- DDL Kopma (kopma_042). Dapat dijalankan ulang dari basis data kosong.
USE kopma_042;

DROP TABLE IF EXISTS detail_pembelian;
DROP TABLE IF EXISTS detail_penjualan;
DROP TABLE IF EXISTS pembelian;
DROP TABLE IF EXISTS penjualan;
DROP TABLE IF EXISTS pemasok;
DROP TABLE IF EXISTS barang;
DROP TABLE IF EXISTS anggota;
DROP TABLE IF EXISTS petugas;

CREATE TABLE petugas (
  id_petugas    SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_petugas  CHAR(3) NOT NULL,
  nama_petugas  VARCHAR(100) NOT NULL,
  peran_petugas ENUM('kasir','gudang','ketua') NOT NULL,
  PRIMARY KEY (id_petugas),
  UNIQUE KEY uq_petugas_kode (kode_petugas)
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_anggota         CHAR(6) NOT NULL,
  nim_anggota        CHAR(10) NOT NULL,
  nama_anggota       VARCHAR(100) NOT NULL,
  prodi_anggota      VARCHAR(60) NOT NULL,
  no_hp_anggota      VARCHAR(15) NULL,
  status_anggota     ENUM('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE NOT NULL,
  PRIMARY KEY (id_anggota),
  -- AB-05: nomor anggota dan NIM anggota masing-masing unik
  UNIQUE KEY uq_anggota_no (no_anggota),
  UNIQUE KEY uq_anggota_nim (nim_anggota)
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang         INT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_barang       VARCHAR(10) NOT NULL,
  nama_barang       VARCHAR(100) NOT NULL,
  kategori_barang   ENUM('ATK','makanan','minuman') NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang       INT NOT NULL DEFAULT 0,
  stok_min_barang   INT NOT NULL DEFAULT 5,
  PRIMARY KEY (id_barang),
  UNIQUE KEY uq_barang_kode (kode_barang),
  -- AB-03: stok barang tidak boleh negatif
  CONSTRAINT ck_barang_stok CHECK (stok_barang >= 0),
  -- AB-04: harga jual barang tidak negatif (kamus data)
  CONSTRAINT ck_barang_harga CHECK (harga_jual_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
  kode_pemasok    VARCHAR(10) NOT NULL,
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(15) NULL,
  alamat_pemasok  VARCHAR(200) NULL,
  PRIMARY KEY (id_pemasok),
  UNIQUE KEY uq_pemasok_kode (kode_pemasok)
) ENGINE=InnoDB;

CREATE TABLE penjualan (
  id_penjualan            INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_nota_penjualan       CHAR(12) NOT NULL,
  tgl_penjualan           DATETIME NOT NULL,
  id_petugas              SMALLINT UNSIGNED NOT NULL,
  id_anggota              INT UNSIGNED NULL,
  bayar_penjualan         DECIMAL(12,2) NOT NULL,
  persen_diskon_penjualan TINYINT NOT NULL DEFAULT 0,
  poin_didapat            SMALLINT NOT NULL DEFAULT 0,
  poin_ditukar            SMALLINT NOT NULL DEFAULT 0,
  PRIMARY KEY (id_penjualan),
  -- AB-01: nomor nota unik
  UNIQUE KEY uq_penjualan_nota (no_nota_penjualan),
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas),
  -- AB-02: anggota boleh kosong (pembeli umum)
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota (id_anggota),
  -- AB-13: persentase diskon per nota, 0 sampai 100
  CONSTRAINT ck_penjualan_diskon CHECK (persen_diskon_penjualan BETWEEN 0 AND 100),
  -- AB-07: poin didapat tidak negatif
  CONSTRAINT ck_penjualan_didapat CHECK (poin_didapat >= 0),
  -- AB-08: poin ditukar hanya kelipatan 50
  CONSTRAINT ck_penjualan_ditukar CHECK (poin_ditukar >= 0 AND poin_ditukar % 50 = 0)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan                  INT UNSIGNED NOT NULL,
  id_barang                     INT UNSIGNED NOT NULL,
  qty_detail_penjualan          SMALLINT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan, id_barang),
  -- AB-01: rincian ikut terhapus bila nota dibatalkan
  CONSTRAINT fk_detail_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan (id_penjualan) ON DELETE CASCADE,
  CONSTRAINT fk_detail_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),
  -- AB-01: setiap baris nota berisi jumlah barang yang positif
  CONSTRAINT ck_detail_qty CHECK (qty_detail_penjualan > 0),
  -- AB-04: harga pada nota disimpan per baris dan tidak negatif
  CONSTRAINT ck_detail_harga CHECK (harga_satuan_detail_penjualan >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian        INT UNSIGNED NOT NULL AUTO_INCREMENT,
  no_faktur_pembelian VARCHAR(20) NOT NULL,
  tgl_pembelian       DATE NOT NULL,
  -- AB-06: alur pengadaan dipesan lalu diterima
  status_pembelian    ENUM('dipesan','diterima') NOT NULL DEFAULT 'dipesan',
  id_pemasok          SMALLINT UNSIGNED NOT NULL,
  id_petugas          SMALLINT UNSIGNED NOT NULL,
  PRIMARY KEY (id_pembelian),
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok)
    REFERENCES pemasok (id_pemasok),
  -- AB-12: setiap pembelian dicatat satu petugas
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas (id_petugas)
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian                INT UNSIGNED NOT NULL,
  id_barang                   INT UNSIGNED NOT NULL,
  qty_detail_pembelian        INT NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_dbeli_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian (id_pembelian) ON DELETE CASCADE,
  CONSTRAINT fk_dbeli_barang FOREIGN KEY (id_barang)
    REFERENCES barang (id_barang),
  -- AB-06: jumlah barang yang dipesan positif
  CONSTRAINT ck_dbeli_qty CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_dbeli_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;

-- Belum dapat dijaga constraint (melibatkan banyak baris atau tabel),
-- ditandai untuk Modul 14: AB-01 (minimal satu baris barang per nota),
-- AB-02 dan AB-09 (hanya anggota aktif memperoleh diskon dan poin),
-- AB-03 (penjualan ditolak bila qty melebihi stok), AB-06 (pesan
-- otomatis bila stok di bawah batas minimum), AB-10 (poin ditukar
-- tidak melebihi saldo).