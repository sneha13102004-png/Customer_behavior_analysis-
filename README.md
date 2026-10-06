🛍️ Customer Shopping Behavior Analysis
End-to-End Data Analytics Project
Python • Pandas • MySQL • SQL • Power BI
📌 Project Overview
Customer Shopping Behavior Analysis is an end-to-end data analytics project developed to understand customer purchasing patterns, product performance, spending behavior, discounts, subscriptions, shipping preferences, and customer segments.
The project follows a complete data analytics workflow:
Raw Data → Python Analysis → Data Cleaning → Feature Engineering → MySQL → SQL Analysis → Power BI Dashboard → Business Insights
The main objective is to transform raw customer shopping data into meaningful and easy-to-understand business insights.
🎯 Project Objectives
The main objectives of this project are:
- Understand overall customer purchasing behavior
- Analyze revenue across different customer groups
- Compare spending patterns by gender
- Compare subscribers and non-subscribers
- Identify highly rated products
- Identify frequently purchased products
- Analyze discount usage
- Segment customers based on previous purchases
- Compare different shipping methods
- Analyze revenue across age groups
- Build an interactive Power BI dashboard
- Generate useful business insights from the data
📊 Dataset
The project uses a Customer Shopping Behavior dataset containing 3,900 records and 18 columns.
Dataset Columns
- Customer ID
- Age
- Gender
- Item Purchased
- Category
- Purchase Amount (USD)
- Location
- Size
- Color
- Season
- Review Rating
- Subscription Status
- Shipping Type
- Discount Applied
- Promo Code Used
- Previous Purchases
- Payment Method
- Frequency of Purchases
The dataset provides information about customer demographics, purchases, products, ratings, discounts, subscriptions, shipping, and previous purchase behavior.
🧰 Tools & Technologies
Tool	Purpose
Python	Data loading, exploration, cleaning and feature engineering
Pandas	Data manipulation and analysis
MySQL	Database storage and analysis
SQL	Business-question analysis
Power BI	Interactive dashboard and visualization
Jupyter Notebook	Python development and analysis
Gamma	Presentation creation


🔄 Project Workflow
Customer Shopping Dataset
          ↓
       Python
          ↓
 Data Exploration
          ↓
   Data Cleaning
          ↓
 Feature Engineering
          ↓
        MySQL
          ↓
   SQL Analysis
          ↓
      Power BI
          ↓
 Interactive Dashboard
          ↓
  Business Insights

🐍 1. Python Data Analysis
The first stage of the project was performed using Python and Pandas.
Loading the Dataset
import pandas as pddf = pd.read_csv("customer_shopping_behavior.csv")


The dataset was inspected using:
df.head()df.tail()df.info()df.describe()df.describe(include='all')


These commands helped understand:
- Dataset structure
- Number of records
- Column names
- Data types
- Statistical information
- First and last records
🔍 2. Exploratory Data Analysis
Exploratory Data Analysis, or EDA, was performed to understand the data before applying further analysis.
Checking Missing Values
df.isnull().sum()


The analysis identified missing values in the Review Rating column.
Dataset Statistics
df.describe()


This was used to examine values such as:
- Mean
- Minimum
- Maximum
- Standard deviation
- Quartiles
EDA helped identify the overall structure and characteristics of the customer shopping data.
🧹 3. Data Cleaning
Data preparation was performed before database analysis.
Standardizing Column Names
df.columns = df.columns.str.lower()df.columns = df.columns.str.replace(' ', '_')


The purchase amount column was renamed:
df = df.rename(    columns={'purchase_amount_(usd)': 'purchase_amount'})


This made the column names easier to use in Python and SQL.
🧠 4. Feature Engineering
Additional features were created to support deeper analysis.
Age Group
Customers were divided into four age groups using quartiles:
labels = [    'Young Adult',    'Adult',    'Middle-aged',    'Senior']df['age_group'] = pd.qcut(    df['age'],    q=4,    labels=labels)


This allows customer behavior to be analyzed across different age groups.
Purchase Frequency
Purchase frequency was converted into an approximate number of days.
frequency_mapping = {    'fortnightly': 14,    'weekly': 7,    'monthly': 30,    'quaterly': 90,    'Bi-Weekly': 14,    'Annually': 365,    'Every 3 months': 90}df['purchase_frequency_days'] = (    df['frequency_of_purchases'].map(frequency_mapping))


This creates a numerical representation of purchasing frequency.
🗄️ 5. MySQL Database
After the Python analysis, the customer shopping data was imported into MySQL.
Database
customer_behaviour

Main Table
customer_shopping

Python was connected to MySQL using SQLAlchemy.
from sqlalchemy import create_engine


