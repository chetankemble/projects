-- --USE lco_motors;

-- --Q1) How would you fetch details of the customers  who cancelled orders?

SELECT * FROM customers 
LEFT JOIN orders ON orders.customer_id = customers.customer_id 
WHERE orders.status = "Cancelled";

-- --Q2) Fetch the details of customers who have done payments between the amount 5,000 and 35,000?
SELECT * FROM customers 
LEFT JOIN payments on customers.customer_id = payments.customer_id
WHERE amount  between 5000 and 35000
ORDER BY payments.amount;

-- --Q3) Add new employee/salesman with following details:-
-- --EMP ID - 15657
-- --First Name : Lakshmi
-- --Last Name: Roy
-- --Extension : x4065
-- --Email: lakshmiroy1@lcomotors.com
-- --Office Code: 4
-- --Reports To: 1088
-- --Job Title: Sales Rep

INSERT INTO employees (employee_id,first_name,last_name,extension,email,office_code,reports_to,job_title)
VALUES
(15657,"Lakshmi","Roy","x4065","lakshmiroy1@lcomotors.com","4",1088,"Sales Rep");

-- --Q4) Assign the new employee to the customer whose phone is 2125557413 .

UPDATE `customers` 
SET  
customers.sales_employee_id = 15657 WHERE customers.phone = '2125557413';

-- --Q5) Write a SQL query to fetch shipped motorcycles.

SELECT *  FROM orders
LEFT JOIN orderdetails ON orders.order_id = orderdetails.order_id
LEFT JOIN products ON products.product_code = orderdetails.product_code
WHERE products.product_line = 'Motorcycles' AND orders.status = 'shipped';

-- --Q6) Write a SQL query to get details of all employees/salesmen in the office located in Sydney.

SELECT * FROM employees
LEFT JOIN offices ON employees.office_code = offices.office_code
WHERE city = 'Sydney';

SELECT employees.employee_id, employees.first_name, employees.last_name, 
employees.email, employees.extension, employees.job_title, employees.office_code 
FROM employees 
LEFT JOIN offices ON employees.office_code=offices.office_code 
WHERE offices.city="Sydney"; 

-- --Q7) How would you fetch the details of customers whose orders are in process?

SELECT products.product_code, products.product_name, products.product_scale, 
products.product_vendor, products.product_description, products.stock, 
products.buy_price, products.mrp, productlines.product_line,
productlines.description AS productline_description, 
orderdetails.quantity_ordered, orderdetails.order_id 
FROM products 
INNER JOIN productlines ON productlines.product_line=products.product_line 
INNER JOIN orderdetails ON orderdetails.product_code = products.product_code
WHERE orderdetails.quantity_ordered < 30;

-- Q9) It is noted that the payment (check number OM314933) was actually 2575. Update the record.

UPDATE payments SET payments.amount = "2575" WHERE payments.check_number = "OM314933" ;

-- --Q10) Fetch the details of salesmen/employees dealing with customers whose orders are resolved.
SELECT DISTINCT employees.employee_id, employees.first_name, employees.last_name, 
employees.email, employees.extension, employees.job_title, customers.customer_id,
orders.order_id, orders.status 
FROM  employees
INNER JOIN customers ON customers.sales_employee_id = employees.employee_id
INNER JOIN orders ON orders.customer_id = customers.customer_id
WHERE orders.status = 'Resolved';

-- --Q11) Get the details of the customer who made the maximum payment.

SELECT * FROM customers 
RIGHT JOIN payments ON customers.customer_id = payments.customer_id 
WHERE payments.amount = (SELECT MAX(amount) from payments);

-- --Q12) Fetch list of orders shipped to France.

SELECT orders.order_id, orders.order_date, orders.required_date, 
orders.shipped_date, orders.status, orders.comments , 
orders.customer_id, customers.country
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE customers.country = 'France';

-- --Q13) How many customers are from Finland who placed orders.

SELECT customers.customer_id, orders.order_id, COUNT(customers.customer_id) 
FROM customers 
LEFT JOIN orders ON orders.customer_id = customers.customer_id 
WHERE customers.country = 'Finland';

-- --Q14) Get the details of the customer who made the minimum payment.

SELECT * FROM customers
LEFT JOIN payments ON customers.customer_id = payments.customer_id 
WHERE payments.amount = (SELECT MIN(amount)FROM payments);

-- --Q15) Get the details of the customer and payments they made between May 2019 and June 2019.
SELECT * FROM customers
LEFT JOIN payments ON customers.customer_id = payments.customer_id 
WHERE payments.payment_date BETWEEN '2019-05-01' AND '2019-06-30';

SELECT customers.customer_id, customers.first_name, customers.last_name, customers.phone, 
customers.address_line1, customers.address_line2, customers.city, customers.state, 
customers.postal_code, customers.country, customers.credit_limit,payments.payment_date 
FROM customers 
LEFT JOIN payments on payments.customer_id = customers.customer_id 
WHERE payments.payment_date BETWEEN '2019-05-01' AND '2019-06-30';

-- --Q16) How many orders shipped to Belgium in 2018?

SELECT count(*) 
FROM orders 
INNER JOIN customers ON orders.customer_id = customers.customer_id 
WHERE customers.country = 'Belgium' AND orders.shipped_date BETWEEN '2019-01-01' AND '2019-12-31';

SELECT  COUNT(orders.order_id) 
FROM orders 
INNER JOIN customers ON customers.customer_id = orders.customer_id 
WHERE customers.country = "Belgium" AND orders.shipped_date BETWEEN '2019-01-01' AND '2019-12-31';


-- --Q17) Get the details of the salesman/employee with offices dealing with customers in Germany.

