-- ==========================================================
-- DDL DATABASE PORTFOBALANCE (8 TABEL RELASIONAL)
-- ==========================================================

-- 1. Tabel Pengguna (Admin & Investor)
CREATE TABLE IF NOT EXISTS users (
    user_id SERIAL PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'INVESTOR' CHECK (role IN ('ADMIN', 'INVESTOR')),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Tabel Kategori Aset
CREATE TABLE IF NOT EXISTS asset_categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) UNIQUE NOT NULL,
    description TEXT
);

-- 3. Tabel Master Instrumen Aset (Dikelola oleh Admin)
CREATE TABLE IF NOT EXISTS master_assets (
    asset_id SERIAL PRIMARY KEY,
    category_id INT NOT NULL REFERENCES asset_categories(category_id) ON DELETE RESTRICT,
    ticker_symbol VARCHAR(20) UNIQUE NOT NULL,
    asset_name VARCHAR(100) NOT NULL,
    currency VARCHAR(10) NOT NULL DEFAULT 'IDR' CHECK (currency IN ('IDR', 'USD')),
    current_price NUMERIC(18, 2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tabel Dompet / Akun Sekuritas
CREATE TABLE IF NOT EXISTS wallets (
    wallet_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    wallet_name VARCHAR(100) NOT NULL,
    platform_type VARCHAR(50) NOT NULL,
    cash_balance_idr NUMERIC(18, 2) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tabel Kepemilikan Aset per Dompet
CREATE TABLE IF NOT EXISTS portfolio_holdings (
    holding_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    wallet_id INT NOT NULL REFERENCES wallets(wallet_id) ON DELETE CASCADE,
    asset_id INT NOT NULL REFERENCES master_assets(asset_id) ON DELETE RESTRICT,
    total_units NUMERIC(18, 6) NOT NULL DEFAULT 0,
    average_buy_price NUMERIC(18, 2) NOT NULL DEFAULT 0,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (wallet_id, asset_id)
);

-- 6. Tabel Riwayat Transaksi Investasi
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    wallet_id INT NOT NULL REFERENCES wallets(wallet_id) ON DELETE CASCADE,
    asset_id INT REFERENCES master_assets(asset_id) ON DELETE RESTRICT,
    transaction_type VARCHAR(20) NOT NULL CHECK (transaction_type IN ('DEPOSIT', 'WITHDRAW', 'BUY', 'SELL', 'DIVIDEND')),
    units NUMERIC(18, 6) NOT NULL DEFAULT 0,
    price_per_unit NUMERIC(18, 2) NOT NULL DEFAULT 0,
    total_amount_idr NUMERIC(18, 2) NOT NULL,
    transaction_date DATE NOT NULL DEFAULT CURRENT_DATE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 7. Tabel Target Alokasi Portofolio (Untuk Hitung Rebalancing)
CREATE TABLE IF NOT EXISTS allocation_targets (
    target_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    category_id INT NOT NULL REFERENCES asset_categories(category_id) ON DELETE CASCADE,
    target_percentage NUMERIC(5, 2) NOT NULL CHECK (target_percentage >= 0 AND target_percentage <= 100),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, category_id)
);

-- 8. Tabel Watchlist Aset
CREATE TABLE IF NOT EXISTS watchlists (
    watchlist_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id) ON DELETE CASCADE,
    asset_id INT NOT NULL REFERENCES master_assets(asset_id) ON DELETE CASCADE,
    target_buy_price NUMERIC(18, 2),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (user_id, asset_id)
);

-- ==========================================================
-- DATA AWAL (SEEDING KATEGORI & INSTRUMEN CONTOH)
-- ==========================================================
INSERT INTO asset_categories (category_name, description) VALUES
('Index ETF Global', 'Instrumen ETF indeks pasar modal global berbasis USD'),
('Reksa Dana Pasar Uang', 'Instrumen pasar uang berisiko rendah untuk likuiditas'),
('Saham Domestik', 'Instrumen saham tercatat di Bursa Efek Indonesia'),
('Logam Mulia', 'Instrumen lindung nilai berbasis emas')
ON CONFLICT (category_name) DO NOTHING;

INSERT INTO master_assets (category_id, ticker_symbol, asset_name, currency, current_price) VALUES
(1, 'SPUS', 'SP Funds S&P 500 Sharia Industry Exclusions ETF', 'USD', 42.50),
(2, 'RDPU', 'Reksa Dana Pasar Uang Syariah', 'IDR', 1520.00),
(3, 'BBCA', 'Bank Central Asia Tbk.', 'IDR', 10250.00),
(4, 'ANTM', 'Emas Antam Logam Mulia (per gram)', 'IDR', 1540000.00)
ON CONFLICT (ticker_symbol) DO NOTHING;