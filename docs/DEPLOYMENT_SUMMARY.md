# Deployment Summary

## Architecture Overview

![Deployment Flow](images/deployment_flow.svg)

## Component Stack

```
┌─────────────────────────────────────────────────────────────┐
│  USER INTERFACE                                              │
│  Snowsight Chat / SQL / API                                  │
├─────────────────────────────────────────────────────────────┤
│  AGENT LAYER                                                 │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  REALTY_INCOME.AGENT.REIT_ADVISOR                    │    │
│  │  - Orchestration: auto model selection               │    │
│  │  - Budget: 60s / 32K tokens                          │    │
│  │  - Instructions: REIT domain expert behavior         │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│  TOOL LAYER                                                  │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────────────┐ │
│  │ Portfolio     │  │ Market       │  │ Document Search   │ │
│  │ Analytics     │  │ Performance  │  │ (Cortex Search)   │ │
│  │ (Text2SQL)   │  │ (Text2SQL)   │  │                   │ │
│  └──────┬───────┘  └──────┬───────┘  └────────┬──────────┘ │
├─────────┼──────────────────┼───────────────────┼────────────┤
│  DATA LAYER                                                  │
│  ┌──────┴───────┐  ┌──────┴───────┐  ┌────────┴──────────┐ │
│  │ Semantic View│  │ Semantic View│  │ Search Documents  │ │
│  │ REIT_        │  │ REIT_MARKET_ │  │ + Knowledge Base  │ │
│  │ PORTFOLIO_   │  │ PERFORMANCE  │  │                   │ │
│  │ ANALYSIS     │  │              │  │                   │ │
│  └──────┬───────┘  └──────┬───────┘  └───────────────────┘ │
│         │                  │                                 │
│  ┌──────┴──────────────────┴───────────────────────────────┐│
│  │  RAW TABLES                                              ││
│  │  Properties │ Tenants │ Leases │ Financial_Metrics       ││
│  │  Portfolio_Summary │ Market_Data │ Documents             ││
│  │  Risk_Assessments │ Maintenance_Records                  ││
│  └──────────────────────────────────────────────────────────┘│
├─────────────────────────────────────────────────────────────┤
│  ML LAYER                                                    │
│  ┌──────────────────────┐  ┌────────────────────────────┐  │
│  │ ML Registry Models    │  │ SQL UDF Functions           │  │
│  │ - Lease Renewal v1    │  │ - PREDICT_LEASE_RENEWAL()   │  │
│  │ - Property Risk v1    │  │ - PREDICT_PROPERTY_RISK()   │  │
│  │                       │  │ - FORECAST_NOI()            │  │
│  │                       │  │ - CALCULATE_PROPERTY_SCORE()│  │
│  └──────────────────────┘  └────────────────────────────┘  │
├─────────────────────────────────────────────────────────────┤
│  GOVERNANCE LAYER                                            │
│  ┌──────────────────────────────────────────────────────┐   │
│  │ FIBO Ontology Tags                                    │   │
│  │ - Entity Class │ Property Type │ Financial Instrument │   │
│  │ - Temporal Entity │ Party Role                        │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Deployment Steps

| Step | Script | Objects Created | Dependencies |
|------|--------|----------------|--------------|
| 1 | `01_database_and_schema.sql` | DB, schemas, warehouse, stages | None |
| 2 | `02_create_tables.sql` | 9 tables | Step 1 |
| 3 | `03_Financial_Industry_Business_Ontology.sql` | Tags, data dictionary view | Steps 1-2 |
| 4 | `04_generate_synthetic_data.sql` | ~7,700 rows of data | Steps 1-2 |
| 5 | `05_create_views.sql` | 8 analytics views | Steps 1-4 |
| 6 | `06_create_semantic_views.sql` | 2 semantic views | Steps 1-4 |
| 7 | `07_create_cortex_search.sql` | Search documents table, Cortex Search service | Steps 1-4 |
| 8 | `08_ml_models.ipynb` | 2 registered ML models | Steps 1-4 |
| 9 | `09_ml_model_functions.sql` | 4 SQL UDFs | Step 1 |
| 10 | `10_create_agent.sql` | Cortex Agent | Steps 6-7 |

## Resource Requirements

| Resource | Specification |
|----------|--------------|
| Warehouse | MEDIUM (recommended) |
| Storage | ~50 MB for synthetic data |
| Cortex Search | 1 service, hourly refresh |
| ML Models | 2 models in registry |
| Estimated setup time | 10-15 minutes |

## Security Model

- Agent created with `PUBLIC` role access for demo purposes
- Production deployments should use restricted roles
- No PII in synthetic data
- All data self-contained (no external dependencies)
