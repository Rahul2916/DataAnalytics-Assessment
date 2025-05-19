# DataAnalytics-Assessment

This repository documents SQL-based analytical tasks designed to extract insights from a savings and investment platform. It includes schema documentation, per-question explanations, SQL queries, and encountered challenges.

---

## 🗂️ Database Tables

### 1. `users_customuser`
Contains personal and account metadata for each user.

---

### 2. `savings_savingsaccount`
Stores all savings-related transactions.

---

### 3. `plans_plan`
Stores metadata on financial plans.

---

## 📊 Analytical Tasks

---

### ✅ 1. High-Value Customers with Multiple Products

**Objective:** Identify customers with both a funded savings and an investment plan.

**Approach:**
- Join `users_customuser` with `savings_savingsaccount` and `plans_plan`.
- Filter savings where `amount > 0` and investment plans where `is_fixed_investment = 1`.
- Group by user and aggregate transaction count and sum.

**SQL Highlights:**
- Aggregates savings and investment counts and sorts by total deposits.

**Challenge:**
- Needed to determine a consistent flag to distinguish investment plans (`is_fixed_investment` was used).
  
---

### ✅ 2. Transaction Frequency Analysis

**Objective:** Segment customers based on how frequently they transact monthly.

**Approach:**
- Count monthly transactions for each user.
- Calculate average monthly transactions.
- Categorize based on thresholds:
  - High (≥10), Medium (3–9), Low (≤2).
  
**SQL Highlights:**
- Used `DATE_FORMAT` and `AVG()` over grouped data to derive frequency.
- Classified users using `CASE` inside a CTE.

**Challenge:**
- Ensured monthly breakdown without skipping months where users had no activity.
- Used `COALESCE` and defensive joins to prevent nulls from breaking calculations.

---

### ✅ 3. Account Inactivity Alert

**Objective:** Flag active plans (savings/investments) with no inflow in the last 365 days.

**Approach:**
- For savings: use `transaction_date` to find last activity.
- For investment: check associated savings entries (left join) and filter on latest `transaction_date`.
- Filter plans that are active (`is_deleted = 0` and `is_archived = 0`).

**SQL Highlights:**
- Used `DATEDIFF` and `MAX(transaction_date)` to determine inactivity.
- Combined results with `UNION ALL`.

**Challenge:**
- Investment plans with **no transactions ever** returned `NULL` on `MAX(transaction_date)`. This required handling with `HAVING MAX(...) IS NULL OR ...`.

---

### ✅ 4. Customer Lifetime Value (CLV) Estimation

**Objective:** Estimate CLV using transaction count, tenure, and profit-per-transaction.

**Formula:**
***CLV = (total_transactions / tenure_months) * 12 * avg_profit_per_transaction***
- `avg_profit_per_transaction = 0.1% of average confirmed amount` (in Kobo)

***Approach:***
- Calculate tenure from `date_joined`.
- Aggregate inflow (`confirmed_amount`) and count of transactions.
- Estimate profit and scale to yearly projection.

***SQL Highlights:***
- Uses `TIMESTAMPDIFF(MONTH, ...)` for tenure.
- Defensive checks for division by zero (`tenure = 0`).
- Kobo conversion applied using `* 0.001`.

***Challenge:***
- Ensuring `total_confirmed_amount / total_transactions` doesn’t break if count = 0.
- Accounted for inactive users who might not have transactions.

---


