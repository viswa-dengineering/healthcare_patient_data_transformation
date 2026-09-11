-- 02_profile_patient_raw.sql
-- Purpose: Profile Bronze before applying any transformation.

-- 1. Inspect sample records
SELECT *
FROM bronze.patient_raw
LIMIT 5;

-- 2. Total row count
SELECT COUNT(*) AS total_rows
FROM bronze.patient_raw;

-- 3. Column completeness
SELECT
    COUNT(*) AS total_rows,
    COUNT(patient_id) AS patient_id_count,
    COUNT(patient_name) AS patient_name_count,
    COUNT(gender) AS gender_count,
    COUNT(date_of_birth) AS dob_count,
    COUNT(phone) AS phone_count,
    COUNT(email) AS email_count,
    COUNT(city) AS city_count,
    COUNT(patient_status) AS status_count,
    COUNT(registration_date) AS registration_count,
    COUNT(updated_at) AS updated_count
FROM bronze.patient_raw;

-- 4. NULL checks
SELECT *
FROM bronze.patient_raw
WHERE patient_name IS NULL;

SELECT *
FROM bronze.patient_raw
WHERE email IS NULL;

SELECT *
FROM bronze.patient_raw
WHERE patient_id IS NULL;

-- 5. Distinct-value profiling
SELECT DISTINCT gender
FROM bronze.patient_raw
ORDER BY gender;

SELECT DISTINCT city
FROM bronze.patient_raw
ORDER BY city;

SELECT DISTINCT patient_status
FROM bronze.patient_raw
ORDER BY patient_status;

-- 6. Duplicate business-key profiling
SELECT
    patient_id,
    COUNT(*) AS occurrence_count
FROM bronze.patient_raw
GROUP BY patient_id
HAVING COUNT(*) > 1
ORDER BY occurrence_count DESC, patient_id;

-- 7. Whitespace profiling
SELECT *
FROM bronze.patient_raw
WHERE patient_name <> TRIM(patient_name);

SELECT *
FROM bronze.patient_raw
WHERE city <> TRIM(city);

SELECT *
FROM bronze.patient_raw
WHERE email <> TRIM(email);

-- 8. Email-format profiling
SELECT patient_id, email
FROM bronze.patient_raw
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%';

-- 9. Phone-length profiling
SELECT patient_id, phone
FROM bronze.patient_raw
WHERE phone IS NOT NULL
  AND LENGTH(phone) <> 10;

-- 10. Date-of-birth format profiling
SELECT patient_id, date_of_birth
FROM bronze.patient_raw
WHERE date_of_birth IS NULL
   OR TRIM(date_of_birth) = ''
   OR date_of_birth !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- 11. Registration-date format profiling
SELECT patient_id, registration_date
FROM bronze.patient_raw
WHERE registration_date IS NULL
   OR TRIM(registration_date) = ''
   OR registration_date !~ '^[0-9]{4}-[0-9]{2}-[0-9]{2}$';

-- 12. Gender domain profiling
SELECT DISTINCT gender
FROM bronze.patient_raw
WHERE UPPER(TRIM(gender)) NOT IN
      ('M', 'MALE', 'F', 'FEMALE');
