# SQL Analytics — Railway Ticketing System

A collection of eight analytical PostgreSQL queries written against a multi-table railway ticketing schema as part of the Database Technologies course at FIIT STU Bratislava. Each query targets a distinct business question and demonstrates a different combination of advanced SQL techniques.

---

## Queries

- Cumulative daily revenue using `SUM() OVER` with an unbounded window frame
- Per-stop departure delay tracking and change calculation using `LAG()`
- Month-over-month average ticket price change with percentage difference
- Identifying customers who purchased both first and second class tickets using conditional `COUNT() FILTER`
- Finding consecutive ride intervals per train using a gap-and-island pattern built with cumulative sums and `PARTITION BY`
- Most popular destinations from Bratislava using `FIRST_VALUE()` over partitioned route stops
- Wagon occupancy percentage per ride, wagon, and railcar type using multi-level subqueries and `ROUND()`
- Customer spending growth streaks: identifying customers with at least 3 consecutive months of increasing spend, with min/max monthly spend

---

## Topics Covered

Window functions · CTEs · Aggregation · Gap-and-island · Partitioning · Date truncation · Conditional filtering

## Technologies

SQL · PostgreSQL
