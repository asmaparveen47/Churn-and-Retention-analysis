SELECT * FROM churndb.customer_churn;

#total cutomer !
select count(*) from customer_churn;

#churned/left customers!
select count(*) from customer_churn
where Churn='Yes';

#churnpercentage
select count(*),sum(case when churn = 'yes' then 1 else 0 end) as Churned_cust,
round(sum(case when churn = 'yes' then 1 else 0 end)*100/count(*),2)
from customer_churn;

#avg monthly charge
select avg(monthly_charges) from customer_churn

#avg tenure period
select avg(tenure_months) from customer_churn

#churn by contract type
select contract_type, count(*),sum(case when churn = 'yes' then 1 else 0 end) as churned_cust
from customer_churn
group by contract_type

select distinct(contract_type)
 from customer_churn
 
select lower(trim(contract_type)) as cleaned_colum
from customer_churn

update customer_churn
set Internet_Service = case
     when trim(Internet_Service) like 'Month-to-Month%' then 'Month-to-Month'
     when trim(Internet_Service) like 'One Year%' then 'One_year'
     when trim(Internet_Service) like  'Two Year%' then 'Two_year'
     else trim(Internet_Service)
end;

#Trim spaces in the internet_service colun
update customer_churn
set contract_type = case
     when trim(contract_type) like 'Fiber%' then 'Fiber'
     when trim(contract_type) like 'DSL%' then 'DSL'
     when trim(contract_type) like  '5G%' then '5G'
      when trim(contract_type) like  'Cable%' then 'Cable'
     else trim(contract_type)
end;
#churn by internet service
select Internet_Service, count(*),
sum(case when churn = 'yes' then 1 else 0 end) as churned_cust
from customer_churn
group by Internet_Service;

#churn by state
select state, count(*)as total_customer,
sum(case when churn = 'yes' then 1 else 0 end) as churned_cust
from customer_churn
group by state
order by 2 desc;

select * from customer_churn;

#total customers by payment method
select Payment_Method,count(*) as total_customers,
sum(case when churn = 'Yes' then 1 else 0 end) as churned_customer
 from customer_churn
group by Payment_Method
order by 2 desc;

#total customer by subscriptio_type
select Subscription_Type,count(*) as total_customers,
sum(case when churn = 'Yes' then 1 else 0 end) as churned_customer
 from customer_churn
group by Subscription_Type
order by 2 desc;


update customer_churn
set Subscription_Type = case
     when trim(Subscription_Type) like 'Premium%' then 'Premium'
     when trim(Subscription_Type) like 'Standard' then 'Standard'
     when trim(Subscription_Type) like  '%Basic %' then 'Basic'
     else trim(Subscription_Type)
end;

#highest revenue states
select  state,round(sum(total_charges) ,2)as totalrev
from customer_churn
group by state
order by 2 desc

#avgerage charges by contract
select contract_type, avg(monthly_charges)
from customer_churn
group by contract_type

#churn by citizen
select senior_citizen, count(*)
from customer_churn
where churn = 'Yes'
group by senior_citizen

update customer_churn
set senior_citizen= case
     when trim(senior_citizen) like 'No%' then 'No'
     when trim(senior_citizen) like 'Yes%' then 'Yes'
     else trim(senior_citizen)
end;

-- Step 1: Change Customer_Value to DOUBLE so it never truncates data
ALTER TABLE customer_churn 
MODIFY COLUMN Customer_Value DOUBLE;

-- Step 2: Temporarily disable Safe Update Mode for this calculation
SET SQL_SAFE_UPDATES = 0;

-- Step 3: Run the calculation (Safe Update requires a WHERE clause as well)
UPDATE customer_churn
SET Customer_Value = COALESCE(Monthly_Charges, 0) * COALESCE(Tenure_months, 0)
WHERE Monthly_Charges IS NOT NULL OR Tenure_months IS NOT NULL;

-- Step 4: Turn Safe Update Mode back on
SET SQL_SAFE_UPDATES = 1;

select * from customer_churn;
describe customer_churn;

#top 10 high value customers
select customer_name,customer_value
from customer_churn
order by customer_value desc
limit 10;

#customers without tech support
select * from customer_churn
where Tech_Support='no'

