SELECT employees.employee_id,employees.first_name,employees.last_name,employees.extension,employees.job_title, 
employees.email,customers.customer_id,offices.office_code, offices.address_line1, offices.address_line2, 
offices.phone, offices.city, offices.state, offices.country, offices.postal_code, offices.territory 
FROM employees
CROSS JOIN offices ON  offices.office_code=employees.office_code 
LEFT JOIN customers ON customers.sales_employee_id = employees.employee_id 
WHERE customers.country = "Germany";

-- --Q18) The customer (id:496 ) made a new order today and the details are as follows:

-- --Order id : 10426
-- --Product Code: S12_3148
-- --Quantity : 41
-- --Each price : 151
-- --Order line number : 11
-- --Order date : <today’s date>
-- --Required date: <10 days from today>
-- --Status: In Process

-- -- s1)
INSERT INTO orders(order_id,order_date,required_date,status,customer_id)VALUES
(10426,current_date(),(CURRENT_DATE()+INTERVAL 10 DAY),'In Process',496);

-- -- s2)
INSERT INTO orderdetails (order_id,product_code,quantity_ordered,each_price,order_line_number) VALUES
(10426,'S12_3148',41,151,11);

-- --Q19) Fetch details of employees who were reported for the payments made by the customers between June 2018 and July 2018.

SELECT reported_emp.employee_id, reported_emp.first_name , reported_emp.last_name, reported_emp.email, 
reported_emp.job_title, reported_emp.extension , employees.employee_id AS reported_by_employee, 
customers.customer_id 
FROM employees 
INNER JOIN employees reported_emp ON reported_emp.employee_id = employees.reports_to
LEFT JOIN customers ON customers.sales_employee_id = employees.employee_id 
RIGHT JOIN payments ON payments.customer_id = customers.customer_id 
WHERE payments.payment_date BETWEEN '2018-06-01' AND '2018-07-31';

-- --Q20) A new payment was done by a customer(id: 119). Insert the below details.
-- --Check Number : OM314944
-- --Payment date : <today’s date>
-- --Amount : 33789.55

INSERT INTO payments (customer_id,check_number,payment_date,amount)
VALUES (119,'OM314944',CURRENT_DATE(),33789.55);

-- --Q21) Get the address of the office of the employees that reports to the employee whose id is 1102

SELECT offices.office_code,offices.address_line1,offices.address_line2,offices.phone, 
offices.city, offices.state, offices.country, offices.postal_code, offices.territory 
FROM employees 
INNER JOIN Employees reports_emp ON employees.employee_id = reports_emp.employee_id 
INNER JOIN offices ON offices.office_code = employees.office_code 
WHERE employees.employee_id = 1102;

-- --Q22) Get the details of the payments of classic cars.

SELECT products.product_code,products.product_line, payments.amount,
payments.check_number,payments.payment_date,payments.customer_id AS Done_by
FROM products
LEFT JOIN orderdetails ON products.product_code = orderdetails.product_code
LEFT JOIN orders ON orders.order_id = orderdetails.order_id
LEFT JOIN payments ON payments.customer_id = orders.customer_id
WHERE Products.product_line = 'Classic cars';

-- --Q23) How many customers ordered from the USA?

SELECT COUNT(*) FROM Customers
LEFT JOIN orders ON orders.customer_id = customers.customer_id
WHERE Customers.country = 'USA';

-- --Q24) Get the comments regarding resolved orders.

SELECT comments, customer_id FROM orders
WHERE status = 'Resolved'

-- --Q25) Fetch the details of employees/salesmen in the USA with office addresses.

SELECT employees.employee_id, employees.first_name ,employees.last_name, employees.email, 
employees.job_title, employees.extension,  offices.office_code, offices.address_line1, 
offices.address_line2, offices.phone, offices.city, offices.state, offices.country, 
offices.postal_code
FROM employees 
LEFT JOIN offices ON offices.office_code = employees.office_code 
WHERE offices.country = "USA";

-- --Q26) Fetch total price of each order of motorcycles. 

SELECT orderdetails.order_id,products.product_line ,products.product_name, orderdetails.product_code,
orderdetails.quantity_ordered,orderdetails.each_price,
orderdetails.quantity_ordered*orderdetails.each_price AS Total_price 
FROM orderdetails
LEFT JOIN Products ON orderdetails.product_code = products.product_code
WHERE products.product_line = 'motorcycles';

-- --Q27) Get the total worth of all planes ordered.
SELECT SUM(orderdetails.quantity_ordered*orderdetails.each_price)AS Total_price 
FROM orderdetails 
INNER JOIN products ON products.product_code = orderdetails.product_code
WHERE products.product_line = "Planes";

-- --Q28) How many customers belong to France?

SELECT COUNT(*) from customers WHERE customers.country = 'France';

-- --Q29) Get the payments of customers living in France.

SELECT customers.customer_id, customers.first_name, customers.last_name, customers.phone, 
customers.address_line1, customers.address_line2, customers.city, customers.state, 
customers.postal_code, customers.country, customers.credit_limit, 
payments.payment_date, payments.amount, payments.check_number  
FROM customers 
INNER JOIN payments ON customers.customer_id = payments.customer_id
WHERE customers.country = 'France';

-- --Q30) Get the office address of the employees/salesmen who report to employee 1143.

SELECT DISTINCT offices.office_code, offices.address_line1, 
offices.address_line2, offices.phone, offices.city, offices.state, offices.country, 
offices.postal_code,employees.employee_id
FROM employees 
LEFT JOIN offices ON offices.office_code = employees.office_code
WHERE employees.reports_to = 1143;


