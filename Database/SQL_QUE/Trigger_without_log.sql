-- this is for without log table , just showiing message using "Raise notice".
 

--create table 
create table Patient(
  p_id serial primary key,
  p_name varchar(20),
  p_age int,
  p_city varchar(10)
);

create or replace function patient_change()
RETURNS TRIGGER
AS $$
BEGIN
--RAISE NOTICE 'Student Added'; 
--RETURN NEW; 
IF TG_OP = 'INSERT' THEN 
  RAISE NOTICE 'Patient Inserted: %', NEW.p_name;
ELSIF TG_OP = 'UPDATE' THEN 
  RAISE NOTICE 'Patient Updated: %', NEW.p_name; 
ELSIF TG_OP = 'DELETE' THEN 
  RAISE NOTICE 'Patient Deleted: %', OLD.p_name; 
END IF; 

Return null;
END; 
$$ 
LANGUAGE plpgsql; 

--create trigger
CREATE TRIGGER patient_trigger 
AFTER INSERT OR UPDATE OR DELETE 
ON patient 
FOR EACH ROW 
EXECUTE FUNCTION patient_change();

INSERT INTO Patient(p_name, p_age, p_city)
VALUES
('Aman', 22, 'Delhi'),
('Rahul', 25, 'Noida'),
('Priya', 21, 'Agra'),
('Neha', 24, 'Kanpur');

-- Update one Patient

UPDATE Patient
SET p_age = 23
WHERE p_name = 'Aman';

-- Delete one Patient

DELETE FROM Patient
WHERE p_name = 'Rahul';

select * from Patient;