-- 04_validate_silver_patient.sql
-- Purpose: Prove that the Silver transformation produced trusted data.

-- 1. Row count
SELECT COUNT(*) AS silver_rows
FROM silver.patient;

-- 2. NULL patient IDs should not exist
SELECT *
FROM silver.patient
WHERE patient_id IS NULL;

-- 3. Duplicate patient IDs should not exist
SELECT
    patient_id,
    COUNT(*) AS occurrence_count
FROM silver.patient
GROUP BY patient_id
HAVING COUNT(*) > 1;

-- 4. Standardized gender values
SELECT DISTINCT gender
FROM silver.patient
ORDER BY gender;

-- 5. Standardized cities
SELECT DISTINCT city
FROM silver.patient
ORDER BY city;

-- 6. Standardized statuses
SELECT DISTINCT patient_status
FROM silver.patient
ORDER BY patient_status;

-- 7. Check remaining surrounding whitespace
SELECT *
FROM silver.patient
WHERE patient_name <> TRIM(patient_name)
   OR patient_id <> TRIM(patient_id)
   OR phone <> TRIM(phone)
   OR email <> TRIM(email)
   OR city <> TRIM(city)
   OR patient_status <> TRIM(patient_status);

-- 8. Validate email pattern
SELECT patient_id, email
FROM silver.patient
WHERE email IS NOT NULL
  AND email NOT LIKE '%@%';

-- 9. Validate phone length
SELECT patient_id, phone
FROM silver.patient
WHERE phone IS NOT NULL
  AND LENGTH(phone) <> 10;

-- 10. Validate date of birth
SELECT *
FROM silver.patient
WHERE date_of_birth IS NULL;

-- Review NULL DOBs manually against the source/business rule.
-- P060 is expected to have an invalid DOB in the intentionally messy dataset.

-- 11. Validate registration dates
SELECT *
FROM silver.patient
WHERE registration_date IS NULL;

-- 12. Inspect final Silver sample
SELECT *
FROM silver.patient
ORDER BY patient_id
LIMIT 20;
