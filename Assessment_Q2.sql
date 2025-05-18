-- Q2: Transaction Frequency Analysis
-- Goal: Segment customers based on average monthly transaction frequency

WITH customer_activity AS (
    SELECT 
        s.owner_id,
        COUNT(*) AS total_transactions,
        -- Calculate active months since first transaction
        PERIOD_DIFF(
            DATE_FORMAT(NOW(), '%Y%m'),
            DATE_FORMAT(MIN(s.created_on), '%Y%m')
        ) + 1 AS active_months
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),
frequency_labeled AS (
    SELECT 
        ca.owner_id,
        ca.total_transactions,
        ca.active_months,
        ROUND(ca.total_transactions / ca.active_months, 2) AS avg_txn_per_month,
        CASE
            WHEN (ca.total_transactions / ca.active_months) >= 10 THEN 'High Frequency'
            WHEN (ca.total_transactions / ca.active_months) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM customer_activity ca
),
final_summary AS (
    SELECT 
        frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_txn_per_month), 2) AS avg_transactions_per_month
    FROM frequency_labeled
    GROUP BY frequency_category
)

SELECT *
FROM final_summary
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');
