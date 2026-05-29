# Agent Setup Guide

## Prerequisites

1. Snowflake account with **Cortex AI** enabled
2. `ACCOUNTADMIN` role access
3. A warehouse (MEDIUM+ recommended)
4. Cross-region Cortex enabled

## Step-by-Step Deployment

### Step 1: Database & Schema Setup

Run `sql/setup/01_database_and_schema.sql` to create:
- Database: `REALTY_INCOME`
- Schemas: `RAW`, `ANALYTICS`, `ML`, `AGENT`
- Warehouse: `REALTY_WH`
- Stages for documents and ML artifacts

### Step 2: Create Tables

Run `sql/setup/02_create_tables.sql` to create 9 tables:
- `PROPERTIES` - Physical real estate assets
- `TENANTS` - Tenant companies
- `LEASES` - Lease agreements
- `FINANCIAL_METRICS` - Quarterly financials per property
- `PORTFOLIO_SUMMARY` - Portfolio-level KPIs
- `MARKET_DATA` - Stock market data
- `DOCUMENTS` - Corporate documents
- `RISK_ASSESSMENTS` - Property risk scoring
- `MAINTENANCE_RECORDS` - Property maintenance

### Step 3: FIBO Ontology

Run `sql/setup/03_Financial_Industry_Business_Ontology.sql` to:
- Create FIBO-aligned object tags
- Tag all tables with FIBO entity classifications
- Create a data dictionary view

### Step 4: Synthetic Data

Run `sql/data/04_generate_synthetic_data.sql` to populate:
- 500 properties across 20 US cities
- 20 tenants modeled on real Realty Income tenants
- 500 leases with various structures
- 3,000 quarterly financial records
- 22 portfolio summaries (2020-2025)
- 1,400 market data records
- 10 corporate documents
- 1,000 risk assessments
- 800 maintenance records

### Step 5: Analytics Views

Run `sql/views/05_create_views.sql` to create 8 analytical views:
- `PROPERTY_PERFORMANCE` - Joined property/tenant/lease/financial view
- `PORTFOLIO_HEALTH` - Portfolio KPIs with market data
- `LEASE_EXPIRATION_SCHEDULE` - Upcoming expirations by year/quarter
- `TENANT_CONCENTRATION` - Tenant concentration analysis
- `GEOGRAPHIC_DISTRIBUTION` - State-level portfolio breakdown
- `RISK_DASHBOARD` - Risk assessments with property context
- `FINANCIAL_TREND` - Quarterly financial aggregates
- `MAINTENANCE_SUMMARY` - Maintenance tracking with budget status

### Step 6: Semantic Views

Run `sql/views/06_create_semantic_views.sql` to create:
- `REIT_PORTFOLIO_ANALYSIS` - For property/tenant/lease/financial/risk queries
- `REIT_MARKET_PERFORMANCE` - For market and portfolio-level KPI queries

These semantic views enable Cortex Analyst to translate natural language into SQL.

### Step 7: Cortex Search

Run `sql/search/07_create_cortex_search.sql` to:
- Create a chunked documents table
- Populate with earnings calls, SEC filings, and knowledge base articles
- Create `REIT_DOCUMENT_SEARCH` Cortex Search service

### Step 8: ML Models

Open and run `notebooks/08_ml_models.ipynb` to:
- Train a Lease Renewal Predictor (GradientBoosting)
- Train a Property Risk Classifier (GradientBoosting)
- Register both models in `REALTY_INCOME.ML` schema

### Step 9: ML Functions

Run `sql/models/09_ml_model_functions.sql` to create SQL UDFs:
- `PREDICT_LEASE_RENEWAL()` - Rule-based renewal probability
- `PREDICT_PROPERTY_RISK()` - Multi-factor risk scoring
- `FORECAST_NOI()` - NOI growth projection (table function)
- `CALCULATE_PROPERTY_SCORE()` - Composite property scoring

### Step 10: Create Agent

Run `sql/agent/10_create_agent.sql` to create:
- `REIT_ADVISOR` Cortex Agent with:
  - Portfolio Analytics tool (semantic view)
  - Market Performance tool (semantic view)
  - Document Search tool (Cortex Search)
  - Chart generation tool

## Verification

After deployment, test the agent:

```sql
SELECT SNOWFLAKE.CORTEX.AGENT(
    'REALTY_INCOME.AGENT.REIT_ADVISOR',
    'What is the current portfolio occupancy rate?'
);
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Cortex not available | Enable cross-region: `ALTER ACCOUNT SET CORTEX_ENABLED_CROSS_REGION = 'ANY_REGION'` |
| Semantic view errors | Ensure tables have data before creating semantic views |
| Search service lag | Wait for initial indexing (TARGET_LAG = '1 hour') |
| ML notebook fails | Ensure `snowflake-ml-python` package is available in the notebook environment |
| Agent creation fails | Verify all referenced objects (semantic views, search service) exist |
