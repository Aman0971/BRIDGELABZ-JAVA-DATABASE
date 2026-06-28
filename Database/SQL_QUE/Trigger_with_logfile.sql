--IN THIS senario we maintain our log file , with actual table
-- so that's why we have to create log table and in trigger function we have to write insert into in log file

--create student table
DROP TABLE IF EXISTS profile_log;
DROP TABLE IF EXISTS profile;
DROP FUNCTION IF EXISTS profile_change();

create table Profile(
std_id serial primary key,
std_name varchar(20),
std_age int,
course varchar(20)
);

--create log table(for maintaining history)
create table profile_log(
 log_id  serial primary key,
 action varchar(20),
 std_name varchar(20)
);

--create trigger function
create OR REPLACE FUNCTION profile_change()
RETURNS  TRIGGER
AS $$ 
BEGIN
IF TG_OP = 'INSERT' THEN
  Insert into profile_log(action,std_name)
  values('Insert',NEW.std_name);
  Return new;
elsif TG_OP = 'UPDATE' then
  Insert into profile_log(action,std_name)
  values('Update',NEW.std_name);
  return new;
elsif TG_OP = 'DELETE' then
  Insert into profile_log(action,std_name)
  values('Delete',OLD.std_name);
  return old;
end if;

Return null;
END;
$$
LANGUAGE plpgsql;

--create trigger
create trigger profile_trigger
After insert or delete OR update
on profile
for each row
execute function profile_change();

--insert data into table
Insert into profile(std_name, std_age, course)
values('Aman',20,'Betch'),
('Rahul', 21, 'BCA'),
('Priya', 20, 'B.Sc');


UPDATE profile
SET std_age = 23
WHERE std_id = 1;

DELETE FROM profile
WHERE std_name = 'Rahul';

Select * from profile;
Select * from profile_log;