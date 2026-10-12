-- p01_lingkungan_25430042.sql
-- Nama: Adam Maulana Firmansyah
-- NIM: 25430042
-- Password sengaja diganti penanda. JANGAN commit password asli.

-- BAGIAN A: Basis data dan akun latihan (Kopma)
CREATE DATABASE IF NOT EXISTS kopma_042
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'mhs_042'@'localhost' IDENTIFIED BY '<password_kerja>';
GRANT ALL PRIVILEGES ON kopma_042.* TO 'mhs_042'@'localhost';

-- Latihan E1: Akun tamu, hanya boleh membaca (SELECT) pada database latihan
CREATE USER IF NOT EXISTS 'tamu_042'@'localhost' IDENTIFIED BY '<password_tamu>';
GRANT SELECT ON kopma_042.* TO 'tamu_042'@'localhost';

-- BAGIAN B: Milestone Proyek 1 (Tema Klinik - Organisasi Bunda Sehat)
CREATE DATABASE IF NOT EXISTS klinik_042
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE USER IF NOT EXISTS 'dev_042'@'localhost' IDENTIFIED BY '<password_proyek>';
GRANT ALL PRIVILEGES ON klinik_042.* TO 'dev_042'@'localhost';