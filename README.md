# 8 Week SQL Challenge - Case Study #1: Danny's Diner

## Introduction
Danny seriously loves Japanese food, so in early 2021 he opened a small restaurant
selling his 3 favourite foods: **sushi, curry, and ramen**.

Danny's Diner needs help analyzing customer data to understand:
- Customer visiting patterns
- How much money customers have spent
- Which menu items are customer favourites

These insights will help Danny decide whether to expand his customer loyalty program.

## Data Source
Original case study: [8 Week SQL Challenge - Case Study #1](https://8weeksqlchallenge.com/case-study-1/)

## Entity Relationship Diagram
The database consists of 3 tables:

- **sales** - captures customer_id, order_date, and product_id for every order
- **menu** - maps product_id to product_name and price
- **members** - captures the join_date for customers in the loyalty program

## Tools Used
- SQL (SQLite, via SQLiteOnline)

## Questions Answered

### Case Study Questions
1. What is the total amount each customer spent at the restaurant?
2. How many days has each customer visited the restaurant?
3. What was the first item from the menu purchased by each customer?
4. What is the most purchased item on the menu and how many times was it purchased by all customers?
5. Which item was the most popular for each customer?
6. Which item was purchased first by the customer after they became a member?
7. Which item was purchased just before the customer became a member?
8. What is the total items and amount spent for each member before they became a member?
9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier, how many points would each customer have?
10. In the first week after a customer joins the program (including their join date), they earn 2x points on all items. How many points do customer A and B have at the end of January?

### Bonus Questions
- **Join All The Things** - Recreate a combined table showing customer purchases with product names, prices, and membership status
- **Rank All The Things** - Add a ranking column for member purchases only (non-member purchases show NULL)

## Key SQL Concepts Used
- Joins (INNER JOIN, LEFT JOIN)
- Aggregate functions (SUM, COUNT)
- GROUP BY
- Common Table Expressions (CTEs)
- Window functions (RANK)
- CASE statements
- Date functions

## File Structure
- `case_study_1.sql` - Contains the schema setup and all SQL solutions with comments
