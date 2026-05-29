/*=============================================================
  Realty Income REIT Agent - FIBO Ontology Layer
  Step 3: Create Financial Industry Business Ontology tags
  Aligns REIT data with FIBO standards for financial interop
=============================================================*/

USE DATABASE REALTY_INCOME;
USE SCHEMA ANALYTICS;

CREATE TAG IF NOT EXISTS FIBO_ENTITY_CLASS
    COMMENT = 'FIBO entity classification (e.g., RealEstateAsset, Lease, Party)';

CREATE TAG IF NOT EXISTS FIBO_PROPERTY_TYPE
    COMMENT = 'FIBO property type classification for real estate assets';

CREATE TAG IF NOT EXISTS FIBO_FINANCIAL_INSTRUMENT
    COMMENT = 'FIBO classification of financial instruments and metrics';

CREATE TAG IF NOT EXISTS FIBO_TEMPORAL_ENTITY
    COMMENT = 'FIBO temporal classification (DatePeriod, ReportingPeriod)';

CREATE TAG IF NOT EXISTS FIBO_PARTY_ROLE
    COMMENT = 'FIBO party role (Lessor, Lessee, Investor)';

ALTER TABLE REALTY_INCOME.RAW.PROPERTIES SET TAG
    FIBO_ENTITY_CLASS = 'RealEstateAsset',
    FIBO_PROPERTY_TYPE = 'CommercialProperty';

ALTER TABLE REALTY_INCOME.RAW.TENANTS SET TAG
    FIBO_ENTITY_CLASS = 'LegalEntity',
    FIBO_PARTY_ROLE = 'Lessee';

ALTER TABLE REALTY_INCOME.RAW.LEASES SET TAG
    FIBO_ENTITY_CLASS = 'ContractualObligation',
    FIBO_FINANCIAL_INSTRUMENT = 'OperatingLease';

ALTER TABLE REALTY_INCOME.RAW.FINANCIAL_METRICS SET TAG
    FIBO_ENTITY_CLASS = 'FinancialPerformanceMeasure',
    FIBO_TEMPORAL_ENTITY = 'ReportingPeriod';

ALTER TABLE REALTY_INCOME.RAW.PORTFOLIO_SUMMARY SET TAG
    FIBO_ENTITY_CLASS = 'PortfolioAnalytics',
    FIBO_FINANCIAL_INSTRUMENT = 'RealEstateInvestmentTrust';

ALTER TABLE REALTY_INCOME.RAW.MARKET_DATA SET TAG
    FIBO_ENTITY_CLASS = 'MarketObservable',
    FIBO_FINANCIAL_INSTRUMENT = 'EquitySecurity';

ALTER TABLE REALTY_INCOME.RAW.RISK_ASSESSMENTS SET TAG
    FIBO_ENTITY_CLASS = 'RiskAssessment',
    FIBO_FINANCIAL_INSTRUMENT = 'CreditRiskMeasure';

ALTER TABLE REALTY_INCOME.RAW.DOCUMENTS SET TAG
    FIBO_ENTITY_CLASS = 'FinancialDocument',
    FIBO_TEMPORAL_ENTITY = 'ReportingPeriod';

ALTER TABLE REALTY_INCOME.RAW.MAINTENANCE_RECORDS SET TAG
    FIBO_ENTITY_CLASS = 'AssetMaintenanceEvent',
    FIBO_PROPERTY_TYPE = 'PropertyService';

CREATE OR REPLACE VIEW REALTY_INCOME.ANALYTICS.FIBO_DATA_DICTIONARY AS
SELECT
    'PROPERTIES' AS TABLE_NAME,
    'RealEstateAsset' AS FIBO_CLASS,
    'Physical commercial real estate assets owned by the REIT' AS DESCRIPTION,
    'FND-Ownership, RE-RealEstate' AS FIBO_MODULES
UNION ALL SELECT 'TENANTS', 'LegalEntity', 'Commercial tenants occupying REIT properties', 'FND-Parties, BE-LegalEntities'
UNION ALL SELECT 'LEASES', 'ContractualObligation', 'Net lease agreements between REIT and tenants', 'FND-Agreements, IND-Leases'
UNION ALL SELECT 'FINANCIAL_METRICS', 'FinancialPerformanceMeasure', 'Quarterly financial performance data per property', 'IND-Indicators, FND-Accounting'
UNION ALL SELECT 'PORTFOLIO_SUMMARY', 'PortfolioAnalytics', 'Aggregate portfolio-level performance metrics', 'SEC-Portfolios, IND-Indicators'
UNION ALL SELECT 'MARKET_DATA', 'MarketObservable', 'Stock market and pricing data for the REIT', 'MD-MarketData, SEC-Equities'
UNION ALL SELECT 'RISK_ASSESSMENTS', 'RiskAssessment', 'Property and portfolio risk scoring', 'FND-Risk, IND-RiskIndicators'
UNION ALL SELECT 'DOCUMENTS', 'FinancialDocument', 'Earnings calls, SEC filings, investor presentations', 'FND-Documents, SEC-Filings'
UNION ALL SELECT 'MAINTENANCE_RECORDS', 'AssetMaintenanceEvent', 'Property maintenance and capital expenditure tracking', 'FND-Assets, RE-PropertyMgmt';
