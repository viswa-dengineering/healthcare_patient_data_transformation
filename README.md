# Healthcare Patient Data Quality & Bronze → Silver Transformation

A PostgreSQL Data Engineering project demonstrating how raw healthcare patient data can be profiled, cleaned, standardized, deduplicated, type-converted, and loaded into a trusted Silver layer.

> **Scope:** Bronze → Silver only. Gold/star-schema modeling is intentionally excluded from this stage.

## 1. Project Objective

The source system provides patient records as messy text data. The Data Engineer must:

1. Preserve the source data in Bronze.
2. Profile the Bronze data before modifying anything.
3. Identify data-quality problems.
4. Define treatment rules.
5. Apply repeatable SQL transformations.
6. Deduplicate patient records using the latest `updated_at`.
7. Convert valid date strings to PostgreSQL `DATE`.
8. Standardize text values.
9. Load the trusted result into `silver.patient`.
10. Validate the Silver output.

## 2. Architecture

```text
Source CSV / Source System
          |
          v
+-----------------------+
| bronze.patient_raw    |
| Raw / immutable data  |
+-----------+-----------+
            |
            | Profile
            v
+-----------------------+
| Data Quality Findings |
+-----------+-----------+
            |
            | SQL cleaning + transformation
            v
+-----------------------+
| silver.patient        |
| Trusted standardized  |
| patient entity        |
+-----------------------+
```

## 3. Dataset

The project uses 60 intentionally messy patient records.

The dataset contains examples of:

- Leading/trailing spaces
- Mixed casing
- Gender abbreviations
- Duplicate patient records
- Missing values
- Invalid email
- Invalid phone length
- Invalid date strings
- Inconsistent city values
- Inconsistent patient status values

## 4. Table Grain

### Bronze

`bronze.patient_raw`

**Grain:** one source patient record/version.

Because the source can contain repeated versions of a patient, `patient_id` is not guaranteed to be unique in Bronze.

### Silver

`silver.patient`

**Target grain:** one latest trusted record per `patient_id`.

## 5. Transformation Rules

| Source Problem | Rule |
|---|---|
| Whitespace | Remove leading/trailing spaces |
| Email casing | Convert to lowercase |
| City casing | Convert to uppercase |
| Status casing | Convert to uppercase |
| Gender values | Map M/MALE → MALE and F/FEMALE → FEMALE |
| Invalid gender | UNKNOWN |
| Valid DOB format | Cast to DATE |
| Invalid DOB format | NULL |
| Valid registration date | Cast to DATE |
| Invalid registration date | NULL |
| Duplicate patient | Keep latest `updated_at` |

### Important engineering principle

Not every anomaly should automatically be changed.

The workflow is:

```text
Profile
   ↓
Identify anomaly
   ↓
Check business/data-quality rule
   ↓
FIX / REJECT / QUARANTINE / KEEP
   ↓
Transform
   ↓
Validate
```

## 6. SQL Concepts Demonstrated

### Profiling

- `SELECT`
- `COUNT`
- `DISTINCT`
- `WHERE`
- `IS NULL`
- `GROUP BY`
- `HAVING`
- `LENGTH`

### Cleaning

- `TRIM`
- `LOWER`
- `UPPER`
- `CASE`
- `COALESCE` conceptually where business rules permit

### Validation and type conversion

- PostgreSQL regex operator `~`
- `::DATE`
- `::TIMESTAMP`

### Deduplication

- `ROW_NUMBER()`
- `OVER`
- `PARTITION BY`
- `ORDER BY`

### Transformation organization

- CTEs using `WITH`

## 7. Why CTEs Are Used

The Silver transformation is split into logical steps:

```text
ranked
  ↓
cleaned
  ↓
rn = 1
  ↓
silver.patient
```

`ranked` identifies the latest record for each patient.

`cleaned` applies standardization and type conversion.

The final step keeps `rn = 1`.

A CTE is a temporary named result used within the SQL statement; it does not create a permanent table.

## 8. Project Execution Order

Run the files in this order:

```text
01_bronze_patient_raw.sql
        ↓
00_load_patient_dataset.sql
        ↓
02_profile_patient_raw.sql
        ↓
03_bronze_to_silver_patient.sql
        ↓
04_validate_silver_patient.sql
```

If you prefer, rename the dataset loader as `01_load_patient_dataset.sql` and shift the numbering.

## 9. Expected Engineering Workflow

Do not start by writing the final transformation.

Use:

```text
UNDERSTAND
    ↓
PROFILE
    ↓
IDENTIFY
    ↓
DEFINE RULE
    ↓
TRANSFORM
    ↓
LOAD
    ↓
VALIDATE
```

### Example

Problem:

```text
' Ravi Kumar '
```

Evidence:

```sql
patient_name <> TRIM(patient_name)
```

Rule:

> Patient names should not have surrounding whitespace.

Treatment:

> FIX

Implementation:

```sql
TRIM(patient_name)
```

Validation:

```sql
SELECT *
FROM silver.patient
WHERE patient_name <> TRIM(patient_name);
```

Expected result:

> No rows.

## 10. Bronze vs Silver

### Bronze

- Preserve source representation.
- Do not overwrite raw records merely because they are dirty.
- Use Bronze as the audit/reference layer.

### Silver

- Trusted representation.
- Consistent formats.
- Appropriate data types.
- Duplicate handling.
- Data-quality rules applied.
- Ready for downstream integration and modeling.

## 11. What This Project Does NOT Do

This project intentionally does not yet implement:

- Gold layer
- Fact tables
- Dimension tables
- Star schema
- BI dashboards
- Business KPI modeling

Those belong to the next stage:

```text
SILVER
   ↓
Business requirement
   ↓
Business process
   ↓
Grain
   ↓
Facts + Dimensions
   ↓
GOLD STAR SCHEMA
```

## 12. Portfolio Learning Outcome

After completing this project, you should be able to explain:

> "I received raw patient data in a Bronze layer. I profiled the data to identify nulls, duplicates, inconsistent categorical values, invalid formats, and whitespace issues. I defined treatment rules based on the expected data contract, then used PostgreSQL transformations such as TRIM, CASE, regex validation, type casting, and ROW_NUMBER to create a trusted Silver patient entity. Finally, I validated the Silver layer with independent data-quality checks."

## 13. Future Extension

The next project stage can add:

```text
silver.patient
silver.doctor
silver.department
silver.appointment
silver.treatment
silver.billing
        ↓
Business requirements
        ↓
Data modeling
        ↓
Gold fact/dimension tables
        ↓
Star schema
```
