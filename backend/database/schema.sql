-- Database Schema for Islamic Note App
-- Run this file to create the database tables

-- Drop table if exists (for fresh start)
DROP TABLE IF EXISTS doa CASCADE;

-- Create doa table
CREATE TABLE doa (
    id SERIAL PRIMARY KEY,
    label VARCHAR(100) NOT NULL UNIQUE,
    judul VARCHAR(255) NOT NULL,
    arab TEXT NOT NULL,
    latin TEXT NOT NULL,
    arti TEXT NOT NULL,
    keywords TEXT[] DEFAULT '{}',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create index for better search performance
CREATE INDEX idx_doa_judul ON doa(judul);
CREATE INDEX idx_doa_keywords ON doa USING GIN(keywords);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger for auto-update updated_at
CREATE TRIGGER update_doa_updated_at
    BEFORE UPDATE ON doa
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
