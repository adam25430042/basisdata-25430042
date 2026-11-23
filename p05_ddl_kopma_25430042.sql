-- p05_ddl_kopma_25430042.sql
-- DDL Kopma (draf). Cocokkan tipe data dengan Modul 5.
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
  id_petugas    INT AUTO_INCREMENT PRIMARY KEY,
  kode_petugas  VARCHAR(10)  NOT NULL UNIQUE,
  nama_petugas  VARCHAR(100) NOT NULL,
  peran_petugas VARCHAR(30)  NOT NULL
) ENGINE=InnoDB;

CREATE TABLE anggota (
  id_anggota         INT AUTO_INCREMENT PRIMARY KEY,
  no_anggota         VARCHAR(10)  NOT NULL UNIQUE,
  nim_anggota        VARCHAR(15)  NOT NULL UNIQUE,
  nama_anggota       VARCHAR(100) NOT NULL,
  prodi_anggota      VARCHAR(50),
  no_hp_anggota      VARCHAR(20),
  status_anggota     VARCHAR(10)  NOT NULL DEFAULT 'aktif',
  tgl_daftar_anggota DATE         NOT NULL,
  CONSTRAINT ck_anggota_status CHECK (status_anggota IN ('aktif','nonaktif'))
) ENGINE=InnoDB;

CREATE TABLE barang (
  id_barang         INT AUTO_INCREMENT PRIMARY KEY,
  kode_barang       VARCHAR(10)   NOT NULL UNIQUE,
  nama_barang       VARCHAR(100)  NOT NULL,
  kategori_barang   VARCHAR(30)   NOT NULL,
  harga_jual_barang DECIMAL(12,2) NOT NULL,
  stok_barang       INT           NOT NULL DEFAULT 0,
  stok_min_barang   INT           NOT NULL DEFAULT 0,
  CONSTRAINT ck_barang_harga   CHECK (harga_jual_barang >= 0),
  CONSTRAINT ck_barang_stok    CHECK (stok_barang >= 0),
  CONSTRAINT ck_barang_stokmin CHECK (stok_min_barang >= 0)
) ENGINE=InnoDB;

CREATE TABLE pemasok (
  id_pemasok      INT AUTO_INCREMENT PRIMARY KEY,
  kode_pemasok    VARCHAR(10)  NOT NULL UNIQUE,
  nama_pemasok    VARCHAR(100) NOT NULL,
  telepon_pemasok VARCHAR(20),
  alamat_pemasok  VARCHAR(200)
) ENGINE=InnoDB;

CREATE TABLE penjualan (
  id_penjualan            INT AUTO_INCREMENT PRIMARY KEY,
  no_nota_penjualan       VARCHAR(20)   NOT NULL UNIQUE,
  tanggal_jam_penjualan   DATETIME      NOT NULL,
  id_petugas              INT           NOT NULL,
  id_anggota              INT           NULL,
  bayar_penjualan         DECIMAL(12,2) NOT NULL DEFAULT 0,
  persen_diskon_penjualan DECIMAL(5,2)  NOT NULL DEFAULT 0,
  poin_didapat            INT           NOT NULL DEFAULT 0,
  poin_ditukar            INT           NOT NULL DEFAULT 0,
  CONSTRAINT fk_penjualan_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas(id_petugas) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_penjualan_anggota FOREIGN KEY (id_anggota)
    REFERENCES anggota(id_anggota) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_penjualan_bayar  CHECK (bayar_penjualan >= 0),
  CONSTRAINT ck_penjualan_diskon CHECK (persen_diskon_penjualan BETWEEN 0 AND 100),
  CONSTRAINT ck_penjualan_poin   CHECK (poin_didapat >= 0 AND poin_ditukar >= 0)
) ENGINE=InnoDB;

CREATE TABLE detail_penjualan (
  id_penjualan                  INT NOT NULL,
  id_barang                     INT NOT NULL,
  qty_detail_penjualan          INT NOT NULL,
  harga_satuan_detail_penjualan DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_penjualan, id_barang),
  CONSTRAINT fk_dpenjualan_penjualan FOREIGN KEY (id_penjualan)
    REFERENCES penjualan(id_penjualan) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_dpenjualan_barang FOREIGN KEY (id_barang)
    REFERENCES barang(id_barang) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_dpenjualan_qty   CHECK (qty_detail_penjualan > 0),
  CONSTRAINT ck_dpenjualan_harga CHECK (harga_satuan_detail_penjualan >= 0)
) ENGINE=InnoDB;

CREATE TABLE pembelian (
  id_pembelian        INT AUTO_INCREMENT PRIMARY KEY,
  no_faktur_pembelian VARCHAR(30) NOT NULL,
  tgl_pembelian       DATE        NOT NULL,
  status_pembelian    VARCHAR(10) NOT NULL DEFAULT 'dipesan',
  id_pemasok          INT         NOT NULL,
  id_petugas          INT         NOT NULL,
  CONSTRAINT fk_pembelian_pemasok FOREIGN KEY (id_pemasok)
    REFERENCES pemasok(id_pemasok) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_pembelian_petugas FOREIGN KEY (id_petugas)
    REFERENCES petugas(id_petugas) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_pembelian_status CHECK (status_pembelian IN ('dipesan','diterima'))
) ENGINE=InnoDB;

CREATE TABLE detail_pembelian (
  id_pembelian                INT NOT NULL,
  id_barang                   INT NOT NULL,
  qty_detail_pembelian        INT NOT NULL,
  harga_beli_detail_pembelian DECIMAL(12,2) NOT NULL,
  PRIMARY KEY (id_pembelian, id_barang),
  CONSTRAINT fk_dpembelian_pembelian FOREIGN KEY (id_pembelian)
    REFERENCES pembelian(id_pembelian) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_dpembelian_barang FOREIGN KEY (id_barang)
    REFERENCES barang(id_barang) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT ck_dpembelian_qty   CHECK (qty_detail_pembelian > 0),
  CONSTRAINT ck_dpembelian_harga CHECK (harga_beli_detail_pembelian >= 0)
) ENGINE=InnoDB;