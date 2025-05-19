-- Savings accounts with no transactions in the past 365 days
SELECT 
    ss.plan_id,
    ss.owner_id,
    'Savings' AS type,
    MAX(ss.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(ss.transaction_date)) AS inactivity_days
FROM savings_savingsaccount ss
GROUP BY ss.plan_id, ss.owner_id
HAVING MAX(ss.transaction_date) < CURDATE() - INTERVAL 365 DAY

UNION ALL

-- Investment plans with no transactions in the past 365 days
SELECT 
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(ss.transaction_date) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(ss.transaction_date)) AS inactivity_days
FROM plans_plan p
LEFT JOIN savings_savingsaccount ss ON p.id = ss.plan_id
WHERE p.is_fixed_investment = 1 
  AND p.is_deleted = 0 
  AND p.is_archived = 0
GROUP BY p.id, p.owner_id
HAVING MAX(ss.transaction_date) IS NULL OR MAX(ss.transaction_date) < CURDATE() - INTERVAL 365 DAY;
