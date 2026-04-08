# chinook_project
ETL pipeline on chinook dataset, processed and stored as per medallion architecture, SCD Type 2 Implementation to track changes.

**Project Overview**
This project implements an end-to-end data engineering pipeline using the Chinook dataset on Azure Databricks, following a Medallion Architecture (Raw → Bronze → Silver → Gold). The pipeline simulates a real-world enterprise workflow, covering metadata-driven ingestion, data quality validation, structured transformations, and dimensional modeling for analytical reporting.

**Architecture**
(Azure SQL) → Staging → Raw → Bronze → Silver → Gold

**Tech Stack**
Platform: Azure Databricks, Azure SQL Server
Storage & Governance: Unity Catalog, Databricks Volumes
Data Format: Parquet (Raw), Delta (Bronze / Silver / Gold)
Data Quality: Databricks DQX
Orchestration: Databricks Jobs (parameterized notebooks)
Version Control: GitHub (Databricks Git integration)


**Repository Structure**
├── 01_extract_from_source.py     # Source → Staging (metadata-driven extraction)
├── 02_load_raw.py                # Staging → Raw (Parquet snapshots with row count logging)
├── 03_raw_to_bronze.py           # Raw → Bronze (Delta table load from latest snapshot)
├── 04_bronze_to_silver.py        # Bronze → Silver (DQX validation + cleaning transformations)
├── 05_silver_to_gold.py          # Silver → Gold (dimensional model + SCD Type 2)
└── README.md

**Pipeline Notebooks**
01_extract_from_source: Source to Staging

Reads active table names from the parent_metadata table (active_flag = 'Y')
Extracts data from Azure SQL via Databricks Connection Manager
Writes to staging schema as Delta tables in overwrite mode
Fully metadata-driven — adding a new table requires only a metadata record, no code changes

02_load_raw: Staging to Raw

Reads active tables from metadata
Writes each table as a dated Parquet snapshot:
<base_path>/<table_name>/<YYYY/MM/DD>/<table_name>.parquet
Validates source vs. target row counts
Logs execution details to child_metrics_metadata

03_raw_to_bronze: Raw to Bronze

Reads from child_metrics_metadata to identify today's successful raw loads
Loads Parquet files into Bronze Delta tables (overwrite mode)
Validates raw vs. bronze row counts per table

04_bronze_to_silver: Bronze to Silver (DQX)

Profiles each Bronze table (null counts, distinct counts, duplicates, etc.)
Applies DQX validation rules:

Not-null checks on required business columns
Email regex validation (Customer, Employee)
Positive-value checks (UnitPrice, Quantity, Milliseconds)


Routes failed records to quarantine_<tablename> tables with dqx_failure_reason and dqx_failed_at columns
Applies cleaning transformations to valid records:

Trim whitespace, replace empty strings with null
Derive full_name (Customer, Employee)
Standardize Country to uppercase
Cast InvoiceDate to date type


Logs outcomes to silver.dqx_execution_log

Tables processed: Album, Artist, Customer, Employee, Genre, Invoice, InvoiceLine, MediaType, Playlist, PlaylistTrack, Track
05_silver_to_gold: Silver to Gold (Dimensional Model)

Builds all Gold objects in dependency order
Implements SCD Type 2 for dim_customer and dim_employee
Constructs bridge_playlist_track to resolve many-to-many playlist↔track relationships
Derives sales_amount = quantity × unit_price in fact_sales
Builds fact_sales_customer_agg from fact_sales (not directly from Silver)

**Gold Layer: Dimensional Model**
The Gold layer follows a star schema design optimized for analytical querying.

**Fact Tables**
**fact_sales** is the core transactional fact, built at the grain of one row per invoice line item. It captures quantity, unit price, and a derived sales amount (quantity × unit price), and links to all major dimensions via foreign keys.
**fact_sales_customer_agg** is a pre-aggregated fact derived from fact_sales — not directly from Silver. It operates at the grain of one row per customer per invoice date and provides metrics including total invoices, total quantity, total sales amount, and average invoice value, making it well-suited for customer-level reporting.

**Dimension Tables**
**dim_date** is a calendar dimension spanning 2000 through 2030, with standard attributes like day, month, quarter, year, and week of year.
**dim_customer** and **dim_employee** are both implemented as Slowly Changing Dimensions (Type 2), preserving historical versions of records across pipeline runs using effective_start_date, effective_end_date, and is_current flags.
**dim_track** is a denormalized product dimension that flattens track, album, artist, genre, and media type into a single structure to minimize joins in downstream queries.
**dim_location** is a shared role-playing dimension that standardizes address data across customers, employees, and invoice billing addresses, avoiding duplication across multiple dimensions.
**dim_playlist** stores playlist metadata and is linked to tracks through a dedicated bridge table.

**Bridge Table**
**bridge_playlist_track** resolves the many-to-many relationship between playlists and tracks. It holds playlist_key and track_key pairs, allowing a track to belong to multiple playlists and vice versa without duplicating rows in either dimension.

**Environment Setup**
1. Load the Chinook SQL script into Azure SQL Server
2. Configure a Databricks Connection Manager connection to Azure SQL (no hardcoded credentials)
3. Set up Unity Catalog schemas: staging, raw, bronze, silver, gold
4. Create a Databricks Volume for raw Parquet storage
5. Connect Databricks workspace to this GitHub repository
6. Run notebooks in order: 01 → 02 → 03 → 04 → 05


All notebooks are parameterized via Databricks widgets (catalog_name, source_schema, bronze_schema, etc.) and are environment-agnostic)
