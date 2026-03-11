# SQL Data Warehouse Project

This project implements a **Data Warehouse built entirely using SQL** following the **Medallion Architecture** pattern.  
The warehouse processes data from **CSV source files** and organizes it into three logical layers: **Bronze, Silver, and Gold**.

The goal of this architecture is to progressively **improve data quality and structure** as it moves through the pipeline, starting from raw ingestion to analytical-ready datasets.

---

# Architecture Overview

The data warehouse is divided into **three layers**:

- **Bronze Layer** → Raw data ingestion  
- **Silver Layer** → Data cleaning and transformation  
- **Gold Layer** → Business-ready analytical model  

Data originates from **CSV files**, is loaded into the Bronze layer, then transformed and refined through Silver, and finally exposed in Gold as analytical views.

---

# Script Execution Flow

## 1. Bronze Layer

The Bronze layer contains the **raw ingested data exactly as received from the source CSV files**.

### Scripts

**init_tables.sql**  
Creates all Bronze layer tables.

**load_bronze.sql**  
A stored procedure responsible for loading data from the CSV files into the Bronze tables.

**create_job.sql**  
Creates a scheduled job to execute the **load_bronze** procedure automatically.

### Behavior

All Bronze tables are **truncated and reloaded on each job execution**.

---

## 2. Silver Layer

The Silver layer is responsible for **data transformation, cleaning, and standardization** before the data becomes ready for analytics.

### Scripts

**init_tables.sql**  
Creates all Silver layer tables.

**load_silver.sql**  
Transforms and cleans the data from the Bronze layer before loading it into the Silver tables.

**create_job.sql**  
Creates a scheduled job to execute the **load_silver** procedure.

### Notes

- All transformations and cleaning logic are implemented **within a single script**.
- Similar to Bronze, the Silver tables are **truncated and reloaded during each execution**.

---

## 3. Gold Layer

The Gold layer contains the **analytical data model** used for reporting and analytics.

In this project, the Gold layer is implemented using **views built from Silver tables**.

### Script

**proc_view_gold.sql**

This script:

- Drops existing views if they exist
- Recreates all analytical views
- Builds the final **data model for analytics**

### Execution Behavior

Unlike Bronze and Silver:

- Gold objects are **views only**
- Views are **dropped and recreated**
- The script is executed **once during initial setup**
- **No scheduled job is used for the Gold layer**

---

# Data Loading Strategy

Current loading approach:

- Bronze tables → **TRUNCATE + INSERT**
- Silver tables → **TRUNCATE + INSERT**
- Gold views → **DROP + CREATE**

This approach keeps the pipeline **simple and deterministic** during development.

---

# Documentation

A **documentation folder** is included in the repository containing:

### 1. Data Warehouse Layer Specifications

Detailed explanation of the **Bronze, Silver, and Gold layers** and their responsibilities.

### 2. Naming Convention Rules

Standard naming rules used across the project for:

- Tables
- Views
- Stored procedures
- Columns

### 3. Data Flow Architecture

End-to-end data flow describing how data moves from:

```
CSV Source → Bronze → Silver → Gold
```

### 4. Gold Layer Data Model

The final **analytical data model** built in the Gold layer.

This includes the **fact and dimension structure** used for analysis.

---

# Possible Enhancements

Several improvements could be added to evolve this project into a more production-ready pipeline.

## Incremental Data Loading

Instead of truncating tables, implement:

- Incremental loads
- Change tracking
- Merge operations

## Slowly Changing Dimensions (SCD Type 2)

Add:

- Surrogate keys
- Historical tracking
- SCD Type 2 implementation

## Data Catalog

Introduce a **data catalog** to provide:

- Data discovery
- Column definitions
- Lineage tracking
- Metadata documentation

---

# Summary

This project demonstrates how a **complete SQL-based data warehouse** can be implemented using the **Medallion Architecture**:

```
CSV Sources → Bronze → Silver → Gold
```

The solution focuses on:

- Structured data layering
- Clean transformation logic
- Automated scheduled loading
- Analytical-ready views

All implemented **purely using SQL**.
