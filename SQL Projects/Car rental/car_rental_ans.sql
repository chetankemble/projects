use lco_car_rentals;
select * from rental;

select * from customer
-- --Q1) Insert the details of new customer:-
INSERT INTO customer(first_name,last_name,dob,driver_license_number,email) 
VALUES('Nancy','Perry','1988-05-16','K59042656E','nancy@gmail.com');

-- --Q2) The new customer (inserted above) wants to rent a car from 2020-08-25 to 2020-08-30. More details are as follows:
INSERT INTO `rental` (`start_date`,`end_date`,`customer_id`,`vehicle_type_id`,`fuel_option_id`,`pickup_location_id`,`drop_off_location_id`)
VALUES('2020-08-25','2020-08-30',
(select customer.id from customer where customer.driver_license_number = "K59042656E" ),
(SELECT vehicle_type.id FROM vehicle_type WHERE vehicle_type.name="Economy SUV"),
(SELECT fuel_option.id from fuel_option where fuel_option.name ="Market" ),
(SELECT location.id from location where  location.zipcode =60638),
(SELECT location.id  from location where  location.zipcode =90045));

-- --Q3) The customer with the driving license W045654959 changed his/her drop off location to 1001 Henderson St,  Fort Worth, TX, zip - 76102  and 
-- --wants to extend the rental upto 4 more days. Update the record.


UPDATE rental INNER JOIN customer on customer.id = rental.customer_id 
SET drop_off_location_id = (SELECT location.id from location WHERE location.zipcode = 76102),
end_date =(SELECT end_date+INTERVAL 4 DAY) WHERE Customer.driver_license_number = "W045654959"

-- --Q4) Fetch all rental details with their equipment type.
SELECT CONCAT(Customer.first_name," ",Customer.last_name) AS Customer_name,Customer.driver_license_number,rental.start_date,
rental.end_date,vehicle_type.name,fuel_option.name,CONCAT(pick_location.street_address,",",pick_location.city,",",pick_location.state,",",
pick_location.zipcode)AS pick_location,CONCAT(drop_location.street_address,",",drop_location.city,",",drop_location.state,",",
drop_location.zipcode)AS drop_location,equipment_type.name AS equipment_type
FROM rental 
INNER JOIN customer on customer.id = rental.customer_id
INNER JOIN vehicle_type on vehicle_type.id = rental.vehicle_type_id
INNER JOIN fuel_option on fuel_option.id = rental.fuel_option_id
INNER JOIN location pick_location on pick_location.id = rental.pickup_location_id
INNER JOIN location drop_location on drop_location.id = rental.drop_off_location_id
INNER JOIN rental_has_equipment_type on rental_has_equipment_type.rental_id=rental.id 
INNER JOIN equipment_type on equipment_type.id = rental_has_equipment_type.equipment_type_id;

-- --Q5) Fetch all details of vehicles.
SELECT vehicle.id,vehicle.brand,vehicle.model,vehicle.model_year,vehicle.mileage,vehicle.color,
vehicle_type.name AS vehicle_type, CONCAT(location.street_address,",",location.city,",",location.state,",",
location.zipcode) AS current_location 
FROM vehicle 
INNER JOIN vehicle_type on vehicle.vehicle_type_id= vehicle_type.id
INNER JOIN location on location.id=vehicle.current_location_id;

-- --Q6) Get driving license of the customer with most rental insurances.
SELECT CONCAT(customer.first_name," ",customer.last_name)AS customer_name,customer.driver_license_number, 
COUNT(rental_has_insurance.rental_id)AS NUMBER_OF_INSURANCE
FROM customer 
INNER JOIN rental on customer.id=rental.customer_id
INNER JOIN rental_has_insurance on rental_has_insurance.rental_id= rental.id
INNER JOIN insurance on insurance.id = rental_has_insurance.insurance_id
 GROUP BY rental_has_insurance.rental_id 
 ORDER BY 3 
 DESC LIMIT 1;

 SELECT customer.driver_license_number, COUNT(rental_has_insurance.rental_id) AS number_of_insurance 
 FROM customer 
 LEFT JOIN rental ON rental.customer_id = customer.id 
 LEFT JOIN rental_has_insurance ON rental_has_insurance.rental_id = rental.id 
 GROUP BY rental_has_insurance.rental_id 
 ORDER BY COUNT(rental_has_insurance.rental_id) 
 DESC LIMIT 1;
 
--  --Q7) Insert a new equipment type with following details.
-- --Name : Mini TV
-- --Rental Value : 8.99

