-- ============================================================
-- EMPLOYEE PAYROLL JDBC APPLICATION
-- schema.sql
-- ============================================================

-- ============================================================
-- DROP EXISTING OBJECTS
-- ============================================================

DROP TRIGGER IF EXISTS trg_log_salary_change ON employees;
DROP FUNCTION IF EXISTS log_salary_change();
DROP FUNCTION IF EXISTS get_total_payroll_by_dept(VARCHAR);
DROP TABLE IF EXISTS payroll_audit;
DROP TABLE IF EXISTS employee_departments;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS users;

-- ============================================================
-- USERS TABLE
-- ============================================================

CREATE TABLE users
(
    id SERIAL PRIMARY KEY,

    username VARCHAR(50) UNIQUE NOT NULL,

    password VARCHAR(64) NOT NULL,

    email VARCHAR(100) UNIQUE NOT NULL,

    role VARCHAR(20)
        CHECK(role IN ('ADMIN','USER'))
                                NOT NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- EMPLOYEES TABLE
-- ============================================================

CREATE TABLE employees
(
    id SERIAL PRIMARY KEY,

    name VARCHAR(100) NOT NULL,

    profile_image VARCHAR(100) NOT NULL,

    gender VARCHAR(10)
        CHECK(gender IN ('Male','Female'))
        NOT NULL,

    salary NUMERIC(10,2)
        CHECK(salary >=0)
        NOT NULL,

    start_date DATE NOT NULL,

    notes TEXT,

    created_by INTEGER
        REFERENCES users(id)
                          ON DELETE SET NULL,

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- EMPLOYEE DEPARTMENTS
-- ============================================================

CREATE TABLE employee_departments
(
    employee_id INTEGER
        REFERENCES employees(id)
            ON DELETE CASCADE,

    department VARCHAR(50) NOT NULL,

    PRIMARY KEY(employee_id,department)
);

-- ============================================================
-- PAYROLL AUDIT TABLE
-- ============================================================

CREATE TABLE payroll_audit
(
    id SERIAL PRIMARY KEY,
    employee_id INTEGER NOT NULL,
    action_type VARCHAR(10) NOT NULL,
    old_salary NUMERIC(10,2),
    new_salary NUMERIC(10,2),
    changed_by VARCHAR(50),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- INDEXES
-- ============================================================

CREATE UNIQUE INDEX idx_users_username
    ON users(username);

CREATE INDEX idx_emp_dept_id
    ON employee_departments(employee_id);

-- ============================================================
-- STORED FUNCTION
-- ============================================================

CREATE OR REPLACE FUNCTION
get_total_payroll_by_dept
(
    p_dept VARCHAR
)

RETURNS NUMERIC

AS
$$

BEGIN

RETURN
    (
        SELECT
            COALESCE(SUM(salary),0)

        FROM employees e

                 JOIN employee_departments d

                      ON e.id=d.employee_id

        WHERE d.department=p_dept
    );

END;

$$

LANGUAGE plpgsql;

-- ============================================================
-- AUDIT FUNCTION
-- ============================================================

CREATE OR REPLACE FUNCTION
log_salary_change()

RETURNS TRIGGER

AS
$$

DECLARE

v_user VARCHAR(50);

BEGIN

---------------------------------------------------
-- INSERT
---------------------------------------------------

IF(TG_OP='INSERT')
THEN

SELECT username
INTO v_user
FROM users
WHERE id=NEW.created_by;

INSERT INTO payroll_audit
(
    employee_id,
    action_type,
    old_salary,
    new_salary,
    changed_by
)

VALUES
    (
        NEW.id,
        'INSERT',
        NULL,
        NEW.salary,
        COALESCE(v_user,'UNKNOWN')
    );

RETURN NEW;

---------------------------------------------------
-- UPDATE
---------------------------------------------------

ELSIF(TG_OP='UPDATE')
THEN

IF OLD.salary<>NEW.salary
THEN

SELECT username
INTO v_user
FROM users
WHERE id=NEW.created_by;

INSERT INTO payroll_audit
(
    employee_id,
    action_type,
    old_salary,
    new_salary,
    changed_by
)

VALUES
    (
        NEW.id,
        'UPDATE',
        OLD.salary,
        NEW.salary,
        COALESCE(v_user,'UNKNOWN')
    );

END IF;

RETURN NEW;

---------------------------------------------------
-- DELETE
---------------------------------------------------

ELSIF(TG_OP='DELETE')
THEN

SELECT username
INTO v_user
FROM users
WHERE id=OLD.created_by;

INSERT INTO payroll_audit
(
    employee_id,
    action_type,
    old_salary,
    new_salary,
    changed_by
)

VALUES
    (
        OLD.id,
        'DELETE',
        OLD.salary,
        NULL,
        COALESCE(v_user,'UNKNOWN')
    );

RETURN OLD;

END IF;

RETURN NULL;

END;

$$

LANGUAGE plpgsql;

-- ============================================================
-- TRIGGER
-- ============================================================

CREATE TRIGGER trg_log_salary_change

    AFTER INSERT
        OR UPDATE
               OR DELETE

           ON employees

               FOR EACH ROW

               EXECUTE FUNCTION log_salary_change();

-- ============================================================
-- SEED DATA
-- ============================================================

-- admin
-- password = admin

INSERT INTO users
(
    username,
    password,
    email,
    role
)

VALUES
    (
        'Aman',
        '5d7e4e5b8dca9a9ac4575654ff707580a1aad73c27c02ae56b780bd32758c822',
        'aman@gmail.com',
        'ADMIN'
    );

-- user
-- password = user

INSERT INTO users
(
    username,
    password,
    email,
    role
)

VALUES
    (
        'user',
        '04f8996da763b7a969b1028ee3007569eaf3a635486ddab211d512c85b9df8fb',
        'user@gmail.com',
        'USER'
    );

-- ============================================================
-- SAMPLE EMPLOYEE
-- ============================================================

INSERT INTO employees
(
    name,
    profile_image,
    gender,
    salary,
    start_date,
    notes,
    created_by
)

VALUES
    (
        'Amarpa Keerthi Kumar',
        'ellipse-1.png',
        'Female',
        10000,
        '2019-10-29',
        'Senior specialist account manager.',
        1
    );

INSERT INTO employee_departments
VALUES
    (1,'Sales'),
    (1,'HR'),
    (1,'Finance');