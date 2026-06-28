-- JOINS

--FRIST TABLE
CREATE TABLE depts (
dept_id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL
);
--Second table
CREATE TABLE emps (
emp_id SERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL,
dept_id INT REFERENCES depts(dept_id), --foreign key concept
manager_id INT -- References emp_id for Self Join
);

INSERT INTO depts (name) 
VALUES ('Engineering'), ('HR'), ('Marketing');

INSERT INTO emps (name, dept_id, manager_id) VALUES 
('Kiran', 1, NULL),  -- Kiran is Manager
('Amit', 1, 1),      -- Amit reports to Kiran
('Priya', 2, NULL),   -- Priya is HR Manager
('Raj', NULL, NULL); -- Raj has no Department


select * from depts;
select * from emps;

-- ═══ 1. INNER JOIN ══════════════════════════════════════════════════
SELECT e.name AS employee, d.name AS department
FROM emps e
INNER JOIN depts d ON e.dept_id = d.dept_id;

-- ═══ 2. LEFT JOIN ═══════════════════════════════════════════════════-- Returns all employees, even if they have no department assigned (e.g. Raj).
SELECT e.name AS employee, COALESCE(d.name, 'No Department') AS department
FROM emps e
LEFT JOIN depts d ON e.dept_id = d.dept_id;

-- ═══ 3. RIGHT JOIN ══════════════════════════════════════════════════-- Returns all departments, even if they have no employees assigned 
SELECT e.name AS employee, d.name AS department
FROM emps e
RIGHT JOIN depts d ON e.dept_id = d.dept_id;

-- ═══ 4. SELF JOIN ═══════════════════════════════════════════════════-- Join table with itself to map hierarchical structures (Employee to Manager).
SELECT emp.name AS employee, mgr.name AS manager
FROM emps emp
LEFT JOIN emps mgr ON emp.manager_id = mgr.emp_id;