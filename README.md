# Doctor Appointment & Medicine Order System

## Project Overview

The Doctor Appointment & Medicine Order System is a SQL-based healthcare management project designed to simulate real-world hospital and clinic operations.

The system manages patients, doctors, appointments, prescriptions, medicine orders, billing, and reporting through a relational database model. The project demonstrates database design, SQL querying, business analytics, and data management concepts commonly used in healthcare applications.

---

## Business Problem

Healthcare providers need a centralized system to:

* Manage patient information
* Schedule doctor appointments
* Maintain doctor availability
* Track prescriptions
* Process medicine orders
* Generate operational and business reports

This project models these workflows using SQL databases and analytical queries.

---

## Key Features

### Patient Management

* Store patient details
* Maintain patient history
* Track demographics

### Doctor Management

* Manage doctor information
* Store specialization details
* Track appointment schedules

### Appointment Management

* Book appointments
* Track appointment status
* Monitor doctor utilization

### Prescription Management

* Record prescribed medicines
* Maintain treatment history

### Medicine Order Management

* Process medicine purchases
* Track ordered quantities
* Generate order summaries

### Billing & Reporting

* Appointment revenue analysis
* Patient visit statistics
* Medicine sales reports
* Doctor performance metrics

---

## Database Design

### Core Entities

* Patients
* Doctors
* Appointments
* Prescriptions
* Medicines
* Orders
* Billing

### Relationships

```text
Patient
   │
   ├── Appointments
   │        │
   │        └── Doctor
   │
   └── Prescriptions
              │
              └── Medicines
                        │
                        └── Orders
```

---

## Project Structure

```text
doctor-appointment-medicine-order-system/
│
├── README.md
│
├── schema/
│   ├── create_tables.sql
│   ├── constraints.sql
│   └── indexes.sql
│
├── data/
│   ├── sample_data.sql
│   └── test_data.sql
│
├── queries/
│   ├── exploratory_analysis.sql
│   ├── business_kpis.sql
│   ├── appointment_analysis.sql
│   ├── medicine_sales_analysis.sql
│   └── advanced_queries.sql
│
├── outputs/
│   └── screenshots/
│
└── docs/
    └── data_model.png
```

---

## SQL Concepts Demonstrated

### Database Design

* Primary Keys
* Foreign Keys
* Constraints
* Normalization

### Querying

* Joins
* Subqueries
* Common Table Expressions (CTEs)
* Window Functions

### Analytics

* Aggregations
* Ranking Functions
* Running Totals
* KPI Calculations

### Optimization

* Indexing
* Query Performance Tuning

---

## Sample Business Questions Solved

* Which doctors handle the highest number of appointments?
* What are the most prescribed medicines?
* Which patients visit most frequently?
* What is the monthly appointment trend?
* Which medicines generate the highest revenue?
* What is the average number of appointments per doctor?
* Which specialties receive the most appointments?

---

## Technologies Used

* SQL
* Relational Database Concepts
* Data Modeling
* Business Analytics

---

## Learning Outcomes

Through this project, I gained hands-on experience in:

* Relational database design
* SQL query development
* Healthcare data modeling
* Business reporting
* Analytical query writing
* Performance optimization

---

## Future Enhancements

* Inventory Management
* Pharmacy Stock Tracking
* Patient Feedback Module
* Dashboard Integration (Power BI / Tableau)
* Appointment Notifications
* Data Warehouse Integration

---

## Author

Data Engineering Portfolio Project demonstrating SQL database design, healthcare domain modeling, and analytical reporting capabilities.
