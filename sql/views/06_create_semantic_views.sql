/*=============================================================
  Realty Income REIT Agent - Semantic Views
  Step 6: Create semantic views for Cortex Analyst integration
=============================================================*/

USE DATABASE REALTY_INCOME;
USE SCHEMA ANALYTICS;

CREATE OR REPLACE SEMANTIC VIEW REIT_PORTFOLIO_ANALYSIS

  TABLES (
    properties AS REALTY_INCOME.RAW.PROPERTIES
      PRIMARY KEY (PROPERTY_ID)
      WITH SYNONYMS ('assets', 'real estate', 'buildings')
      COMMENT = 'Commercial properties owned by the REIT',
    tenants AS REALTY_INCOME.RAW.TENANTS
      PRIMARY KEY (TENANT_ID)
      WITH SYNONYMS ('lessees', 'occupants', 'renters')
      COMMENT = 'Commercial tenants occupying REIT properties',
    leases AS REALTY_INCOME.RAW.LEASES
      PRIMARY KEY (LEASE_ID)
      WITH SYNONYMS ('contracts', 'agreements', 'rental agreements')
      COMMENT = 'Net lease agreements between REIT and tenants',
    financial_metrics AS REALTY_INCOME.RAW.FINANCIAL_METRICS
      PRIMARY KEY (METRIC_ID)
      COMMENT = 'Quarterly financial performance metrics per property',
    risk_assessments AS REALTY_INCOME.RAW.RISK_ASSESSMENTS
      PRIMARY KEY (RISK_ID)
      COMMENT = 'Property-level risk scoring and assessments'
  )

  RELATIONSHIPS (
    leases_to_properties AS
      leases (PROPERTY_ID) REFERENCES properties,
    leases_to_tenants AS
      leases (TENANT_ID) REFERENCES tenants,
    financials_to_properties AS
      financial_metrics (PROPERTY_ID) REFERENCES properties,
    risks_to_properties AS
      risk_assessments (PROPERTY_ID) REFERENCES properties
  )

  FACTS (
    properties.valuation_gain AS CURRENT_VALUATION - ACQUISITION_PRICE
      COMMENT = 'Unrealized gain on property valuation',
    leases.monthly_rent_amount AS MONTHLY_RENT,
    financial_metrics.noi AS NET_OPERATING_INCOME,
    financial_metrics.revenue AS GROSS_REVENUE,
    financial_metrics.ffo AS FUNDS_FROM_OPERATIONS,
    financial_metrics.affo AS ADJUSTED_FFO
  )

  DIMENSIONS (
    properties.property_name AS PROPERTY_NAME
      WITH SYNONYMS = ('asset name', 'building name')
      COMMENT = 'Name of the property',
    properties.property_type AS PROPERTY_TYPE
      WITH SYNONYMS = ('asset type', 'building type')
      COMMENT = 'Type of commercial property (Retail, Industrial, etc.)',
    properties.sector AS SECTOR
      WITH SYNONYMS = ('industry sector', 'property sector')
      COMMENT = 'Business sector classification of the property',
    properties.city AS CITY
      COMMENT = 'City where property is located',
    properties.state AS STATE
      WITH SYNONYMS = ('location state', 'geography')
      COMMENT = 'US state where property is located',
    properties.occupancy_status AS OCCUPANCY_STATUS
      WITH SYNONYMS = ('occupied', 'vacant', 'vacancy')
      COMMENT = 'Whether property is currently occupied or vacant',
    properties.year_acquired AS YEAR_ACQUIRED
      COMMENT = 'Year the property was acquired',
    tenants.tenant_name AS TENANT_NAME
      WITH SYNONYMS = ('company name', 'lessee name', 'renter')
      COMMENT = 'Name of the tenant company',
    tenants.industry AS TENANT_INDUSTRY
      WITH SYNONYMS = ('tenant sector', 'business type')
      COMMENT = 'Industry classification of the tenant',
    tenants.credit_rating AS CREDIT_RATING
      WITH SYNONYMS = ('rating', 'creditworthiness')
      COMMENT = 'Credit rating of the tenant (e.g., AAA, BBB, etc.)',
    leases.lease_type AS LEASE_TYPE
      WITH SYNONYMS = ('contract type', 'NNN', 'triple net')
      COMMENT = 'Type of lease agreement',
    leases.status AS LEASE_STATUS
      COMMENT = 'Current status of the lease (Active, Expired)',
    financial_metrics.fiscal_year AS FISCAL_YEAR
      COMMENT = 'Fiscal year of the financial reporting period',
    financial_metrics.fiscal_quarter AS FISCAL_QUARTER
      COMMENT = 'Fiscal quarter (1-4) of the reporting period',
    financial_metrics.reporting_date AS REPORTING_DATE
      COMMENT = 'Date of the financial report',
    risk_assessments.risk_category AS RISK_CATEGORY
      COMMENT = 'Category of risk being assessed',
    risk_assessments.risk_level AS RISK_LEVEL
      WITH SYNONYMS = ('risk rating', 'risk tier')
      COMMENT = 'Overall risk level (Low, Medium, High)'
  )

  METRICS (
    properties.total_properties AS COUNT(PROPERTY_ID)
      COMMENT = 'Total number of properties in portfolio',
    properties.total_square_footage AS SUM(SQUARE_FOOTAGE)
      COMMENT = 'Total square footage across all properties',
    properties.avg_cap_rate AS AVG(CAP_RATE)
      COMMENT = 'Average capitalization rate across properties',
    properties.total_valuation AS SUM(CURRENT_VALUATION)
      COMMENT = 'Total current portfolio valuation',
    properties.total_acquisition_cost AS SUM(ACQUISITION_PRICE)
      COMMENT = 'Total acquisition cost of all properties',
    properties.total_valuation_gain AS SUM(properties.valuation_gain)
      COMMENT = 'Total unrealized valuation gain',
    properties.occupancy_rate AS
      COUNT(CASE WHEN OCCUPANCY_STATUS = 'Occupied' THEN 1 END)::FLOAT / NULLIF(COUNT(PROPERTY_ID), 0) * 100
      COMMENT = 'Portfolio occupancy rate as percentage',
    tenants.tenant_count AS COUNT(DISTINCT TENANT_ID)
      COMMENT = 'Number of unique tenants',
    leases.total_annual_rent AS SUM(ANNUAL_RENT)
      COMMENT = 'Total annualized rent from all active leases',
    leases.avg_remaining_term AS AVG(REMAINING_TERM_MONTHS)
      COMMENT = 'Average remaining lease term in months',
    leases.active_lease_count AS COUNT(CASE WHEN STATUS = 'Active' THEN 1 END)
      COMMENT = 'Number of active leases',
    leases.avg_escalation_rate AS AVG(RENT_ESCALATION_RATE)
      COMMENT = 'Average annual rent escalation rate',
    financial_metrics.total_noi AS SUM(financial_metrics.noi)
      COMMENT = 'Total Net Operating Income',
    financial_metrics.total_revenue AS SUM(financial_metrics.revenue)
      COMMENT = 'Total gross revenue',
    financial_metrics.total_ffo AS SUM(financial_metrics.ffo)
      COMMENT = 'Total Funds From Operations',
    financial_metrics.total_affo AS SUM(financial_metrics.affo)
      COMMENT = 'Total Adjusted Funds From Operations',
    financial_metrics.avg_occupancy AS AVG(OCCUPANCY_RATE)
      COMMENT = 'Average occupancy rate from financial reporting',
    financial_metrics.avg_noi_growth AS AVG(SAME_STORE_NOI_GROWTH)
      COMMENT = 'Average same-store NOI growth rate',
    risk_assessments.avg_risk_score AS AVG(RISK_SCORE)
      COMMENT = 'Average risk score across assessments',
    risk_assessments.high_risk_count AS COUNT(CASE WHEN RISK_LEVEL = 'High' THEN 1 END)
      COMMENT = 'Number of high-risk assessments'
  )

  AI_SQL_GENERATION 'When generating SQL for REIT analysis: (1) Always use fully qualified table names. (2) Round financial figures to 2 decimal places. (3) Express rates and percentages with 1 decimal place. (4) When asked about occupancy, default to portfolio-level occupancy from PROPERTIES table. (5) For FFO/AFFO metrics, clarify whether per-share or total is needed. (6) Default time period is most recent fiscal year unless specified.'

  AI_QUESTION_CATEGORIZATION 'This semantic view covers Realty Income REIT portfolio analytics including properties, tenants, leases, financial performance, and risk. If a question is about stock trading advice or personal investment recommendations, explain that this tool provides data analysis only, not investment advice. If the question is about non-REIT topics unrelated to real estate investment trusts, explain the scope limitation.'

  COMMENT = 'Comprehensive semantic view for Realty Income REIT portfolio analysis covering properties, tenants, leases, financials, and risk';


