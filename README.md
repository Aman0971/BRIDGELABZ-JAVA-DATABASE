# BRIDGELABZ-JAVA-DATABASE

# Java Backend Training Repository

This repository contains my Java Backend training projects, covering Core Java, JDBC, SQL, Spring JDBC Template, and Database concepts. Each folder represents a separate project or practice module completed during the learning process.

---

## Repository Structure

```
.
├── greeting-jdbc-app/
│   ├── src/
│   ├── schema.sql
│   └── .gitignore
│
├── GreetingJDBC_Template/
│   ├── src/
│   │   ├── main/java/
│   │   ├── resources/
│   │   └── test/java/
│   ├── pom.xml
│   ├── application.properties
│   ├── schema.sql
│   └── .gitignore
│
├── Employee_PayRoll/
│   ├── src/
│   ├── payroll/
│   ├── model/
│   ├── util/
│   ├── PayrollApp.java
│   └── schema.sql
│
├── SQL_QUE/
│   ├── Joins.sql
│   ├── NormalFlow_ofSql.sql
│   ├── Practice_sqlProblem.sql
│   ├── Stored_Procedure.sql
│   └── Trigger_with_logfile.sql
│
├── Product_Order_View.sql
├── employee_payroll_schema.sql
├── greeting-schema.sql
└── README.md
```

---

# Projects Included

## 1. Greeting JDBC App

A Core Java + JDBC application that demonstrates CRUD operations using JDBC.

### Features

* JDBC Connection
* Insert Greeting
* Update Greeting
* Delete Greeting
* Fetch Greeting
* SQL Schema

**Technology Used**

* Java
* JDBC
* MySQL
* Maven

---

## 2. Greeting JDBC Template

A Spring JDBC Template based application that simplifies database operations.

### Features

* Spring JDBC Template
* CRUD Operations
* Repository Pattern
* Configuration using `AppConfig`
* Password Hash Utility
* User Management
* Greeting Management

**Packages**

* config
* model
* repository
* util

**Technology Used**

* Java
* Spring Framework
* Spring JDBC Template
* Maven
* MySQL

---

## 3. Employee Payroll

A Java application to manage employee payroll information.

### Features

* Employee Model
* User Model
* Payroll Utility
* Database Integration
* Employee CRUD Operations

---

## 4. SQL Practice

Collection of SQL scripts covering important database concepts.

### Topics Covered

* SQL Basics
* Joins
* Aggregate Functions
* GROUP BY
* HAVING
* Subqueries
* Views
* Stored Procedures
* Triggers
* Practice Problems

Files

* `Joins.sql`
* `NormalFlow_ofSql.sql`
* `Practice_sqlProblem.sql`
* `Stored_Procedure.sql`
* `Trigger_with_logfile.sql`
* `Trigger_without_log.sql`

---

## Database Schemas

This repository also contains database schema files.

* `schema.sql`
* `employee_payroll_schema.sql`
* `greeting-schema.sql`

These scripts can be executed before running the applications.

---

# Technologies Used

* Java
* JDBC
* Spring Framework
* Spring JDBC Template
* Maven
* MySQL
* SQL

---

# How to Run

### Clone Repository

```bash
git clone <repository-url>
```

### Navigate to Project

```bash
cd GreetingJDBC_Template
```

or

```bash
cd greeting-jdbc-app
```

### Configure Database

1. Create MySQL database.
2. Execute the required `schema.sql`.
3. Update database credentials in `application.properties` (Spring project) or JDBC configuration.

### Build Project

```bash
mvn clean install
```

### Run Application

```bash
mvn exec:java
```

or run the main class from your IDE.

---

# Learning Objectives

This repository demonstrates practical implementation of:

* Core Java
* Object-Oriented Programming
* JDBC
* Spring JDBC Template
* Repository Pattern
* SQL Queries
* Stored Procedures
* Triggers
* Database Design
* CRUD Operations

---

# Author

**Aman Chaudhary**

Java Backend Developer (Learning Phase)

---

## License

This repository is maintained for learning and educational purposes.
