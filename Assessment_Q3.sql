-- Q3: Account Inactivity Alert
-- Goal: Find accounts with no deposits in the last 365 days

WITH last_txn AS (
    SELECT 
        s.plan_id,
        MAX(s.created_on) AS last_transaction_date
    FROM savings_savingsaccount s
    GROUP BY s.plan_id
),
active_plans AS (
    SELECT 
        p.id AS plan_id,
        p.owner_id,
        CASE 
            WHEN p.is_regular_savings = 1 THEN 'Savings'
            WHEN p.is_a_fund = 1 THEN 'Investment'
            ELSE 'Other'
        END AS type
    FROM plans_plan p
    WHERE p.is_regular_savings = 1 OR p.is_a_fund = 1
),
inactive_accounts AS (
    SELECT 
        ap.plan_id,
        ap.owner_id,
        ap.type,
        lt.last_transaction_date,
        DATEDIFF(NOW(), lt.last_transaction_date) AS inactivity_days
    FROM active_plans ap
    LEFT JOIN last_txn lt ON ap.plan_id = lt.plan_id
    WHERE lt.last_transaction_date IS NOT NULL
      AND DATEDIFF(NOW(), lt.last_transaction_date) > 365
)

SELECT *
FROM inactive_accounts
ORDER BY inactivity_days DESC;