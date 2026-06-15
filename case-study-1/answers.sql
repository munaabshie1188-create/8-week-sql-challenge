/* ============================================================
   Case Study #1 - Danny's Diner
   8 Week SQL Challenge
   ============================================================ */

/* ------------------------------------------------------------
   Schema Setup
------------------------------------------------------------ */

CREATE TABLE sales (
  customer_id VARCHAR(1),
  order_date DATE,
  product_id INTEGER
);

INSERT INTO sales VALUES
  ('A', '2021-01-01', 1), ('A', '2021-01-01', 2), ('A', '2021-01-07', 2),
  ('A', '2021-01-10', 3), ('A', '2021-01-11', 3), ('A', '2021-01-11', 3),
  ('B', '2021-01-01', 2), ('B', '2021-01-02', 2), ('B', '2021-01-04', 1),
  ('B', '2021-01-11', 1), ('B', '2021-01-16', 3), ('B', '2021-02-01', 3),
  ('C', '2021-01-01', 3), ('C', '2021-01-01', 3), ('C', '2021-01-07', 3);

CREATE TABLE menu (
  product_id INTEGER,
  product_name VARCHAR(5),
  price INTEGER
);

INSERT INTO menu VALUES
  (1, 'sushi', 10), (2, 'curry', 15), (3, 'ramen', 12);

CREATE TABLE members (
  customer_id VARCHAR(1),
  join_date DATE
);

INSERT INTO members VALUES
  ('A', '2021-01-07'), ('B', '2021-01-09');


/* ============================================================
   Case Study Questions
   ============================================================ */

-- Q1: What is the total amount each customer spent at the restaurant?

SELECT 
  s.customer_id,
  SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- Q2: How many days has each customer visited the restaurant?

SELECT 
  customer_id,
  COUNT(DISTINCT order_date) AS visit_count
FROM sales
GROUP BY customer_id;


-- Q3: What was the first item from the menu purchased by each customer?

WITH ranked_sales AS (
  SELECT 
    s.customer_id,
    m.product_name,
    s.order_date,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
)
SELECT customer_id, product_name
FROM ranked_sales
WHERE rnk = 1;


-- Q4: What is the most purchased item on the menu and how many times was it purchased by all customers?

SELECT 
  m.product_name,
  COUNT(s.product_id) AS purchase_count
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY m.product_name
ORDER BY purchase_count DESC
LIMIT 1;


-- Q5: Which item was the most popular for each customer?

WITH item_counts AS (
  SELECT 
    s.customer_id,
    m.product_name,
    COUNT(*) AS order_count,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  GROUP BY s.customer_id, m.product_name
)
SELECT customer_id, product_name, order_count
FROM item_counts
WHERE rnk = 1;


-- Q6: Which item was purchased first by the customer after they became a member?

WITH member_sales AS (
  SELECT 
    s.customer_id,
    m.product_name,
    s.order_date,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mb ON s.customer_id = mb.customer_id
  WHERE s.order_date >= mb.join_date
)
SELECT customer_id, product_name, order_date
FROM member_sales
WHERE rnk = 1;


-- Q7: Which item was purchased just before the customer became a member?

WITH pre_member_sales AS (
  SELECT 
    s.customer_id,
    m.product_name,
    s.order_date,
    RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS rnk
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  JOIN members mb ON s.customer_id = mb.customer_id
  WHERE s.order_date < mb.join_date
)
SELECT customer_id, product_name, order_date
FROM pre_member_sales
WHERE rnk = 1;


-- Q8: What is the total items and amount spent for each member before they became a member?

SELECT 
  s.customer_id,
  COUNT(*) AS total_items,
  SUM(m.price) AS total_spent
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date < mb.join_date
GROUP BY s.customer_id;


-- Q9: If each $1 spent equates to 10 points and sushi has a 2x points multiplier,
-- how many points would each customer have?

SELECT 
  s.customer_id,
  SUM(CASE 
    WHEN m.product_name = 'sushi' THEN m.price * 20
    ELSE m.price * 10
  END) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
GROUP BY s.customer_id;


-- Q10: In the first week after a customer joins the program (including their join date)
-- they earn 2x points on all items, not just sushi.
-- How many points do customer A and B have at the end of January?

SELECT 
  s.customer_id,
  SUM(CASE 
    WHEN s.order_date BETWEEN mb.join_date AND DATE(mb.join_date, '+6 days')
      THEN m.price * 20
    WHEN m.product_name = 'sushi' 
      THEN m.price * 20
    ELSE m.price * 10
  END) AS total_points
FROM sales s
JOIN menu m ON s.product_id = m.product_id
JOIN members mb ON s.customer_id = mb.customer_id
WHERE s.order_date <= '2021-01-31'
GROUP BY s.customer_id;


/* ============================================================
   Bonus Questions
   ============================================================ */

-- Bonus 1: Join All The Things
-- Recreate a table showing customer_id, order_date, product_name, price, and member status (Y/N)

SELECT 
  s.customer_id,
  s.order_date,
  m.product_name,
  m.price,
  CASE 
    WHEN mb.join_date IS NULL THEN 'N'
    WHEN s.order_date >= mb.join_date THEN 'Y'
    ELSE 'N'
  END AS member
FROM sales s
JOIN menu m ON s.product_id = m.product_id
LEFT JOIN members mb ON s.customer_id = mb.customer_id
ORDER BY s.customer_id, s.order_date;


-- Bonus 2: Rank All The Things
-- Add a ranking column for member purchases only (NULL for non-member purchases)

WITH joined AS (
  SELECT 
    s.customer_id,
    s.order_date,
    m.product_name,
    m.price,
    CASE 
      WHEN mb.join_date IS NULL THEN 'N'
      WHEN s.order_date >= mb.join_date THEN 'Y'
      ELSE 'N'
    END AS member
  FROM sales s
  JOIN menu m ON s.product_id = m.product_id
  LEFT JOIN members mb ON s.customer_id = mb.customer_id
)
SELECT *,
  CASE 
    WHEN member = 'N' THEN NULL
    ELSE RANK() OVER (PARTITION BY customer_id, member ORDER BY order_date)
  END AS ranking
FROM joined
ORDER BY customer_id, order_date;
