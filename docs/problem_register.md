# Data Quality Problem Register

| Problem | Evidence | Treatment | SQL Pattern |
|---|---|---|---|
| Leading/trailing whitespace | `column <> TRIM(column)` | FIX | `TRIM()` |
| Gender representation differs | `M`, `Male`, `male`, `F`, `Female` | STANDARDIZE | `UPPER()` + `CASE` |
| City representation differs | `Chennai`, `chennai`, `Chennai ` | STANDARDIZE | `UPPER(TRIM())` |
| Status representation differs | `Active`, `active`, `ACTIVE` | STANDARDIZE | `UPPER(TRIM())` |
| Duplicate patient IDs | `GROUP BY patient_id HAVING COUNT(*) > 1` | KEEP LATEST | `ROW_NUMBER()` |
| Invalid email | value does not contain `@` | QUARANTINE/REJECT per rule | `WHERE` / validation |
| Invalid phone | length is not 10 | QUARANTINE/REJECT per rule | `LENGTH()` |
| Invalid DOB | fails `YYYY-MM-DD` format | Convert to NULL or quarantine | Regex + `::DATE` |
| Invalid registration date | fails `YYYY-MM-DD` format | Convert to NULL or quarantine | Regex + `::DATE` |
| Invalid gender code | value outside approved domain | UNKNOWN or quarantine | `CASE` |
| Missing patient name | NULL | Business decision required | `IS NULL` |
| Missing email | NULL | Business decision required | `IS NULL` |