CREATE OR REPLACE SEMANTIC VIEW REIT_MARKET_PERFORMANCE

  TABLES (
    portfolio_summary AS REALTY_INCOME.RAW.PORTFOLIO_SUMMARY
      PRIMARY KEY (SUMMARY_ID)
      COMMENT = 'Quarterly portfolio-level summary metrics',
    market_data AS REALTY_INCOME.RAW.MARKET_DATA
      PRIMARY KEY (MARKET_ID)
      COMMENT = 'Daily stock market and pricing data'
  )

  RELATIONSHIPS (
    market_to_portfolio AS
      market_data (MARKET_DATE) REFERENCES portfolio_summary (REPORTING_DATE)
  )

  FACTS (
    portfolio_summary.annualized_rent AS TOTAL_ANNUALIZED_RENT,
    portfolio_summary.total_debt_amount AS TOTAL_DEBT,
    market_data.daily_price AS STOCK_PRICE,
    market_data.daily_volume AS VOLUME
  )

  DIMENSIONS (
    portfolio_summary.reporting_date AS REPORTING_DATE
      COMMENT = 'Date of the portfolio summary report',
    market_data.market_date AS MARKET_DATE
      COMMENT = 'Trading date for market data'
  )

  METRICS (
    portfolio_summary.latest_occupancy AS MAX(PORTFOLIO_OCCUPANCY_RATE)
      COMMENT = 'Latest portfolio occupancy rate',
    portfolio_summary.latest_properties AS MAX(TOTAL_PROPERTIES)
      COMMENT = 'Latest total property count',
    portfolio_summary.avg_lease_term AS AVG(WEIGHTED_AVG_LEASE_TERM)
      COMMENT = 'Average weighted lease term in years',
    portfolio_summary.total_rent AS SUM(portfolio_summary.annualized_rent)
      COMMENT = 'Total annualized contractual rent',
    portfolio_summary.avg_payout_ratio AS AVG(PAYOUT_RATIO)
      COMMENT = 'Average dividend payout ratio',
    portfolio_summary.avg_debt_to_ebitda AS AVG(DEBT_TO_EBITDA_RATIO)
      COMMENT = 'Average debt to EBITDA ratio',
    portfolio_summary.avg_interest_coverage AS AVG(INTEREST_COVERAGE_RATIO)
      COMMENT = 'Average interest coverage ratio',
    market_data.avg_stock_price AS AVG(market_data.daily_price)
      COMMENT = 'Average stock price over period',
    market_data.avg_dividend_yield AS AVG(DIVIDEND_YIELD)
      COMMENT = 'Average dividend yield',
    market_data.avg_price_to_ffo AS AVG(PRICE_TO_FFO)
      COMMENT = 'Average Price/FFO multiple',
    market_data.max_price AS MAX(market_data.daily_price)
      COMMENT = 'Maximum stock price in period',
    market_data.min_price AS MIN(market_data.daily_price)
      COMMENT = 'Minimum stock price in period',
    market_data.avg_total_return AS AVG(TOTAL_RETURN_YTD)
      COMMENT = 'Average year-to-date total return',
    market_data.avg_spread AS AVG(SPREAD_TO_TREASURY)
      COMMENT = 'Average spread to 10-year Treasury'
  )

  AI_SQL_GENERATION 'For market performance queries: (1) Default to most recent available data unless a specific date range is requested. (2) When comparing to benchmarks, include both REIT performance and S&P 500 return. (3) Format stock prices to 2 decimal places and percentages to 1 decimal place. (4) For time series, order by date ascending.'

  COMMENT = 'Semantic view for Realty Income market performance and portfolio summary analysis';
