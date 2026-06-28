-- stored Procedure based 

Drop table if exists employees;
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(50),
    salary INT
);

--CREATE A Stored Procedure for add patient with if-else
-- and apply insert , update , delete in single procedure.
Create or Replace Procedure add_employee(
    operation varchar(10),
    p_id int,
	p_name varchar(50),
	p_salary int
)
Language plpgsql
AS $$
BEGIN
  IF operation = 'Insert' then
  
    IF p_salary > 0 THEN
        INSERT INTO employees (
            emp_id,
            emp_name,
            salary
        )
        VALUES (
            p_id,
            p_name,
            p_salary
        );
        RAISE NOTICE 'Employee Added Successfully';
    ELSE
        RAISE NOTICE 'Invalid-->Salary must be greater than 0';
	END IF;
	
  ELSIF  operation = 'Update' then
      update employees
	  SET salary = p_salary
	  WHERE emp_id = p_id;

	  RAISE NOTICE 'Employee Updated Successfully';

  ELSIF  operation = 'Delete' then 
      Delete from employees
	  where emp_id = p_id;

	   RAISE NOTICE 'Employee Deleted Successfully';
  ELSE 
      RAISE NOTICE 'Invalid operation';
	  
  END IF;
END;
$$;

-- called using call with procedure name , attach with values
CALL add_employee('Insert', 1, 'Aman', 50000);
CALL add_employee('Insert', 2, 'Rahul', 60000);
CALL add_employee('Insert', 3, 'Rohit', 70000);
CALL add_employee('Insert', 4, 'Rohan', -1000);

Call add_employee('Update',3, 'Rohan',70000);

Call add_employee('Delete',3,null, null);
select * from employees;