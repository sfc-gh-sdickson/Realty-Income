/*=============================================================
  Realty Income REIT Agent - Cortex Search Service
  Step 7: Create Cortex Search for document retrieval (RAG)
=============================================================*/

USE DATABASE REALTY_INCOME;
USE SCHEMA AGENT;

CREATE OR REPLACE TABLE REALTY_INCOME.AGENT.SEARCH_DOCUMENTS (
    DOC_ID VARCHAR(20),
    CHUNK_ID NUMBER,
    DOC_TYPE VARCHAR(50),
    DOC_TITLE VARCHAR(500),
    DOC_DATE DATE,
    FISCAL_YEAR NUMBER(4,0),
    FISCAL_QUARTER NUMBER(1,0),
    CHUNK_TEXT TEXT,
    METADATA VARIANT
);

INSERT INTO REALTY_INCOME.AGENT.SEARCH_DOCUMENTS (DOC_ID, CHUNK_ID, DOC_TYPE, DOC_TITLE, DOC_DATE, FISCAL_YEAR, FISCAL_QUARTER, CHUNK_TEXT, METADATA)
SELECT
    d.DOC_ID,
    ROW_NUMBER() OVER (PARTITION BY d.DOC_ID ORDER BY d.DOC_ID),
    d.DOC_TYPE,
    d.DOC_TITLE,
    d.DOC_DATE,
    d.FISCAL_YEAR,
    d.FISCAL_QUARTER,
    d.CONTENT,
    OBJECT_CONSTRUCT(
        'doc_type', d.DOC_TYPE,
        'title', d.DOC_TITLE,
        'date', d.DOC_DATE::VARCHAR,
        'fiscal_year', d.FISCAL_YEAR,
        'fiscal_quarter', d.FISCAL_QUARTER,
        'summary', d.SUMMARY
    )
FROM REALTY_INCOME.RAW.DOCUMENTS d;

INSERT INTO REALTY_INCOME.AGENT.SEARCH_DOCUMENTS (DOC_ID, CHUNK_ID, DOC_TYPE, DOC_TITLE, DOC_DATE, FISCAL_YEAR, FISCAL_QUARTER, CHUNK_TEXT, METADATA)
VALUES
    ('KB-001', 1, 'Knowledge Base', 'REIT Fundamentals', '2025-01-01', 2025, 1,
     'A Real Estate Investment Trust (REIT) is a company that owns, operates, or finances income-generating real estate. REITs must distribute at least 90% of taxable income as dividends. Realty Income is a net lease REIT, meaning tenants pay most property-level expenses including taxes, insurance, and maintenance. This triple-net (NNN) structure provides predictable cash flows with minimal landlord responsibilities.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'REIT Basics')),
    ('KB-002', 1, 'Knowledge Base', 'Key REIT Metrics Explained', '2025-01-01', 2025, 1,
     'FFO (Funds From Operations) is the primary earnings metric for REITs, calculated as net income plus depreciation minus gains on property sales. AFFO (Adjusted FFO) further adjusts for recurring capital expenditures and straight-line rent adjustments, providing a better measure of sustainable cash flow. Cap Rate equals NOI divided by property value. Occupancy rate measures the percentage of rentable space currently leased. Debt-to-EBITDA measures leverage relative to earnings.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Financial Metrics')),
    ('KB-003', 1, 'Knowledge Base', 'Realty Income Company Overview', '2025-01-01', 2025, 1,
     'Realty Income Corporation (NYSE: O) is known as "The Monthly Dividend Company" and has paid monthly dividends since 1969. The company is an S&P 500 member and has increased its dividend 127 consecutive quarters. Realty Income owns over 15,000 properties across 89 industries in all 50 US states and 8 international countries. The portfolio is focused on freestanding, single-tenant commercial properties under long-term net lease agreements.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Company Overview')),
    ('KB-004', 1, 'Knowledge Base', 'Net Lease Structure Benefits', '2025-01-01', 2025, 1,
     'Net lease REITs benefit from predictable revenue streams because tenants are responsible for property-level expenses. Triple-net (NNN) leases require tenants to pay real estate taxes, building insurance, and maintenance costs. This reduces operational complexity and capital expenditure requirements for the landlord. Realty Income primarily uses absolute net and triple-net lease structures with built-in rent escalators typically tied to CPI or fixed annual increases of 1-3%.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Lease Structure')),
    ('KB-005', 1, 'Knowledge Base', 'Portfolio Diversification Strategy', '2025-01-01', 2025, 1,
     'Realty Income diversifies across tenant, industry, geography, and property type dimensions. Top tenants include Dollar General, Walgreens, Dollar Tree, FedEx, and 7-Eleven. No single tenant represents more than 4% of total annualized rent. The portfolio spans retail (70%), industrial (15%), and other property types. Geographic diversification spans all 50 states with growing international presence in Europe through the UK, Spain, Italy, Germany, France, Ireland, and Portugal.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Diversification')),
    ('KB-006', 1, 'Knowledge Base', 'Interest Rate Impact on REITs', '2025-01-01', 2025, 1,
     'REITs are sensitive to interest rate changes. Rising rates increase borrowing costs, reduce property valuations (higher cap rates), and make REIT dividends relatively less attractive versus bonds. However, net lease REITs with built-in rent escalators provide partial inflation protection. Realty Income manages rate risk through laddered debt maturities, maintaining a weighted average debt maturity of 6+ years, and keeping variable-rate debt below 5% of total debt.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Interest Rate Risk')),
    ('KB-007', 1, 'Knowledge Base', 'Investment Grade Tenant Analysis', '2025-01-01', 2025, 1,
     'Investment-grade tenants are those with credit ratings of BBB- or higher from major rating agencies. Realty Income targets approximately 50-55% of annualized rent from investment-grade rated tenants. Higher credit quality tenants reduce default risk and provide more predictable cash flows. However, lower-rated tenants often command higher rents and cap rates. The portfolio balances credit quality with yield optimization.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'Tenant Credit Quality')),
    ('KB-008', 1, 'Knowledge Base', 'European Expansion Strategy', '2025-01-01', 2025, 1,
     'Realty Income has expanded significantly into Europe since 2019, initially through the UK and subsequently into Spain, Italy, Germany, France, Ireland, and Portugal. European markets offer higher initial yields (7-8% cap rates vs 6-7% domestically) and longer lease terms. The European net lease market is less mature and fragmented, providing a larger acquisition runway. International properties now represent approximately 15% of annualized rent.',
     OBJECT_CONSTRUCT('doc_type', 'Knowledge Base', 'topic', 'International Growth'));

CREATE OR REPLACE CORTEX SEARCH SERVICE REALTY_INCOME.AGENT.REIT_DOCUMENT_SEARCH
    ON CHUNK_TEXT
    ATTRIBUTES DOC_TYPE, DOC_TITLE, FISCAL_YEAR
    WAREHOUSE = REALTY_WH
    TARGET_LAG = '1 hour'
    AS (
        SELECT
            CHUNK_TEXT,
            DOC_TYPE,
            DOC_TITLE,
            FISCAL_YEAR,
            DOC_DATE
        FROM REALTY_INCOME.AGENT.SEARCH_DOCUMENTS
    );
