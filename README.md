# 🚛 Smart Logistics Delay Report

![Dashboard Screenshot](Logistics.PNG)

## 📌 Executive Summary
The **Smart Logistics Delay Report** is a specialized Power BI analytic solution designed to diagnose and mitigate supply chain disruptions.

By integrating Financial, Operational, and Planning metrics into a unified view, this dashboard enables stakeholders to:
* **Quantify Delay Impact:** Track $170K+ in revenue currently at risk due to logistics failures.
* **Identify Bottlenecks:** Pinpoint critical failure times (e.g., 2 PM peak) and unreliable assets (Truck_8).
* **Optimize Planning:** Analyze the gap between inventory levels and demand forecasts to prevent stockouts.

---

## 🏗️ Project Architecture
* **Platform:** Power BI Desktop
* **Data Source:** Smart Logistics Dataset (CSV)
* **Key Visuals:** Grid-layout Dashboard with 3-Pillar Strategy (Finance, Operations, Planning).
* **Interactivity:** Dynamic slicers for "Date Range" and "Traffic Status".

### 📊 The 3-Pillar Strategy
1.  **Financial Health (CEO View):** Focuses on Revenue at Risk and SLA Penalty impacts.
2.  **Fleet Operations (Manager View):** Monitors On-Time Delivery (OTD), Utilization, and Asset Reliability.
3.  **Demand Planning (Analyst View):** Analyzes Inventory Gaps, Stockouts, and Delay Drivers.

---

## 🧮 DAX Measure Library
Below is the documentation of the custom DAX formulas used to drive the insights.

### 1. Key Performance Indicators (KPIs)
Calculations for high-level dashboard cards.

```dax
/* Calculates the total value of transactions currently flagged as delayed */
Revenue_At_Risk = 
SUMX(smart_logistics_dataset, IF([Logistics_Delay]=1, [User_Transaction_Amount], 0))

/* Total penalty cost incurred due to waiting times exceeding 30 minutes */
Penalty_Cost = 
SUM(smart_logistics_dataset[SLA_Penalty])

/* Percentage of shipments delivered without delay */
On_Time_Shipments% = 
DIVIDE([On_Time_Shipments], [Total_Shipments])
