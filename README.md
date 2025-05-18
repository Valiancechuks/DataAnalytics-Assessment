# Data Analytics SQL Assessment

This repository contains my SQL solutions to the SQL proficiency assessment evaluating data retrieval, aggregation, joins, and business problem-solving with SQL. The tasks focus on customer behavior insights, transaction activity analysis, account monitoring, and lifetime value estimation — all done using MySQL. 

Each question is answered in a separate `.sql` file. Queries are written to be accurate, efficient, and well-structured for readability.

---

**Question-by-Question Breakdown**

**Question 1: High-Value Customers with Multiple Products**

Objective:
Identify customers with both a funded savings plan and investment plan, and rank them by total deposits.

Approach:

Used plans_plan to find:

Customers with at least one savings plan (is_regular_savings = 1)

Customers with at least one investment plan (is_a_fund = 1)

I used savings_savingsaccount to compute the total confirmed deposits, converting from kobo to naira by dividing by 100.

Constructed customer names using first_name + last_name, defaulting to 'Unknown' if missing or blank.

Performed join operations

The final output is sorted by total deposits in descending order.



**Question 2: Transaction Frequency Analysis**

Objective:
Categorize customers based on how often they transact each month.

Approach:

Counted total transactions per customer from savings_savingsaccount.

Calculated active months using PERIOD_DIFF between the current date and the customer's first transaction date.

Computed average monthly transaction frequency as:
total_transactions / active_months

Categorized customers as:

High Frequency: ≥ 10/month

Medium Frequency: 3–9/month

Low Frequency: ≤ 2/month

Aggregated the number of customers in each category and calculated their average frequency.



**Question 3: Account Inactivity Alert**

Objective:
Identify savings or investment plans with no deposit transactions in the last 365 days.

Approach:

Filtered plans_plan for active plans:

is_regular_savings = 1 or is_a_fund = 1

Retrieved the most recent deposit date per plan from savings_savingsaccount.

Calculated inactivity using DATEDIFF(CURRENT_DATE, last_transaction_date).

Returned plans with inactivity > 365 days, along with:

Plan ID, Owner ID, Plan Type, Last Transaction Date, Inactivity Duration



**Question 4: Customer Lifetime Value (CLV) Estimation**

Objective:
Estimate each customer's lifetime value using tenure and transaction volume.

**Approach:**

Assumed profit per transaction is 0.1% (i.e., 0.001 × confirmed amount).

**Calculated:**

Tenure: Months since date_joined using PERIOD_DIFF

Total Profit: 0.001 × total confirmed amount (converted from kobo to naira)

CLV = (total_transactions / tenure) × 12 × avg profit per transaction

Used customer ID and constructed full name.

Explained that duplicate names are expected due to real-world data behavior — customers are identified by unique IDs.



**Challenges Encountered**

Challenge	and Solution

Missing or null customer names -	Combined first_name and last_name, defaulted to 'Unknown' for missing/blank rows

Inconsistent date logic	- Used PERIOD_DIFF and DATEDIFF for accurate time calculations

Amounts stored in kobo - Converted all money fields by dividing by 100 to get naira

Duplicate customer names -	Handled by grouping and identifying by id, not name



**Data Observations**

Some customers appear multiple times in users_customuser with:

Same full name

Same phone number

Different IDs and emails

Indicates:

The same person might have registered more than once

No uniqueness constraints on phone numbers

All queries treat each ID as a unique customer, per business rule.



**Assumptions**

Each row in savings_savingsaccount represents a single deposit transaction.

confirmed_amount is stored in kobo (smallest unit).

Savings plans and investment plans are flagged via:

is_regular_savings = 1 (for savings)

is_a_fund = 1 (for investments)

Withdrawals were not included in any calculations.

Customer identity is defined solely by the id column.



**Technologies Used**

SQL Engine: MySQL 8.0


**IDE:** MySQL Workbench

**Functions Used:**
PERIOD_DIFF, DATEDIFF, COALESCE, NULLIF, TRIM, CONCAT, CASE, ROUND



**Data Dictionary**

**users_customuser**

Column Name,	Type and	Description

id - CHAR type,	Unique identifier for each customer

first_name - 	VARCHAR type,	Customer’s first name

last_name	VARCHAR type,	Customer’s last name

date_joined	DATETIME type,	Date and time the customer joined

**plans_plan**

Column Name,	Type and	Description

id - 	CHAR type, Unique identifier for each plan

owner_id -	CHAR type,	Foreign key referencing users_customuser.id

is_regular_savings -	TINYINT type,	Indicates a regular savings plan (1 = yes, 0 = no)

is_a_fund	- TINYINT type,	Indicates an investment fund plan (1 = yes, 0 = no)

**Savings_savingsaccount**

Column Name,	Type, and	Description

id -	INT type,	Unique identifier for each transaction

owner_id -	CHAR type,	Foreign key referencing users_customuser.id

confirmed_amount -	DOUBLE type,	Amount in kobo (divide by 100 to convert to naira)

plan_id	- CHAR type,	Foreign key referencing plans_plan.id

created_on -	DATETIME type,	Timestamp when the transaction was made


**Added Insights and Recommendations**

While working through the questions, I found some ways the data and queries could be improved to help the business get even more value. These recommendations are based on practical insights from analyzing customer behavior, data structure, and usage patterns.

Q1: High-Value Customers with Multiple Products

Show only active plans: Some plans might have been created but never funded. It would be helpful to add a column to show if a plan actually received money.

Include investment value: Only deposits into savings accounts are counted now. If investment plans involve money too, adding that would give a more complete picture of the customer.

Simplify query logic: Combining savings and investment plan counts into one step could make the query easier to manage.

Q2: Transaction Frequency Analysis

Avoid inflated averages: Customers who have just started using the platform might look more active than they are. It helps to ignore very new users or adjust for how long they've been active.

Make categories flexible: Right now, “High”, “Medium”, and “Low” frequencies are fixed. Putting these ranges in a settings table could make it easier to change them in the future.

Look at trends: Tracking transactions over time (like monthly patterns) can show whether users are becoming more or less active.

Q3: Account Inactivity Alert

Catch accounts that were never used: Some accounts may have been created but never received any deposits. These should be included as inactive too.

Add plan creation date: Knowing when the account was opened helps tell whether inactivity is really a problem or just too early to expect usage.

Summarize by user: Instead of just showing inactive plans, it could help to show users who have multiple inactive plans or no recent activity at all.

Q4: Customer Lifetime Value (CLV) Estimation

Use real profit numbers if available: The current estimate assumes the business makes 0.1% on every transaction. If actual rates differ by product, using them would make the CLV more accurate.

Include investment returns: If customers earn or invest money through other products, that should be part of the CLV too.

Break down the CLV formula: Showing parts like average transaction value or monthly profit helps others understand how the CLV was calculated.

Adjust for recent activity: A customer who hasn’t used their account in a long time may not be as valuable going forward. Factoring in recent activity makes the estimate more useful.

General Suggestions

Use naira instead of kobo: All money values are stored in kobo, which requires dividing by 100 in every query. Storing or displaying values in naira would make things easier.

Clean up user data: Some name fields are blank or have extra spaces. Making sure names are clean and complete helps with reports and personalization.

Reuse common calculations: Fields like account age or total deposits are used in many places. It could help to create reusable views or columns for these values.


**Notes**

All queries have been carefully formatted, commented, and written for clarity and correctness.

Business rules were interpreted from schema patterns and field flags.

Results are grouped and filtered based on data integrity, using ID fields as the single source of identity truth.

Added insights and recommendations for richer analysis and deeper customer understanding.
