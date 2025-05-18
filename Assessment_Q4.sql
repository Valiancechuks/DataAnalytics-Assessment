-- Q4: Customer Lifetime Value Estimation
-- Goal: Estimate CLV based on transaction value and customer tenure

WITH customer_transactions AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        SUM(confirmed_amount) / 100 AS total_value_naira,
        SUM(confirmed_amount * 0.001) / 100 AS total_profit_naira
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
clv_calculation AS (
    SELECT 
        u.id AS customer_id,
        COALESCE(NULLIF(TRIM(CONCAT(u.first_name, ' ', u.last_name)), ''), 'Unknown') AS name,
        PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) + 1 AS tenure_months,
        ct.total_transactions,
        ROUND((ct.total_transactions / 
               (PERIOD_DIFF(DATE_FORMAT(NOW(), '%Y%m'), DATE_FORMAT(u.date_joined, '%Y%m')) + 1)) * 12 * 
               (ct.total_profit_naira / ct.total_transactions), 2) AS estimated_clv
    FROM users_customuser u
    JOIN customer_transactions ct ON u.id = ct.owner_id
)

SELECT *
FROM clv_calculation
ORDER BY estimated_clv DESC;