INSERT INTO equipment_type(name, rental_value) VALUES ("Mini TV" , 8.99);

-- --Q8) Insert a new equipment with following details:
-- --Name : Garmin Mini TV
-- --Equipment type : Mini TV
-- --Current Location zip code : 60638
INSERT INTO equipment (name,equipment_type_id,current_location_id)
VALUES ("Garmin Mini TV",(select equipment_type.id from equipment_type where equipment_type.name="Mini TV"),
(SELECT location.id from location where location.zipcode = 60638));

-- --Q9) Fetch rental invoice for customer (email: smacias3@amazonaws.com). 
SELECT rental_invoice.id,rental_invoice.car_rent,rental_invoice.equipment_rent_total,rental_invoice.insurance_cost_total,
rental_invoice.tax_surcharges_and_fees,rental_invoice.total_amount_payable,rental_invoice.discount_amount,rental_invoice.net_amount_payable,
rental_invoice.rental_id,customer.id 
FROM rental_invoice 
LEFT JOIN rental on rental_invoice.rental_id = rental.id
LEFT JOIN customer on rental.customer_id = customer.id
WHERE customer.email= "smacias3@amazonaws.com";


-- --Q10) Insert the invoice for customer (driving license:K59042656E ) with following details:-
-- --Car Rent : 785.4
-- --Equipment Rent : 114.65
-- --Insurance Cost : 688.2
-- --Tax : 26.2
-- --Total: 1614.45
-- --Discount : 213.25
-- --Net Amount: 1401.2

INSERT INTO rental_invoice(car_rent,equipment_rent_total,insurance_cost_total,tax_surcharges_and_fees,
total_amount_payable,discount_amount,net_amount_payable,rental_id) 
VALUES (785.4,114.65,688.2,26.2,1614.45,213.25,1401.2,
(SELECT rental.id from rental 
INNER JOIN Customer on customer.id = rental.customer_id
WHERE customer.driver_license_number= "K59042656E"))


-- --Q11) Which rental has the most number of equipment.

SELECT rental_has_equipment_type.rental_id,count(rental_has_equipment_type.equipment_type_id)as number_of_equipment_type
FROM rental_has_equipment_type
INNER JOIN rental ON rental.id = rental_has_equipment_type.rental_id
group by rental_has_equipment_type.rental_id
order by 2 desc limit 1;

SELECT rental_has_equipment_type.rental_id,  
COUNT(rental_has_equipment_type.rental_id) as number_of_equipment_type 
FROM rental_has_equipment_type 
GROUP BY rental_has_equipment_type.rental_id 
ORDER BY COUNT( rental_has_equipment_type.rental_id) DESC LIMIT 1;

-- --Q12) Get driving license of a customer with least number of rental licenses.

select customer.driver_license_number,count(rental_has_insurance.rental_id)AS number_of_insurance
FROM customer 
LEFT JOIN rental ON rental.customer_id = customer.id 
LEFT JOIN rental_has_insurance ON rental_has_insurance.rental_id = rental.id 
group by 1
order by 2 asc limit 1;

-- --Q13) Insert new location with following details.
-- --Street address : 1460  Thomas Street
-- --City : Burr Ridge , State : IL, Zip - 61257

INSERT INTO location (street_address,city,state,zipcode) VALUES
("1460  Thomas Street","Burr Ridge","IL","61257")

-- --Q14) Add the new vehicle with following details:-
-- --Brand: Tata 
-- --Model: Nexon
-- --Model Year : 2020
-- --Mileage: 17000
-- --Color: Blue
-- --Vehicle Type: Economy SUV 
-- --Current Location Zip: 20011 

INSERT INTO vehicle (brand,model,model_year,mileage,color,vehicle_type_id,current_location_id)
VALUES
("Tata","Nexon","2020",17000,"Blue",(SELECT vehicle_type.id from vehicle_type WHERE Vehicle_type.name = "Economy SUV"), 
(SELECT location.id from location WHERE location.zipcode = 20011) );

-- --Q15) Insert new vehicle type Hatchback and rental value: 33.88.
INSERT INTO vehicle_type(name,rental_value)
VALUES ("Hatchback",33.88);

-- --Q16) Add new fuel option Pre-paid (refunded).
INSERT INTO fuel_option(name,description)
VALUES("Pre-paid","Customer buy a tank of fuel at pick-up and get refunded the amount customer don’t use.")

-- --Q17) Assign the insurance : Cover My Belongings (PEP), 
-- --Cover The Car (LDW) to the rental started on 25-08-2020 (created in Q2) by customer (Driving License:K59042656E).

