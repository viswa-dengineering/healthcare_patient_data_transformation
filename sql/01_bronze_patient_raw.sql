-- 01_bronze_patient_raw.sql
-- Healthcare Patient Data Engineering Project
-- Purpose: Create an immutable raw/Bronze table and load source-like data.

CREATE SCHEMA IF NOT EXISTS bronze;

DROP TABLE IF EXISTS bronze.patient_raw;

CREATE TABLE bronze.patient_raw (
    patient_id        TEXT,
    patient_name      TEXT,
    gender            TEXT,
    date_of_birth     TEXT,
    phone             TEXT,
    email             TEXT,
    city              TEXT,
    patient_status    TEXT,
    registration_date TEXT,
    updated_at        TEXT
);

-- Load the 60 source records used in this project.
-- Paste/run the INSERT statement from the project dataset section here.
