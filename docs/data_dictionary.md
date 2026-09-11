# Patient Raw Data Dictionary

| Column | Raw Type | Meaning | Profiling Concern |
|---|---|---|---|
| patient_id | TEXT | Source patient identifier | NULLs, duplicates, whitespace |
| patient_name | TEXT | Patient name | NULLs, whitespace |
| gender | TEXT | Patient gender representation | Case/abbreviation inconsistency |
| date_of_birth | TEXT | Date of birth supplied by source | Invalid format/type |
| phone | TEXT | Patient contact number | Invalid length |
| email | TEXT | Patient email | Whitespace, case, invalid format |
| city | TEXT | Patient city | Case/whitespace inconsistency |
| patient_status | TEXT | Patient lifecycle/status | Case/whitespace inconsistency |
| registration_date | TEXT | Patient registration date | Invalid format/type |
| updated_at | TEXT | Source record update timestamp | Used for latest-record selection |
