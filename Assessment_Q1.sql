-- Q1: High-Value Customers with Multiple Products
-- Objective: Identify customers who have at least one funded savings plan 
-- and one funded investment plan, sorted by total deposits.

WITH savings_plans AS (
    SELECT owner_id, COUNT(*) AS savings_count
    FROM plans_plan
    WHERE is_regular_savings = 1
    GROUP BY owner_id
),
investment_plans AS (
    SELECT owner_id, COUNT(*) AS investment_count
    FROM plans_plan
    WHERE is_a_fund = 1
    GROUP BY owner_id
),
total_deposits AS (
    SELECT owner_id, SUM(confirmed_amount) / 100 AS total_deposits
    FROM savings_savingsaccount
    GROUP BY owner_id
)

SELECT 
    u.id AS owner_id,
    -- Handle both NULL and empty strings in name field
    COALESCE(NULLIF(TRIM(CONCAT(u.first_name, ' ', u.last_name)), ''),
    sp.savings_count,
    ip.investment_count,
    td.total_deposits
FROM users_customuser u
JOIN savings_plans sp ON u.id = sp.owner_id
JOIN investment_plans ip ON u.id = ip.owner_id
JOIN total_deposits td ON u.id = td.owner_id
ORDER BY td.total_deposits DESC;
