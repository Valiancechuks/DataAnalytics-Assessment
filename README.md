# Data Analytics SQL Assessment

This repository contains my SQL solutions for a four-part data analytics assessment. The tasks focus on customer behavior insights, transaction activity analysis, account monitoring, and lifetime value estimation — all done using MySQL.

---

## ✅ Question-by-Question Breakdown

### 🔹 Question 1: High-Value Customers with Multiple Products

**Objective:**  
Identify customers who have both a savings plan and an investment plan, and rank them by total deposits.

**Approach:**  
- Used `plans_plan` to find customers with at least one savings plan (`is_regular_savings = 1`) and one investment plan (`is_a_fund = 1`).
- Joined with `savings_savingsaccount` to compute total confirmed deposits, converting from kobo to naira.
- Customer names were constructed using `first_name + last_name` with `COALESCE` to handle nulls or blanks.
- Results sorted by total deposits in descending order.

---

### 🔹 Question 2: Transaction Frequency Analysis

**Objective:**  
Categorize customers based on how often they transact each month.

**Approach:**  
- Counted the number of transactions per customer from `savings_savingsaccount`.
- Calculated active months using the difference between the current date and the customer's first transaction using `PERIOD_DIFF`.
- Divided total transactions by active months to get an average.
- Categorized customers into:
  - High Frequency: ≥10/month
  - Medium Frequency: 3–9/month
  - Low Frequency: ≤2/month
- Aggregated the count of customers in each category and calculated their average monthly frequency.

---

### 🔹 Question 3: Account Inactivity Alert

**Objective:**  
Find savings or investment plans with no deposit transactions in the last 365 days.

**Approach:**  
- Identified active plans using `plans_plan` (`is_regular_savings = 1` or `is_a_fund = 1`).
- Retrieved the most recent transaction date per plan from `savings_savingsaccount`.
- Calculated inactivity days using `DATEDIFF`.
- Filtered to include only accounts where the last transaction was more than 365 days ago.
- Output included plan ID, owner ID, plan type, last transaction date, and inactivity duration.

---

### 🔹 Question 4: Customer Lifetime Value (CLV) Estimation

**Objective:**  
Estimate each customer's lifetime value based on tenure and transaction volume.

**Approach:**  
- Assumed profit per transaction is 0.1% of the transaction value.
- Calculated:
  - Tenure: months since `date_joined` using `PERIOD_DIFF`
  - Total profit = 0.001 × confirmed amount (in kobo → naira)
  - CLV = (total_transactions / tenure) × 12 × avg profit per transaction
- Used customer ID and constructed full name from `first_name + last_name`.

**Note on Duplicate Names:**  
If the same full name appears multiple times in the output, it is because different customers (with different IDs) may share the same name — this is normal and expected. We identify customers by their unique `id`, not name, because names are not guaranteed to be unique in any real-world dataset.

---

## ⚠️ Challenges Encountered

| Challenge                           | Solution                                                                 |
|------------------------------------|--------------------------------------------------------------------------|
| Missing or null customer names     | Replaced by combining `first_name + last_name`, and defaulted to `'Unknown'` |
| Inconsistent date logic            | Used MySQL's `PERIOD_DIFF` and `DATEDIFF` for time-based calculations   |
| Amounts in kobo (not naira)        | Converted all money values by dividing by 100                            |
| Repeated names in CLV results      | Correctly handled by grouping by `id` and explaining that names can repeat |

---

## 🔍 Data Observations

During exploration, I noticed that some customers appeared to have **multiple accounts** in the `users_customuser` table:
- Same full name and **same phone number**
- Different customer IDs
- Different email addresses

This indicates that either:
- The same person registered more than once (possibly for different products)
- Or the system does not enforce uniqueness on phone numbers

In all queries, I followed the business rule of treating each `id` as a unique customer. However, this kind of duplication is common in real-world data and would be addressed in identity resolution models outside the scope of this assessment.

---

## 🧠 Assumptions

- Each row in `savings_savingsaccount` is a separate deposit transaction.
- `confirmed_amount` is stored in **kobo**, not naira.
- `plans_plan` defines a savings plan when `is_regular_savings = 1`, and an investment plan when `is_a_fund = 1`.
- Only deposits were considered; withdrawals were not used in these analyses.

---

## 🛠 Technologies Used

- **SQL Engine:** MySQL 8.0
- **IDE:** MySQL Workbench
- **Functions Used:** `PERIOD_DIFF`, `DATEDIFF`, `COALESCE`, `NULLIF`, `TRIM`, `CONCAT`, `ROUND`

---

## 📌Notes

All queries are optimized for clarity and correctness, with meaningful comments and formatting. Business logic was interpreted carefully based on the provided schema and expected outputs.

