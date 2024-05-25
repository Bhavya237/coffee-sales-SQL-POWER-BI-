select cast(transaction_date as DATE),cast(transaction_time as TIME) from  coffee_sales

select FORMAT(transaction_date,'dd/MM/yyyy')as transaction_date from coffee_sales

select * from coffee_sales

UPDATE coffee_sales
SET transaction_date=FORMAT(transaction_date,'dd/MM/yyyy')

ALTER TABLE coffee_sales
ALTER COLUMN transaction_time  TIME


ALTER TABLE coffee_sales
ALTER COLUMN transaction_date  DATE


#####  TOTAL SALES

select sum(unit_price*transaction_qty) as total_sales from coffee_sales


##### MOM Growth
with cte1 as(select datepart(month,transaction_date)as month_name,sum(unit_price*transaction_qty) as current_month_sale,
lag(sum(unit_price*transaction_qty),1) over (order by datepart(month,transaction_date))as previous_month_sale
from coffee_sales group by datepart(month,transaction_date))
select *,(current_month_sale-previous_month_sale)/previous_month_sale*100 as MOM_Growth
from cte1

####TOTAL ORDERS 
select count(transaction_id) as total_orders,DATEPART(month,transaction_date)as month from coffee_sales
group by DATEPART(month,transaction_date)

### MOM GROWTH
with cte1 as(
select DATEPART(month,transaction_date)as month,count(transaction_id) as current_order,
lag(count(transaction_id),1) over(order by DATEPART(month,transaction_date))as previous_month_order from coffee_sales
group by DATEPART(month,transaction_date))
select*,(current_order-previous_month_order)/previous_month_order*100 as MOM_change_percentage
from cte1

###TOTAL QUANTITY SOLD

with cte1 as(select datepart(month,transaction_date)as month_name,sum(transaction_qty) as current_month_qty_sold,
lag(sum(transaction_qty),1) over (order by datepart(month,transaction_date))as previous_month_qty_sold
from coffee_sales group by datepart(month,transaction_date))
select *,(current_month_qty_sold-previous_month_qty_sold)/previous_month_qty_sold*100 as MOM_Growth
from cte1

####CALENDAR TABLE – DAILY SALES, QUANTITY and TOTAL ORDERS

SELECT sum(unit_price * transaction_qty) AS total_sales,
    sum(transaction_qty) AS total_quantity_sold,
    count(transaction_id) AS total_orders
from coffee_sales
where  transaction_date = '2023-05-18'



SALES TREND OVER PERIOD
##Daily sales
select DATEPART(day,transaction_date)as day,sum(transaction_qty*unit_price)as daily_sales
from coffee_sales
where datepart(month,transaction_date)=05
group by DATEPART(day,transaction_date)
order by daily_sales desc

select day,
case
when total_sales< avg_sales then 'less_than_avg'
when total_sales> avg_sales then 'more_than_avg'
end as sales_status,total_sales from(
select DATEPART(day,transaction_date)as day,AVG(sum(transaction_qty*unit_price))as avg_sales,
sum(transaction_qty*unit_price)as total_sales
from coffee_sales 
where datepart(month,transaction_date)=05
group by DATEPART(day,transaction_date))


####WEEKDAY AND WEEKEND SALE

select case when datepart(WEEKDAY,transaction_date) 
in (1,7)then 'weekend' else 'weekday' end as day_type,
round(SUM(unit_price*transaction_qty),2)as total_sales from coffee_sales
group by case when datepart(WEEKDAY,transaction_date) in (1,7)then 'weekend' else 'weekday' end


####SALES BY STORE LOCATION
select round(SUM(unit_price*transaction_qty),2)as total_sales,store_location 
from coffee_sales group by store_location
order by total_sales

SALES BY PRODUCT CATEGORY
select round(SUM(unit_price*transaction_qty),2)as total_sales,product_category 
from coffee_sales group by product_category
order by total_sales

####SALES BY PRODUCT TYPE
select round(SUM(unit_price*transaction_qty),2)as total_sales,product_type 
from coffee_sales group by product_type
order by total_sales

### SALES FROM MONDAY TO SUNDAY FOR MONTH OF MAY
select  case
when DATEPART(weekday,transaction_date)=1 then 'Monday'
when DATEPART(weekday,transaction_date)=2 then 'Tuesday'
 when DATEPART(weekday,transaction_date)=3 then 'Wednesday'
 when DATEPART(weekday,transaction_date)=4 then 'Thursday'
 when DATEPART(weekday,transaction_date)=5 then 'Friday'
 when DATEPART(weekday,transaction_date)=6 then 'Saturday'
 when DATEPART(weekday,transaction_date)=7 then 'Sunday'
end as day_of_week,
round(sum(unit_price*transaction_qty) ,2)as total_sales
from coffee_sales
where datepart(month,transaction_date)=05
group by  case
when DATEPART(weekday,transaction_date)=1 then 'Monday'
 when DATEPART(weekday,transaction_date)=2 then 'Tuesday'
 when DATEPART(weekday,transaction_date)=3 then 'Wednesday'
 when DATEPART(weekday,transaction_date)=4 then 'Thursday'
when DATEPART(weekday,transaction_date)=5 then 'Friday'
 when DATEPART(weekday,transaction_date)=6 then 'Saturday'


 
TO GET SALES FOR ALL HOURS FOR MONTH OF MAY

 when DATEPART(weekday,transaction_date)=7 then 'Sunday'
end
order by total_sales desc