The data was then transferred to MySQL using:
df.to_sql(    'customer_shopping',    con=engine,    if_exists='replace',    index=False)


🔎 6. SQL Business Analysis
The SQL stage contains 10 business-oriented questions.
These questions were designed to understand customer behavior, revenue, products, discounts, subscriptions, and purchasing patterns.   classroom
Q1. Gender-wise Total Revenue
The total revenue was calculated for each gender.
SELECT
    Gender,
    SUM(`Purchase Amount (USD)`) AS Revenue
FROM customer_shopping
GROUP BY Gender;

Result
Gender	Revenue
Male	$157,890
Female	$75,191


This allows comparison of revenue generated by different gender groups.
Q2. Discount Users Who Spent Above Average
Customers who used a discount but still spent at least the average purchase amount were identified using a subquery.
SELECT
    `Customer ID`,
    `Purchase Amount (USD)`
FROM customer_shopping
WHERE `Discount Applied` = 'Yes'
AND `Purchase Amount (USD)` >= (
    SELECT AVG(`Purchase Amount (USD)`)
    FROM customer_shopping
);

The analysis identified 839 customers meeting this condition.
Q3. Top 5 Products by Average Review Rating
The five products with the highest average ratings were identified.
SELECT
    `Item Purchased`,
    AVG(`Review Rating`) AS `Average Product Rating`
FROM customer_shopping
GROUP BY `Item Purchased`
ORDER BY `Average Product Rating` DESC
LIMIT 5;

Top 5 Products
1. Gloves
2. Sandals
3. Boots
4. Hat
5. Skirt
Q4. Standard vs Express Shipping
The average purchase amount was compared between Standard and Express shipping.
Shipping Type	Average Purchase
Express	$60.48
Standard	$58.46


Express shipping customers had a slightly higher average purchase amount.
Q5. Subscribers vs Non-Subscribers
Customer count, average spending, and total revenue were compared based on subscription status.
Subscription Status	Customers	Average Spend	Total Revenue
No	2,847	$59.87	$170,436
Yes	1,053	$59.49	$62,645


The analysis shows that non-subscribers generated higher total revenue in this dataset.
Q6. Products with the Highest Discount Rate
The percentage of purchases where a discount was applied was calculated for each product.
The top five products were:
1. Hat
2. Sneakers
3. Coat
4. Sweater
5. Pants
This analysis helps identify products that frequently appear in discounted purchases.
Q7. Customer Segmentation
Customers were divided into three segments based on previous purchases:
Segment	Definition
New	1 previous purchase
Returning	2–10 previous purchases
Loyal	More than 10 previous purchases


Results
Customer Segment	Number of Customers
Loyal	3,116
Returning	701
New	83


This segmentation helps understand customer retention and purchasing history.   classroom
Q8. Top 3 Products Within Each Category
A CTE and the ROW_NUMBER() window function were used to rank products within each category.
The query uses:
WITH item_counts AS (...)

and:
ROW_NUMBER() OVER (
    PARTITION BY `Category`
    ORDER BY COUNT(*) DESC
)

This allows the top three most purchased products to be identified separately within each category.   classroom
SQL Concepts Demonstrated
- CTE
- GROUP BY
- ROW_NUMBER()
- PARTITION BY
- ORDER BY
Q9. Repeat Buyers and Subscription
Customers with more than five previous purchases were considered repeat buyers.
SELECT
    `Subscription Status`,
    COUNT(`Customer ID`) AS repeat_buyers
FROM customer_shopping
WHERE `Previous Purchases` > 5
GROUP BY `Subscription Status`;

Result
Subscription Status	Repeat Buyers
No	2,518
Yes	958


This analysis helps compare subscription behavior among repeat customers.
Q10. Revenue by Age Group
Revenue was analyzed across different age groups.
The SQL query created these groups:
- 18–25
- 26–35
- 36–45
- 46–55
- 56+
Results
Age Group	Revenue
56+	$65,256
46–55	$45,619
26–35	$44,342
36–45	$43,234
18–25	$34,630


The 56+ age group generated the highest revenue in this analysis.   classroom
📊 7. Power BI Dashboard
An interactive Customer Behavior Analysis Dashboard was created using Power BI.
The dashboard presents the results in an easy-to-understand visual format.
Dashboard Includes
- Customer KPIs
- Purchase amount
- Review rating
- Revenue by category
- Sales/orders by category
- Subscription analysis
- Age-based analysis
- Category performance
- Interactive filters
Dashboard Filters
The dashboard allows users to filter the analysis using:
- Category
- Gender
- Subscription Status
- Shipping Type
This makes it possible to explore different customer groups interactively.
