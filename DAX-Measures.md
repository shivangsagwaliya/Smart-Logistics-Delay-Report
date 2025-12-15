# 📦 Smart Logistics – DAX Measures & Calculated Columns
---

## 📑 Table of Contents

1. Overview
2. Key Performance Indicators (KPIs)
3. Delay & Risk Metrics
4. Customer Segment Metrics
5. Revenue & Penalty Metrics
6. Operational Metrics
7. Calculated Columns

---

## 1️⃣ Overview

**Dataset:** `smart_logistics_dataset`

**Purpose:**
This DAX library supports logistics performance monitoring, customer segmentation, delay analysis, revenue impact assessment, and inventory risk detection.

---

## 2️⃣ Key Performance Indicators (KPIs)

### Total Shipments

```DAX
Total_Shipments = COUNTROWS(smart_logistics_dataset)
```

Counts the total number of shipments.

---

### On-Time Shipments

```DAX
On_Time_Shipments =
SUMX(
    smart_logistics_dataset,
    IF(smart_logistics_dataset[Logistics_Delay] = 0, 1, 0)
)
```

Counts shipments delivered without delay.

---

### On-Time Shipments %

```DAX
On_Time_Shipments% =
DIVIDE([On_Time_Shipments], [Total_Shipments])
```

Percentage of shipments delivered on time.

---

## 3️⃣ Delay & Risk Metrics

### Total Delayed Shipments

```DAX
Total_Delayed_Shipments =
SUM(smart_logistics_dataset[Logistics_Delay])
```

Counts shipments that experienced delays.

---

### Shipments at Risk

```DAX
Shipments_At_Risk =
DIVIDE([Total_Delayed_Shipments], [Total_Shipments])
```

Ratio of delayed shipments to total shipments.

---

### Mechanical Failure Count

```DAX
Mechanical_Failure_Count =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay_Reason] = "Mechanical Failure",
        1,
        0
    )
)
```

Counts delays caused by mechanical failure.

---

### Under-Stocked Shipments

```DAX
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
```

Counts shipments where inventory was insufficient.

---

## 4️⃣ Customer Segment Metrics

### Total Gold Shipments

```DAX
Total_Gold_Shipments =
COUNTAX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Customer_Segment] = "Gold",
        smart_logistics_dataset[Customer_Segment]
    )
)
```

Counts shipments belonging to Gold customers.

---

### Total Gold Shipments Delayed

```DAX
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
```

Counts delayed shipments for Gold customers.

---

### Gold Transactions at Risk

```DAX
Gold_Transactions_At_Risk =
DIVIDE(
    [Total_Gold_Shipments_Delayed],
    [Total_Gold_Shipments]
)
```

Percentage of Gold shipments that are delayed.

---

### Total Gold Transactions

```DAX
Total_Gold_Transactions =
SUMX(
    smart_logistics_dataset,
    IF(smart_logistics_dataset[Customer_Segment] = "Gold", 1, 0)
)
```

Counts Gold customer transactions.

---

## 5️⃣ Revenue & Penalty Metrics

### Total Revenue

```DAX
Total_Revenue =
SUM(smart_logistics_dataset[User_Transaction_Amount])
```

Total revenue from all transactions.

---

### Revenue at Risk

```DAX
Revenue_At_Risk =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay] = 1,
        smart_logistics_dataset[User_Transaction_Amount],
        0
    )
)
```

Revenue associated with delayed shipments.

---

### Total Revenue – Delayed Transactions

```DAX
Total_Revenue_Delayed_Transactions =
SUMX(
    smart_logistics_dataset,
    IF(
        smart_logistics_dataset[Logistics_Delay] = 1,
        smart_logistics_dataset[User_Transaction_Amount],
        0
    )
)
```

Total revenue impacted by delays.

---

### Penalty Cost

```DAX
Penalty_Cost =
SUM(smart_logistics_dataset[SLA_Penalty])
```

Total SLA penalties incurred.

---

## 6️⃣ Operational Metrics

### Planning Gap

```DAX
Planning Gap =
'smart_logistics_dataset'[Inventory_Level]
- 'smart_logistics_dataset'[Demand_Forecast]
```

Difference between inventory level and demand forecast.

---

## 7️⃣ Calculated Columns

### Customer Segment

```DAX
Customer_Segment =
SWITCH(
    TRUE(),
    smart_logistics_dataset[User_Purchase_Frequency] >= 8, "Gold",
    smart_logistics_dataset[User_Purchase_Frequency] >= 4, "Silver",
    "Bronze"
)
```

Customer tier based on purchase frequency.

---

### SLA Penalty

```DAX
SLA_Penalty =
SWITCH(
    TRUE(),
    smart_logistics_dataset[Waiting_Time] > 30,
    (smart_logistics_dataset[Waiting_Time] - 30) * 10
)
```

Penalty applied when SLA waiting time exceeds 30 minutes.

---

### Hour of Day

```DAX
Hour of Day =
HOUR('smart_logistics_dataset'[Timestamp])
```

Extracts hour from timestamp.

---

### Stockout Risk Flag

```DAX
Stockout_Risk_Flag =
IF(
    'smart_logistics_dataset'[Inventory_Level]
        < 'smart_logistics_dataset'[Demand_Forecast],
    "High Risk",
    "Safe"
)
```

Flags stockout risk.

---

### Delivery Status

```DAX
Delivery_Status =
IF(
    'smart_logistics_dataset'[Logistics_Delay] = 0,
    "On Time",
    "Delayed"
)
```

Classifies delivery outcome.

---

✅ **This file is ready for direct copy-paste into a `.md` file or documen
