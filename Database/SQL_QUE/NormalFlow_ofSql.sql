--create a table name car with column
create table Car(
  id int Primary key,
  brand varchar(50),
  model varchar(50),
  year int
);
--Insert values on column
Insert Into Car(id,brand, model, year)
values(1,'Volvo', 'XC60', 2018),
       (2,'Volvo', 'EM90',2024),
	   (3,'BMW', 'M1', 1978),
	   (4,'Ford', 'Mustang', 1964);
Insert Into Car(id,brand, model, year)
values(5,'ola', 'Xyz', 2016);

--here i see my table 
select * from car;

select brand,model from car where year >=1;

--add two column using alter
Alter Table car 
add color varchar(20),
add car_size varchar(20);

--give values to new column
update car
set color = 'black',car_size='5206mm'
where id = 1;

update car
set color = 'silver',car_size='4708mm'
where id = 2;

update car
set color = 'white',car_size='4361mm'
where id = 3;

update car
set color = 'blue',car_size='4810'
where id = 4;

update car
set color = 'yellow',car_size='1859'
where id = 5;

--change existing brand
update car
set brand='Tata',model='EV'
where id = 1;

--delete column using Drop with Alter
Alter table car 
Drop column car_size;

--delete row 
Delete from car
where id = 5;

select * from car
where brand <> 'Volvo';

select * from car 
where model like 'M%';

select * from car
where color like '%l%';

select * from car
where color like '_l%';


