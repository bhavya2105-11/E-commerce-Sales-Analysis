# E-commerce Sales Analysis (Python + SQL + Power BI)

An end-to-end data analytics project: raw data is cleaned and analysed in **Python**, queried in **PostgreSQL**, and presented in an interactive **Power BI** dashboard.

![Dashboard Overview](./PBIdashboard.1.png)

## Project Objective
To understand how an online store is performing: how much revenue it earns, which products, categories, cities and customer segments drive it, and where revenue is being lost (cancellations, returns, failed payments and discounts).

## Dataset
Four CSV files covering orders from **1 Jan 2024 to 30 Jun 2026**:

| File | Rows | Description |
|---|---|---|
| customers | 10,000 | Age, city, signup date, customer segment |
| orders | 50,120 | Order date, product, quantity, discount, payment method, status |
| payments | 50,000 | Payment date and payment status (Paid, Failed, Refunded) |
| products | 20 | Product name, category, unit price |

## Tools Used
- **Python:** Pandas, NumPy, Matplotlib (Jupyter Notebook)
- **SQL:** PostgreSQL (pgAdmin)
- **Power BI:** DAX measures, slicers, interactive dashboard

## Data Cleaning (Python)
- Removed **120 duplicate** orders.
- Removed rows with missing `OrderDate` or `Quantity`, and **25 rows with zero or negative quantity**. The negative quantities were found while cross-checking revenue in SQL.
- Filled missing `Discount` with 0, and missing `PaymentMethod` and `City` with "Unknown". Filled missing `Age` with the median.
- Converted date columns to datetime.
- Merged the four tables with left joins, keeping all orders.
- 30 orders belong to a dummy `CustomerID 999999` that does not exist in the customers table. They were **kept** (valid sales) and tagged "Unknown", and excluded from customer-level counts.
- Created `Revenue = Quantity x UnitPrice x (1 - Discount)`.

**Business rule:** revenue counts only orders that are **Completed and Paid**. Cancelled, returned, failed and refunded orders are excluded.

## Key Metrics
| Metric | Value |
|---|---|
| Total Revenue | 2,990,114.95 |
| Total Orders | 42,721 |
| Average Order Value | 69.99 |
| Unique Customers | 9,858 |
| Cancellation Rate | ~4.9% |
| Return Rate | ~3.1% |
| Payment Failure Rate | ~3.9% |

The same totals were reproduced in Python, SQL and Power BI as a cross-check.

## Key Insights
- **Electronics** contributes about **50.6%** of revenue.
- **Tehran** is the top city (about 823K), followed by Mashhad, Karaj and Isfahan.
- **Gateway** payments make up about **47.5%** of orders, followed by CardToCard (24%) and Wallet (17%). Only about 10% of orders are paid in cash.
- **Regular** and **New** customers generate about 90% of revenue. **VIP** customers contribute under 10% and do not have a higher AOV, so the VIP programme may need a review.
- **Customers aged 36 to 50** contribute the most revenue (about 967K, around 32% of the total), followed by the 50+ group (about 895K). Together, customers aged 36 and above generate about 62% of revenue.
- **Discounts do not raise order value.** AOV falls from about 74.6 (no discount) to about 59.5 (20%+ discount), and the largest share of orders (35%) comes without any discount.
- Average discount is fairly uniform across products (about 7.5% to 8.1%).
- Monthly revenue stayed around 95K to 115K through 2025(Note that 2026 has only Jan to Jun data).
- Revenue peaked in **March 2024 (114.2K)** and was lowest in **February 2026 (64.5K)**.
  
## Dashboard Features
- KPI cards: Total Revenue, Quantity, Orders, AOV, Customers
- Slicers: order date, category, city
- Charts: monthly revenue trend, orders by payment method, revenue by customer segment, top 10 products, revenue by category, revenue by city

| Filtered to 2025 | 2025 + Accessories + Isfahan |
|---|---|
| ![2025](PBIdashboard.2.png) | ![Filtered](PBIdashboard.3.png) |

## SQL Analysis
Queries cover KPIs, date range, category revenue share, best-selling product per category (`RANK() OVER (PARTITION BY ...)`), average discount by product, segment revenue and AOV, top customers, payment methods, discount slabs (`CASE WHEN`) and city-wise revenue.

## Repository Structure
```
ecommerce-sales-analysis/
├── data/        raw CSV files and final_data.csv
├── notebook/    python_analysis_ecommerce.ipynb
├── sql/         sql_analysis_ecommerce.sql
├── powerbi/     ecommerce_dashboard.pbix and dashboard screenshots
└── README.md
```

## Assumptions and Limitations
- Revenue is based on Completed and Paid orders only.
- Missing ages were filled with the median, so age-based analysis is partly estimated.
- 2026 contains only six months of data, so year-over-year comparison with 2026 is not like-for-like.

## Next Steps
- Month-over-month growth with `LAG()` and running totals with window functions
- RFM customer segmentation
- Investigate the drop in revenue after Feb 2026

## Author
**Bhavya Singh**
B.Tech CSE student, aspiring Business Analyst
LinkedIn: _add your profile link here_
