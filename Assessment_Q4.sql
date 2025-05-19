WITH customer_tx_data AS (
    SELECT 
        ss.owner_id,
        COUNT(*) AS total_transactions,
        SUM(ss.confirmed_amount) AS total_confirmed_amount
    FROM savings_savingsaccount ss
    WHERE ss.confirmed_amount > 0
    GROUP BY ss.owner_id
),
customer_tenure AS (
    SELECT 
        u.id AS customer_id,
        u.name,
        TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months
    FROM users_customuser u
),
combined AS (
    SELECT 
        t.customer_id,
        t.name,
        t.tenure_months,
        COALESCE(d.total_transactions, 0) AS total_transactions,
        COALESCE(d.total_confirmed_amount, 0) AS total_confirmed_amount,
        CASE 
            WHEN t.tenure_months > 0 THEN 
                ROUND((d.total_transactions / t.tenure_months) * 12 * (d.total_confirmed_amount / d.total_transactions) * 0.001, 2)
            ELSE 0
        END AS estimated_clv
    FROM customer_tenure t
    LEFT JOIN customer_tx_data d ON t.customer_id = d.owner_id
)
SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    estimated_clv
FROM combined
ORDER BY estimated_clv DESC;
