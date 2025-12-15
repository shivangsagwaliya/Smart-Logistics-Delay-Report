# 📦 Smart Logistics – DAX Measures & Calculated Columns

This document contains all **DAX Measures** and **Calculated Columns** used in the **Smart Logistics Analytics Model**, organized for clarity and maintainability.

---

## 📑 Table of Contents
1. Key Performance Indicators (KPIs)
2. Delay & Risk Metrics
3. Customer Segment Metrics
4. Revenue & Penalty Metrics
5. Operational Metrics
6. Calculated Columns

---

## 1️⃣ Key Performance Indicators (KPIs)

### Total Shipments
```DAX
Total_Shipments = COUNTROWS(smart_logistics_dataset)
Counts total shipments.

On-Time Shipments
DAX
Copy code
On_Time_Shipments =
SUMX(
    smart_logistics_dataset,
    IF(smart_logistics_dataset[Logistics_Delay] = 0, 1, 0)
)
Counts shipments delivered on time.

On-Time Shipments %
DAX
Copy code
On_Time_Shipments% =
DIVIDE([On_Time_Shipments], [Total_Shipments])
Percentage of shipments delivered on time.

2️⃣ Delay & Risk Metrics
Total Delayed Shipments
DAX
Copy code
Total_Delayed_Shipments =
SUM(smart_logistics_dataset[Logistics_Delay])
Counts delayed shipments.

Shipments at Risk
DAX
Copy code
Shipments_At_Risk =
DIVIDE([Total_Delayed_Shipments], [Total_Shipments])
Ratio of delayed shipments to total shipments.

Mechanical Failure Count
DAX
Copy code
Mechanical_Failure_Count =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay_Reason] = "Mechanical Failure",
        1,
        0
    )
)
Counts delays caused by mechanical failure.

Under-Stocked Shipments
DAX
Copy code
Under-Stocked-Shipments =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Inventory_Level]
            < smart_logistics_dataset[Demand_Forecast],
        1,
        0
    )
)
Counts shipments with insufficient inventory.

3️⃣ Customer Segment Metrics
Total Gold Shipments
DAX
Copy code
Total_Gold_Shipments =
COUNTAX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Customer_Segment] = "Gold",
        smart_logistics_dataset[Customer_Segment]
    )
)
Counts Gold customer shipments.

Total Gold Shipments Delayed
DAX
Copy code
Total_Gold_Shipments_Delayed =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Customer_Segment] = "Gold"
            && smart_logistics_dataset[Logistics_Delay] = 1,
        1,
        0
    )
)
Counts delayed Gold customer shipments.

Gold Transactions at Risk
DAX
Copy code
Gold_Transactions_At_Risk =
DIVIDE(
    [Total_Gold_Shipments_Delayed],
    [Total_Gold_Shipments]
)
Percentage of Gold shipments delayed.

Total Gold Transactions
DAX
Copy code
Total_Gold_Transactions =
SUMX(
    smart_logistics_dataset,
    IF(smart_logistics_dataset[Customer_Segment] = "Gold", 1, 0)
)
Counts Gold customer transactions.

4️⃣ Revenue & Penalty Metrics
Total Revenue
DAX
Copy code
Total_Revenue =
SUM(smart_logistics_dataset[User_Transaction_Amount])
Total transaction revenue.

Revenue at Risk
DAX
Copy code
Revenue_At_Risk =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay] = 1,
        smart_logistics_dataset[User_Transaction_Amount],
        0
    )
)
Revenue impacted by delayed shipments.

Total Revenue – Delayed Transactions
DAX
Copy code
Total_Revenue_Delayed_Transactions =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay] = 1,
        smart_logistics_dataset[User_Transaction_Amount],
        0
    )
)
Total revenue from delayed deliveries.

Penalty Cost
DAX
Copy code
Penalty_Cost =
SUM(smart_logistics_dataset[SLA_Penalty])
Total SLA penalties incurred.

5️⃣ Calculated Columns
Customer Segment
DAX
Copy code
Customer_Segment =
SWITCH(
    TRUE(),
    smart_logistics_dataset[User_Purchase_Frequency] >= 8, "Gold",
    smart_logistics_dataset[User_Purchase_Frequency] >= 4, "Silver",
    "Bronze"
)
Customer classification based on purchase frequency.

SLA Penalty
DAX
Copy code
SLA_Penalty =
SWITCH(
    TRUE(),
    smart_logistics_dataset[Waiting_Time] > 30,
    (smart_logistics_dataset[Waiting_Time] - 30) * 10
)
Penalty applied for SLA breaches.

Hour of Day
DAX
Copy code
Hour of Day =
HOUR('smart_logistics_dataset'[Timestamp])
Extracts hour from timestamp.

Planning Gap
DAX
Copy code
Planning Gap =
'smart_logistics_dataset'[Inventory_Level]
- 'smart_logistics_dataset'[Demand_Forecast]
Difference between inventory and demand.

Stockout Risk Flag
DAX
Copy code
Stockout_Risk_Flag =
IF(
    'smart_logistics_dataset'[Inventory_Level]
        < 'smart_logistics_dataset'[Demand_Forecast],
    "High Risk",
    "Safe"
)
Indicates stockout risk.

Delivery Status
DAX
Copy code
Delivery_Status =
IF(
    'smart_logistics_dataset'[Logistics_Delay] = 0,
    "On Time",
    "Delayed"
)
Shipment delivery classification.
