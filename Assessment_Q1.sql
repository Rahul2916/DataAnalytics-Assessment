SELECT 
    u.id AS owner_id,
    u.name,
    COUNT(DISTINCT ss.id) AS savings_count,
    COUNT(DISTINCT ip.id) AS investment_count,
    SUM(ss.amount) AS total_deposits
FROM users_customuser u
JOIN savings_savingsaccount ss ON u.id = ss.owner_id AND ss.amount > 0
JOIN plans_plan ip ON u.id = ip.owner_id AND ip.is_fixed_investment = 1
GROUP BY u.id, u.name
HAVING savings_count >= 1 AND investment_count >= 1
ORDER BY total_deposits DESC;
