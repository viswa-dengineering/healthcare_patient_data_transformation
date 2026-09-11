# Profiling Notes / Learning Log

Use this file to record your own observations rather than copying a pre-written answer.

## 1. Dataset understanding

- What does the table represent?
- What does one row represent?
- What is the business key?
- Can the business key repeat in Bronze?
- Which column tells us which version is newest?

## 2. Profile findings

Record your query result:

| Check | Finding | Evidence Query | Decision |
|---|---|---|---|
| Row count |  |  |  |
| NULLs |  |  |  |
| Duplicates |  |  |  |
| Whitespace |  |  |  |
| Gender domain |  |  |  |
| City domain |  |  |  |
| Status domain |  |  |  |
| Email |  |  |  |
| Phone |  |  |  |
| DOB |  |  |  |
| Registration date |  |  |  |

## 3. Personal explanation

Explain the project without reading the README:

> Bronze is ______________________________

> Profiling is ____________________________

> Cleaning is _____________________________

> Transformation is _______________________

> Silver is _______________________________

> `ROW_NUMBER()` is used because __________

> `PARTITION BY patient_id` means __________

> `rn = 1` means __________________________

## 4. Validation

Write down what should be true after Silver is built.

Example:

- Patient IDs should be unique.
- Gender should contain only approved standardized values.
- City should be standardized.
- Dates should have DATE data types.