INSERT INTO rental_has_insurance (rental_id,insurance_id)
VALUES((SELECT rental.id from rental 
INNER JOIN Customer on customer.id=rental.customer_id 
where rental.start_date="2020-08-25" AND  customer.driver_license_number="K59042656E"),
(SELECT insurance.id FROM insurance WHERE insurance.name ="Cover My Belongings (PEP)")),
((SELECT rental.id from rental 
INNER JOIN Customer on customer.id=rental.customer_id 
where rental.start_date="2020-08-25" AND  customer.driver_license_number="K59042656E"),
(SELECT insurance.id FROM insurance WHERE insurance.name ="Cover The Car (LDW)"));

-- --Q18) Remove equipment_type :Satellite Radio from rental started on 2018-07-14 and ended on 2018-07-23.

DELETE FROM rental_has_equipment_type 
WHERE rental_has_equipment_type.rental_id = (SELECT rental.id FROM rental WHERE rental.start_date= "2018-07-14" and rental.end_date = "2018-07-23") AND
rental_has_equipment_type.equipment_type_id = (SELECT equipment_type.id FROM equipment_type WHERE equipment_type.name ="Satellite Radio" );

-- --Q19) Update phone to 510-624-4188 of customer (Driving License: K59042656E).

UPDATE customer  SET phone = 510-624-4188 WHERE Customer.driver_license_number = "K59042656E";

-- --Q20) Increase the insurance cost of Cover The Car (LDW) by 5.65.

UPDATE insurance SET insurance.cost = (SELECT cost+5.65) WHERE insurance.name = "Cover The Car (LDW)";

-- --Q21) Increase the rental value of all equipment types by 11.25.

UPDATE equipment_type SET rental_value = (SELECT rental_value+11.25);

-- --Q22) Increase the  cost of all rental insurances except Cover The Car (LDW) by twice the current cost.

UPDATE insurance SET insurance.cost = (SELECT cost*2) WHERE insurance.name != "Cover The Car (LDW)";

-- --Q23) Fetch the maximum net amount of invoice generated.

SELECT max(net_amount_payable) FROM  rental_invoice;

-- --Q24) Update the dob of customer with driving license V435899293 to 1977-06-22.

UPDATE customer SET dob = "1977-06-22" WHERE customer.driver_license_number = "V435899293";

-- --Q25)  Insert new location with following details.
-- --Street address : 468  Jett Lane
-- --City : Gardena , State : CA, Zip - 90248

INSERT INTO `location`(street_address,city,`state`,zipcode) 
VALUES ("468  Jett Lane","Gardena","CA",90248);

-- --Q26) The new customer (Driving license: W045654959) wants to rent a car from 2020-09-15 to 2020-10-02. More details are as follows: 
-- --Vehicle Type : Hatchback
-- --Fuel Option : Pre-paid (refunded)
-- --Pick Up location:  468  Jett Lane , Gardena , CA, zip- 90248
-- --Drop Location: 5911 Blair Rd NW, Washington, DC, zip - 20011

INSERT INTO rental (start_date,end_date,customer_id,vehicle_type_id,fuel_option_id,pickup_location_id,drop_off_location_id)
VALUES ("2020-09-15","2020-10-02",
(SELECT Customer.id FROM customer WHERE customer.driver_license_number ="W045654959" ),
(SELECT vehicle_type.id FROM vehicle_type WHERE vehicle_type.name= "Hatchback"),
(SELECT fuel_option.id FROM fuel_option WHERE fuel_option.name = "Pre-paid"),
(SELECT location.id FROM location WHERE location.zipcode = 90248),
(SELECT location.id FROM location WHERE location.zipcode = 20011)); 

select * from fuel_option

-- --Q27) Replace the driving license of the customer (Driving License: G055017319) with new one K16046265.

UPDATE Customer SET customer.driver_license_number = "K16046265" WHERE customer.driver_license_number = "G055017319";

-- --Q28) Calculated the total sum of all insurance costs of all rentals.

SELECT sum(insurance.cost) AS TOTAL_INSURANCE_COST
FROM rental_has_insurance 
INNER JOIN insurance ON insurance.id = rental_has_insurance.insurance_id;

-- --Q29) How much discount we gave to customers in total in the rental invoice?

SELECT SUM(rental_invoice.discount_amount) from rental_invoice ;

-- --Q30) The Nissan Versa has been repainted to black. Update the record.

UPDATE vehicle SET vehicle.color = 'black' WHERE vehicle.brand = 'Nissan';


