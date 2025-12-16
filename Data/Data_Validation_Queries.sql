/*
=============================================================================
Project: Smart Logistics Delay Report
========================================================
*/

-----------------------------------------------------------------------------
-- 1. FINANCIAL PILLAR CHECKS
-----------------------------------------------------------------------------

-- KPI: Total Revenue
-- Context: Checks the high-level revenue figure against the dashboard card.
SELECT CONCAT((SUM(User_Transaction_Amount)/1000),' K') AS Total_Revenue
FROM smart_logistics;

-- KPI: Revenue at Risk
-- Context: Calculates potential loss from currently delayed shipments.
SELECT CONCAT((SUM(User_Transaction_Amount)/1000),' K') AS Revenue_At_Risk
FROM smart_logistics
WHERE Logistics_Delay = 1;

-- KPI: Estimated SLA Penalty
-- Context: $10 fine for every minute waiting > 30 mins.
SELECT SUM(
    CASE 
        WHEN Waiting_Time > 30 THEN (Waiting_Time - 30) * 10 
        ELSE 0 
    END
) AS Total_SLA_Penalty
FROM smart_logistics;

-- ANALYSIS: Revenue Per Segment
WITH Segmented_Data AS (
    SELECT User_Transaction_Amount,
        CASE 
            WHEN User_Purchase_Frequency >= 8 THEN 'Gold'
            WHEN User_Purchase_Frequency >= 4 THEN 'Silver'
            ELSE 'Bronze'
        END AS Customer_Segment
    FROM smart_logistics
)
SELECT Customer_Segment, SUM(User_Transaction_Amount) AS Revenue
FROM Segmented_Data
GROUP BY Customer_Segment;


-----------------------------------------------------------------------------
-- 2. OPERATIONS PILLAR CHECKS
-----------------------------------------------------------------------------

-- KPI: On-Time Delivery (OTD) Rate
SELECT 
    COUNT(*) AS Total_Shipments,
    SUM(CASE WHEN Logistics_delay = 0 THEN 1 ELSE 0 END) AS OnTime_Shipments,
    CONCAT(CAST(SUM(CASE WHEN Logistics_delay = 0 THEN 1 ELSE 0 END)*100.0 / COUNT(*) AS DECIMAL(10,2)),' %') as OTD_Rate
FROM smart_logistics;

-- ANALYSIS: Top 3 "Problem Assets" (Mechanical Failures)
-- Context: Validates the Matrix visual for fleet maintenance.
SELECT TOP (3) Asset_ID, COUNT(*) AS Total_Failures
FROM smart_logistics
WHERE Logistics_Delay_Reason = 'Mechanical Failure'
GROUP BY Asset_ID
ORDER BY Total_Failures DESC;

-- ANALYSIS: Traffic Impact on Delays
SELECT 
    Traffic_Status,
    COUNT(*) as Total_Trips,
    ROUND(CAST(SUM(Logistics_Delay) AS FLOAT) / COUNT(*) * 100, 1) as Delay_Rate_Pct
FROM smart_logistics
GROUP BY Traffic_Status
ORDER BY Delay_Rate_Pct DESC;

-- ANALYSIS: Average Utilization Per Vehicle
SELECT Asset_ID, ROUND(AVG(Asset_Utilization),1) AS Avg_Vehicle_Utilization 
FROM smart_logistics
GROUP BY Asset_ID;


-----------------------------------------------------------------------------
-- 3. PLANNING PILLAR CHECKS
-----------------------------------------------------------------------------

-- KPI: Under-Stocked Shipments
-- Context: Counts shipments where Inventory was insufficient for Demand.
SELECT COUNT(*) AS Under_Stocked_Count
FROM smart_logistics
WHERE Inventory_Level < Demand_Forecast;

-- ANALYSIS: Stockout Risk Flag Logic
-- Context: Verifies which Assets have the highest stockout occurrences.
SELECT Asset_ID, 
       COUNT(*) as Stockout_Events
FROM smart_logistics
WHERE Inventory_Level < Demand_Forecast
GROUP BY Asset_ID
ORDER BY Stockout_Events DESC;

-- ANALYSIS: Top Delay Reasons
SELECT Logistics_Delay_Reason, COUNT(*) AS Frequency 
FROM smart_logistics
WHERE Logistics_Delay = 1 
GROUP BY Logistics_Delay_Reason 

ORDER BY Frequency DESC;
