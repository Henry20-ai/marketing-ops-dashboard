-- Marketing Operations Analysis Queries
-- Author: Henry Isaac
-- Database: PostgreSQL

-- Query 1: Channel Performance Analysis
SELECT 
    channel,
    COUNT(*) as total_campaigns,
    SUM(leads) as total_leads,
    SUM(customers) as total_customers,
    ROUND(SUM(revenue) - SUM(cost), 2) as net_profit,
    ROUND((SUM(revenue) - SUM(cost)) / NULLIF(SUM(cost), 0) * 100, 2) as roi_percentage
FROM campaigns
GROUP BY channel
ORDER BY net_profit DESC;

-- Query 2: Monthly Funnel Metrics
SELECT 
    TO_CHAR(campaign_date, 'YYYY-MM') as month,
    SUM(leads) as leads,
    SUM(mqls) as mqls,
    SUM(sqls) as sqls,
    SUM(customers) as customers,
    ROUND(SUM(mqls) * 100.0 / NULLIF(SUM(leads), 0), 2) as lead_to_mql_rate,
    ROUND(SUM(customers) * 100.0 / NULLIF(SUM(mqls), 0), 2) as mql_to_customer_rate
FROM campaigns
GROUP BY TO_CHAR(campaign_date, 'YYYY-MM')
ORDER BY month;

-- Query 3: Cost Per Acquisition by Channel
SELECT 
    channel,
    SUM(cost) as total_cost,
    SUM(customers) as total_customers,
    ROUND(SUM(cost) / NULLIF(SUM(customers), 0), 2) as cost_per_customer
FROM campaigns
WHERE customers > 0
GROUP BY channel
ORDER BY cost_per_customer ASC;

-- Query 4: Top 10 Best Performing Campaigns
SELECT 
    campaign_name,
    channel,
    leads,
    customers,
    revenue,
    cost,
    ROUND((revenue - cost) / NULLIF(cost, 0) * 100, 2) as roi_percentage
FROM campaigns
WHERE customers > 0
ORDER BY roi_percentage DESC
LIMIT 10;