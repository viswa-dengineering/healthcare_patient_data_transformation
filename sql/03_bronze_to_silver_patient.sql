-- 03_bronze_to_silver_patient.sql
-- Purpose: Deduplicate, clean, standardize, type-convert and load trusted patient data.

CREATE SCHEMA IF NOT EXISTS silver;

DROP TABLE IF EXISTS silver.patient;

CREATE TABLE silver.patient (
    patient_id        TEXT,
    patient_name      TEXT,
    gender            TEXT,
    date_of_birth     DATE,
    phone             TEXT,
    email             TEXT,
    city              TEXT,
    patient_status    TEXT,
    registration_date DATE,
    updated_at        TIMESTAMP
);

WITH ranked AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY patient_id
            ORDER BY updated_at::TIMESTAMP DESC
        ) AS rn
    FROM bronze.patient_raw
),

cleaned AS (
    SELECT
        TRIM(patient_id) AS patient_id,
        TRIM(patient_name) AS patient_name,

        CASE
            WHEN UPPER(TRIM(gender)) IN ('M', 'MALE')
                THEN 'MALE'
            WHEN UPPER(TRIM(gender)) IN ('F', 'FEMALE')
                THEN 'FEMALE'
            ELSE 'UNKNOWN'
        END AS gender,

        CASE
            WHEN date_of_birth ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN date_of_birth::DATE
            ELSE NULL
        END AS date_of_birth,

        TRIM(phone) AS phone,
        LOWER(TRIM(email)) AS email,
        UPPER(TRIM(city)) AS city,
        UPPER(TRIM(patient_status)) AS patient_status,

        CASE
            WHEN registration_date ~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$'
                THEN registration_date::DATE
            ELSE NULL
        END AS registration_date,

        updated_at::TIMESTAMP AS updated_at,
        rn

    FROM ranked
)

INSERT INTO silver.patient (
    patient_id,
    patient_name,
    gender,
    date_of_birth,
    phone,
    email,
    city,
    patient_status,
    registration_date,
    updated_at
)
SELECT
    patient_id,
    patient_name,
    gender,
    date_of_birth,
    phone,
    email,
    city,
    patient_status,
    registration_date,
    updated_at
FROM cleaned
WHERE rn = 1;
