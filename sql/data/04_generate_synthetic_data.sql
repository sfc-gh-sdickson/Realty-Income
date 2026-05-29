/*=============================================================
  Realty Income REIT Agent - Synthetic Data Generation
  Step 4: Generate realistic synthetic data for all tables
  Based on Realty Income's actual portfolio characteristics
=============================================================*/

USE DATABASE REALTY_INCOME;
USE SCHEMA RAW;

INSERT INTO PROPERTIES (PROPERTY_ID, PROPERTY_NAME, PROPERTY_TYPE, SECTOR, ADDRESS, CITY, STATE, ZIP_CODE, COUNTRY, LATITUDE, LONGITUDE, SQUARE_FOOTAGE, YEAR_BUILT, YEAR_ACQUIRED, ACQUISITION_PRICE, CURRENT_VALUATION, CAP_RATE, OCCUPANCY_STATUS)
SELECT
    'PROP-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    CASE MOD(SEQ4(), 12)
        WHEN 0 THEN 'Walgreens #' || (1000 + SEQ4())::VARCHAR
        WHEN 1 THEN 'Dollar General #' || (2000 + SEQ4())::VARCHAR
        WHEN 2 THEN 'FedEx Distribution Center #' || (100 + SEQ4())::VARCHAR
        WHEN 3 THEN '7-Eleven #' || (3000 + SEQ4())::VARCHAR
        WHEN 4 THEN 'Dollar Tree #' || (4000 + SEQ4())::VARCHAR
        WHEN 5 THEN 'Walmart Neighborhood Market #' || (500 + SEQ4())::VARCHAR
        WHEN 6 THEN 'Home Depot #' || (600 + SEQ4())::VARCHAR
        WHEN 7 THEN 'LA Fitness #' || (700 + SEQ4())::VARCHAR
        WHEN 8 THEN 'BJs Wholesale #' || (800 + SEQ4())::VARCHAR
        WHEN 9 THEN 'AMC Theater #' || (900 + SEQ4())::VARCHAR
        WHEN 10 THEN 'Wawa #' || (1100 + SEQ4())::VARCHAR
        WHEN 11 THEN 'Red Lobster #' || (1200 + SEQ4())::VARCHAR
    END,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Retail'
        WHEN 1 THEN 'Industrial'
        WHEN 2 THEN 'Convenience Store'
        WHEN 3 THEN 'Restaurant'
        WHEN 4 THEN 'Fitness'
        WHEN 5 THEN 'Theater'
    END,
    CASE MOD(SEQ4(), 10)
        WHEN 0 THEN 'Grocery & Pharmacy'
        WHEN 1 THEN 'Dollar Stores'
        WHEN 2 THEN 'Distribution & Logistics'
        WHEN 3 THEN 'Convenience Stores'
        WHEN 4 THEN 'Home Improvement'
        WHEN 5 THEN 'General Merchandise'
        WHEN 6 THEN 'Health & Fitness'
        WHEN 7 THEN 'Wholesale Clubs'
        WHEN 8 THEN 'Entertainment'
        WHEN 9 THEN 'Quick Service Restaurants'
    END,
    (100 + MOD(SEQ4() * 7, 9900))::VARCHAR || ' ' ||
    CASE MOD(SEQ4(), 8) WHEN 0 THEN 'Main St' WHEN 1 THEN 'Commerce Blvd' WHEN 2 THEN 'Industrial Pkwy' WHEN 3 THEN 'Retail Dr' WHEN 4 THEN 'Highway 1' WHEN 5 THEN 'Park Ave' WHEN 6 THEN 'Oak St' WHEN 7 THEN 'Elm Rd' END,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'Dallas' WHEN 1 THEN 'Houston' WHEN 2 THEN 'Phoenix' WHEN 3 THEN 'Orlando'
        WHEN 4 THEN 'Atlanta' WHEN 5 THEN 'Charlotte' WHEN 6 THEN 'Tampa' WHEN 7 THEN 'Nashville'
        WHEN 8 THEN 'Columbus' WHEN 9 THEN 'Indianapolis' WHEN 10 THEN 'San Antonio' WHEN 11 THEN 'Jacksonville'
        WHEN 12 THEN 'Denver' WHEN 13 THEN 'Memphis' WHEN 14 THEN 'Louisville' WHEN 15 THEN 'Raleigh'
        WHEN 16 THEN 'Oklahoma City' WHEN 17 THEN 'Richmond' WHEN 18 THEN 'Kansas City' WHEN 19 THEN 'Tucson'
    END,
    CASE MOD(SEQ4(), 20)
        WHEN 0 THEN 'TX' WHEN 1 THEN 'TX' WHEN 2 THEN 'AZ' WHEN 3 THEN 'FL'
        WHEN 4 THEN 'GA' WHEN 5 THEN 'NC' WHEN 6 THEN 'FL' WHEN 7 THEN 'TN'
        WHEN 8 THEN 'OH' WHEN 9 THEN 'IN' WHEN 10 THEN 'TX' WHEN 11 THEN 'FL'
        WHEN 12 THEN 'CO' WHEN 13 THEN 'TN' WHEN 14 THEN 'KY' WHEN 15 THEN 'NC'
        WHEN 16 THEN 'OK' WHEN 17 THEN 'VA' WHEN 18 THEN 'MO' WHEN 19 THEN 'AZ'
    END,
    LPAD((30000 + MOD(SEQ4() * 13, 70000))::VARCHAR, 5, '0'),
    'United States',
    25.0 + UNIFORM(0::FLOAT, 23::FLOAT, RANDOM()),
    -125.0 + UNIFORM(0::FLOAT, 55::FLOAT, RANDOM()),
    CASE MOD(SEQ4(), 6)
        WHEN 1 THEN 50000 + MOD(SEQ4() * 31, 450000)
        ELSE 3000 + MOD(SEQ4() * 17, 47000)
    END,
    1960 + MOD(SEQ4() * 3, 64),
    2000 + MOD(SEQ4() * 7, 25),
    1000000 + MOD(SEQ4() * 1234, 49000000)::NUMBER(18,2),
    1200000 + MOD(SEQ4() * 1567, 58000000)::NUMBER(18,2),
    4.5 + UNIFORM(0::FLOAT, 3.5::FLOAT, RANDOM()),
    CASE WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.97 THEN 'Occupied' ELSE 'Vacant' END
FROM TABLE(GENERATOR(ROWCOUNT => 500));

INSERT INTO TENANTS (TENANT_ID, TENANT_NAME, INDUSTRY, CREDIT_RATING, PARENT_COMPANY, HEADQUARTERS_STATE, ANNUAL_REVENUE, EMPLOYEE_COUNT, PUBLIC_COMPANY, TICKER_SYMBOL)
VALUES
    ('TEN-00001', 'Walgreens Boots Alliance', 'Pharmacy & Retail', 'BBB', 'Walgreens Boots Alliance Inc', 'IL', 132700000000, 325000, TRUE, 'WBA'),
    ('TEN-00002', 'Dollar General Corporation', 'Discount Retail', 'BBB', 'Dollar General Corp', 'TN', 37800000000, 163000, TRUE, 'DG'),
    ('TEN-00003', 'FedEx Corporation', 'Logistics & Shipping', 'BBB', 'FedEx Corp', 'TN', 93500000000, 518000, TRUE, 'FDX'),
    ('TEN-00004', '7-Eleven Inc', 'Convenience Stores', 'A-', 'Seven & i Holdings', 'TX', 21300000000, 78000, FALSE, NULL),
    ('TEN-00005', 'Dollar Tree Inc', 'Discount Retail', 'BBB-', 'Dollar Tree Inc', 'VA', 28300000000, 193000, TRUE, 'DLTR'),
    ('TEN-00006', 'Walmart Inc', 'General Merchandise', 'AA', 'Walmart Inc', 'AR', 611300000000, 2100000, TRUE, 'WMT'),
    ('TEN-00007', 'Home Depot Inc', 'Home Improvement', 'A', 'Home Depot Inc', 'GA', 157400000000, 471000, TRUE, 'HD'),
    ('TEN-00008', 'LA Fitness International', 'Health & Fitness', 'BB+', 'Fitness International LLC', 'CA', 2100000000, 32000, FALSE, NULL),
    ('TEN-00009', 'BJs Wholesale Club', 'Wholesale Retail', 'BB+', 'BJs Wholesale Club Holdings', 'MA', 19500000000, 34000, TRUE, 'BJ'),
    ('TEN-00010', 'AMC Entertainment', 'Entertainment', 'CCC+', 'AMC Entertainment Holdings', 'KS', 4800000000, 35000, TRUE, 'AMC'),
    ('TEN-00011', 'Wawa Inc', 'Convenience Stores', 'A-', 'Wawa Inc', 'PA', 17400000000, 46000, FALSE, NULL),
    ('TEN-00012', 'Darden Restaurants', 'Full Service Restaurants', 'BBB', 'Darden Restaurants Inc', 'FL', 10500000000, 180000, TRUE, 'DRI'),
    ('TEN-00013', 'CVS Health', 'Pharmacy & Retail', 'BBB', 'CVS Health Corp', 'RI', 357800000000, 300000, TRUE, 'CVS'),
    ('TEN-00014', 'Kroger Co', 'Grocery', 'BBB', 'Kroger Co', 'OH', 148300000000, 420000, TRUE, 'KR'),
    ('TEN-00015', 'Treasury Wine Estates', 'Specialty Retail', 'BBB-', 'Treasury Wine Estates Ltd', 'CA', 2400000000, 4500, TRUE, 'TWE'),
    ('TEN-00016', 'Tractor Supply Co', 'Specialty Retail', 'BBB', 'Tractor Supply Co', 'TN', 14200000000, 50000, TRUE, 'TSCO'),
    ('TEN-00017', 'AutoZone Inc', 'Auto Parts', 'BBB', 'AutoZone Inc', 'TN', 17500000000, 110000, TRUE, 'AZO'),
    ('TEN-00018', 'Sainsburys', 'Grocery (UK)', 'BBB-', 'J Sainsbury PLC', 'UK', 38600000000, 189000, TRUE, 'SBRY'),
    ('TEN-00019', 'EG Group', 'Convenience & Fuel', 'B+', 'EG Group Ltd', 'UK', 31200000000, 50000, FALSE, NULL),
    ('TEN-00020', 'Life Time Fitness', 'Health & Fitness', 'B+', 'Life Time Group Holdings', 'MN', 2400000000, 40000, TRUE, 'LTH');

INSERT INTO LEASES (LEASE_ID, PROPERTY_ID, TENANT_ID, LEASE_TYPE, LEASE_START_DATE, LEASE_END_DATE, MONTHLY_RENT, ANNUAL_RENT, RENT_ESCALATION_RATE, RENT_ESCALATION_TYPE, LEASE_TERM_MONTHS, REMAINING_TERM_MONTHS, RENEWAL_OPTIONS, TRIPLE_NET, STATUS)
SELECT
    'LSE-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    'PROP-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    'TEN-' || LPAD((1 + MOD(SEQ4(), 20))::VARCHAR, 5, '0'),
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Triple Net (NNN)'
        WHEN 1 THEN 'Double Net (NN)'
        WHEN 2 THEN 'Modified Gross'
        WHEN 3 THEN 'Absolute Net'
    END,
    DATEADD('day', -MOD(SEQ4() * 37, 3650), '2025-01-01')::DATE,
    DATEADD('day', MOD(SEQ4() * 53, 7300), '2025-01-01')::DATE,
    5000 + MOD(SEQ4() * 431, 95000)::NUMBER(12,2),
    (5000 + MOD(SEQ4() * 431, 95000)) * 12::NUMBER(14,2),
    1.0 + UNIFORM(0::FLOAT, 3.0::FLOAT, RANDOM()),
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Fixed Annual' WHEN 1 THEN 'CPI-Linked' WHEN 2 THEN 'Percentage Rent' END,
    120 + MOD(SEQ4() * 11, 180),
    12 + MOD(SEQ4() * 7, 168),
    1 + MOD(SEQ4(), 5),
    CASE WHEN MOD(SEQ4(), 4) < 3 THEN TRUE ELSE FALSE END,
    CASE WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.95 THEN 'Active' ELSE 'Expired' END
FROM TABLE(GENERATOR(ROWCOUNT => 500));

INSERT INTO FINANCIAL_METRICS (METRIC_ID, PROPERTY_ID, FISCAL_YEAR, FISCAL_QUARTER, REPORTING_DATE, GROSS_REVENUE, NET_OPERATING_INCOME, OPERATING_EXPENSES, CAPITAL_EXPENDITURES, FUNDS_FROM_OPERATIONS, ADJUSTED_FFO, DEBT_SERVICE, OCCUPANCY_RATE, RENT_COLLECTION_RATE, SAME_STORE_NOI_GROWTH)
SELECT
    'FM-' || LPAD(SEQ4()::VARCHAR, 6, '0'),
    'PROP-' || LPAD((1 + MOD(SEQ4(), 500))::VARCHAR, 5, '0'),
    2020 + MOD(SEQ4(), 6),
    1 + MOD(SEQ4(), 4),
    DATEADD('quarter', MOD(SEQ4(), 24), '2020-01-01')::DATE,
    50000 + MOD(SEQ4() * 197, 450000)::NUMBER(14,2),
    35000 + MOD(SEQ4() * 143, 315000)::NUMBER(14,2),
    10000 + MOD(SEQ4() * 67, 135000)::NUMBER(14,2),
    1000 + MOD(SEQ4() * 23, 49000)::NUMBER(14,2),
    30000 + MOD(SEQ4() * 131, 290000)::NUMBER(14,2),
    28000 + MOD(SEQ4() * 127, 272000)::NUMBER(14,2),
    8000 + MOD(SEQ4() * 41, 72000)::NUMBER(14,2),
    90.0 + UNIFORM(0::FLOAT, 10::FLOAT, RANDOM()),
    95.0 + UNIFORM(0::FLOAT, 5::FLOAT, RANDOM()),
    -2.0 + UNIFORM(0::FLOAT, 8::FLOAT, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 3000));

INSERT INTO PORTFOLIO_SUMMARY (SUMMARY_ID, REPORTING_DATE, TOTAL_PROPERTIES, TOTAL_SQUARE_FOOTAGE, PORTFOLIO_OCCUPANCY_RATE, WEIGHTED_AVG_LEASE_TERM, TOTAL_ANNUALIZED_RENT, INVESTMENT_GRADE_TENANTS_PCT, DIVERSIFICATION_SCORE, TOTAL_DEBT, DEBT_TO_EBITDA_RATIO, INTEREST_COVERAGE_RATIO, DIVIDEND_PER_SHARE, FFO_PER_SHARE, AFFO_PER_SHARE, PAYOUT_RATIO)
VALUES
    ('PS-001', '2020-03-31', 6483, 108000000, 97.9, 9.2, 3200000000, 51.2, 78.5, 11200000000, 5.4, 4.1, 0.7035, 0.87, 0.82, 85.8),
    ('PS-002', '2020-06-30', 6541, 109200000, 97.8, 9.1, 3240000000, 51.5, 78.8, 11350000000, 5.5, 4.0, 0.7035, 0.84, 0.79, 89.1),
    ('PS-003', '2020-09-30', 6592, 110400000, 97.9, 9.0, 3280000000, 51.8, 79.1, 11500000000, 5.4, 4.2, 0.7035, 0.88, 0.83, 84.8),
    ('PS-004', '2020-12-31', 6668, 111800000, 98.0, 8.9, 3320000000, 52.0, 79.4, 11650000000, 5.3, 4.3, 0.7050, 0.89, 0.84, 83.9),
    ('PS-005', '2021-03-31', 6756, 113500000, 98.0, 9.0, 3400000000, 52.3, 79.8, 12100000000, 5.3, 4.4, 0.7110, 0.91, 0.86, 82.7),
    ('PS-006', '2021-06-30', 6888, 115200000, 98.2, 9.1, 3500000000, 52.5, 80.1, 12400000000, 5.2, 4.5, 0.7110, 0.93, 0.88, 80.8),
    ('PS-007', '2021-09-30', 7020, 117000000, 98.3, 9.2, 3610000000, 52.8, 80.5, 12700000000, 5.2, 4.5, 0.7170, 0.95, 0.90, 79.7),
    ('PS-008', '2021-12-31', 7150, 119000000, 98.5, 9.3, 3720000000, 53.0, 80.9, 13000000000, 5.1, 4.6, 0.7230, 0.98, 0.93, 77.7),
    ('PS-009', '2022-03-31', 7290, 121500000, 98.4, 9.4, 3850000000, 53.5, 81.2, 13500000000, 5.2, 4.4, 0.7380, 1.00, 0.95, 77.7),
    ('PS-010', '2022-06-30', 7440, 124000000, 98.6, 9.5, 3980000000, 53.8, 81.5, 13800000000, 5.1, 4.5, 0.7440, 1.02, 0.97, 76.7),
    ('PS-011', '2022-09-30', 7590, 126500000, 98.7, 9.6, 4110000000, 54.0, 81.8, 14100000000, 5.0, 4.6, 0.7500, 1.04, 0.99, 75.8),
    ('PS-012', '2022-12-31', 7750, 129200000, 98.8, 9.7, 4250000000, 54.3, 82.1, 14500000000, 5.0, 4.7, 0.7560, 1.06, 1.01, 74.9),
    ('PS-013', '2023-03-31', 7920, 132000000, 98.7, 9.8, 4400000000, 54.5, 82.4, 15000000000, 5.1, 4.5, 0.7650, 1.03, 0.98, 78.1),
    ('PS-014', '2023-06-30', 8100, 135000000, 98.8, 9.9, 4560000000, 54.8, 82.7, 15400000000, 5.0, 4.6, 0.7650, 1.05, 1.00, 76.5),
    ('PS-015', '2023-09-30', 8280, 138000000, 98.9, 10.0, 4720000000, 55.0, 83.0, 15800000000, 4.9, 4.7, 0.7710, 1.07, 1.02, 75.6),
    ('PS-016', '2023-12-31', 8450, 141000000, 99.0, 10.1, 4880000000, 55.2, 83.3, 16200000000, 4.9, 4.8, 0.7770, 1.09, 1.04, 74.7),
    ('PS-017', '2024-03-31', 8620, 144000000, 98.8, 10.2, 5050000000, 55.5, 83.6, 16600000000, 4.8, 4.8, 0.7830, 1.11, 1.06, 73.9),
    ('PS-018', '2024-06-30', 8790, 147000000, 98.9, 10.3, 5220000000, 55.8, 83.9, 17000000000, 4.8, 4.9, 0.7890, 1.13, 1.08, 73.1),
    ('PS-019', '2024-09-30', 8950, 150000000, 99.0, 10.4, 5390000000, 56.0, 84.2, 17400000000, 4.7, 5.0, 0.7950, 1.15, 1.10, 72.3),
    ('PS-020', '2024-12-31', 9100, 153000000, 99.1, 10.5, 5560000000, 56.2, 84.5, 17800000000, 4.7, 5.0, 0.8010, 1.17, 1.12, 71.5),
    ('PS-021', '2025-03-31', 9250, 156000000, 99.0, 10.6, 5730000000, 56.5, 84.8, 18100000000, 4.6, 5.1, 0.8070, 1.19, 1.14, 70.8),
    ('PS-022', '2025-06-30', 9400, 159000000, 99.1, 10.7, 5900000000, 56.7, 85.1, 18400000000, 4.6, 5.1, 0.8130, 1.21, 1.16, 70.1);

INSERT INTO MARKET_DATA (MARKET_ID, MARKET_DATE, STOCK_PRICE, MARKET_CAP, DIVIDEND_YIELD, PRICE_TO_FFO, PRICE_TO_AFFO, TOTAL_RETURN_YTD, BETA, VOLUME, SP500_RETURN_YTD, TREASURY_10Y_YIELD, SPREAD_TO_TREASURY)
SELECT
    'MKT-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    DATEADD('day', SEQ4(), '2020-01-02')::DATE,
    50.0 + UNIFORM(-5::FLOAT, 25::FLOAT, RANDOM()),
    35000000000 + UNIFORM(-5000000000::FLOAT, 20000000000::FLOAT, RANDOM())::NUMBER(18,2),
    3.5 + UNIFORM(0::FLOAT, 2.5::FLOAT, RANDOM()),
    13.0 + UNIFORM(-2::FLOAT, 5::FLOAT, RANDOM()),
    14.0 + UNIFORM(-2::FLOAT, 5::FLOAT, RANDOM()),
    UNIFORM(-15::FLOAT, 25::FLOAT, RANDOM()),
    0.6 + UNIFORM(0::FLOAT, 0.4::FLOAT, RANDOM()),
    3000000 + UNIFORM(0::FLOAT, 12000000::FLOAT, RANDOM())::NUMBER(14,0),
    UNIFORM(-10::FLOAT, 30::FLOAT, RANDOM()),
    1.0 + UNIFORM(0::FLOAT, 4.0::FLOAT, RANDOM()),
    1.5 + UNIFORM(0::FLOAT, 2.5::FLOAT, RANDOM())
FROM TABLE(GENERATOR(ROWCOUNT => 1400));

INSERT INTO DOCUMENTS (DOC_ID, DOC_TYPE, DOC_TITLE, DOC_DATE, FISCAL_YEAR, FISCAL_QUARTER, CONTENT, SUMMARY, SOURCE_URL)
VALUES
    ('DOC-001', 'Earnings Call', 'Q4 2024 Earnings Call Transcript', '2025-02-20', 2024, 4,
     'Realty Income reported strong Q4 2024 results with AFFO per share of $1.12, representing 7.7% year-over-year growth. The company completed $2.1 billion in acquisitions during the quarter at a weighted average cash cap rate of 7.1%. Portfolio occupancy remained at 99.1% with rent recapture rate of 105.2% on re-leasing activity. The company raised its 2025 AFFO guidance to $4.28-$4.35 per share. CEO Sumit Roy highlighted the companys European expansion and gaming portfolio diversification. The balance sheet remains well-positioned with net debt to annualized pro forma adjusted EBITDAre of 4.7x.',
     'Strong Q4 with 7.7% AFFO growth, $2.1B acquisitions at 7.1% cap rate, 99.1% occupancy, raised 2025 guidance.',
     'https://investor.realtyincome.com/events/q4-2024'),
    ('DOC-002', 'Earnings Call', 'Q3 2024 Earnings Call Transcript', '2024-11-04', 2024, 3,
     'Realty Income delivered solid Q3 2024 results with AFFO per share of $1.10. Investment volume totaled $1.8 billion at an average initial cash yield of 7.3%. The company expanded its European presence with the acquisition of a portfolio of 82 convenience retail properties. Same-store rental revenue growth was 1.5%. The company maintained its investment-grade credit ratings and ended the quarter with approximately $4.2 billion in available liquidity.',
     'Solid Q3 with $1.10 AFFO/share, $1.8B investments at 7.3% yield, European expansion, 1.5% same-store growth.',
     'https://investor.realtyincome.com/events/q3-2024'),
    ('DOC-003', 'Earnings Call', 'Q2 2024 Earnings Call Transcript', '2024-08-05', 2024, 2,
     'Realty Income reported Q2 2024 AFFO per share of $1.08, a 5.9% increase year-over-year. The company invested $1.5 billion during the quarter primarily in single-tenant retail and industrial properties. Portfolio occupancy was 98.9% and the company completed 171 lease renewals with a rent recapture rate of 104.8%. Management noted strengthening deal flow in both domestic and international markets.',
     'Q2 AFFO $1.08/share (+5.9% YoY), $1.5B invested, 98.9% occupancy, 104.8% rent recapture on renewals.',
     'https://investor.realtyincome.com/events/q2-2024'),
    ('DOC-004', 'Earnings Call', 'Q1 2024 Earnings Call Transcript', '2024-05-06', 2024, 1,
     'Realty Income reported Q1 2024 results with AFFO per share of $1.06. The company completed $1.9 billion in acquisitions including a significant industrial portfolio. Portfolio occupancy reached 98.8% across 15,450 properties. The weighted average remaining lease term was 10.2 years. The company continued its monthly dividend tradition, increasing it for the 107th time since its NYSE listing.',
     'Q1 AFFO $1.06/share, $1.9B acquisitions including industrial, 98.8% occupancy, 107th dividend increase.',
     'https://investor.realtyincome.com/events/q1-2024'),
    ('DOC-005', 'SEC Filing', '2024 Annual Report (10-K)', '2025-02-28', 2024, 4,
     'Realty Incomes 2024 annual report details a portfolio of over 15,450 commercial properties across all 50 US states, the UK, and six European countries. Total revenue reached $5.56 billion with net income of $1.8 billion. The company invested $8.1 billion during 2024 at a weighted average initial cash yield of 7.2%. Key risk factors include interest rate sensitivity, tenant credit risk, geographic concentration, and regulatory changes in international markets. The company maintains an A3/A- credit rating.',
     'Annual 10-K: 15,450+ properties, $5.56B revenue, $8.1B invested at 7.2% yield, A3/A- rated.',
     'https://investor.realtyincome.com/sec-filings/10-K-2024'),
    ('DOC-006', 'Investor Presentation', 'Q4 2024 Investor Presentation', '2025-02-20', 2024, 4,
     'Key highlights from the Q4 2024 investor deck: Realty Income is the global leader in net lease REITs with over $73 billion in total enterprise value. The portfolio generates $5.9 billion in annualized contractual rent. 36% of rent comes from investment-grade rated tenants. The company has delivered 5.3% compound annual total return since 1994. Top tenant industries include grocery (10.4%), convenience stores (9.8%), dollar stores (7.3%), home improvement (5.1%), and drug stores (4.8%). International properties represent approximately 15% of annualized rent.',
     'Global net lease leader: $73B enterprise value, $5.9B annualized rent, 36% investment-grade, 5.3% CAGR since 1994.',
     'https://investor.realtyincome.com/presentations/q4-2024'),
    ('DOC-007', 'Research Report', 'REIT Sector Outlook 2025', '2025-01-15', 2025, 1,
     'The net lease REIT sector is well-positioned for 2025 as interest rates stabilize. Realty Income remains the bellwether with its diversified portfolio and strong credit metrics. Key themes include: (1) European expansion providing growth runway, (2) data center and gaming properties as emerging asset classes, (3) potential for accretive acquisitions as smaller REITs face refinancing pressures, (4) defensive positioning given economic uncertainty. Analysts consensus price target implies 15-20% upside from current levels.',
     '2025 outlook positive: rate stabilization benefits net lease, European growth, data center/gaming diversification opportunities.',
     'https://research.example.com/reit-outlook-2025'),
    ('DOC-008', 'SEC Filing', 'Q3 2024 Quarterly Report (10-Q)', '2024-11-08', 2024, 3,
     'Realty Income 10-Q for Q3 2024 shows total revenues of $1.33 billion for the quarter. Net income attributable to common stockholders was $261 million. Total assets reached $68.3 billion. The company had $26.4 billion in total debt with a weighted average interest rate of 3.8% and weighted average maturity of 6.2 years. During the quarter, the company issued $1.5 billion in senior unsecured notes.',
     'Q3 10-Q: $1.33B revenue, $261M net income, $68.3B assets, 3.8% avg debt rate, 6.2yr avg maturity.',
     'https://investor.realtyincome.com/sec-filings/10-Q-Q3-2024'),
    ('DOC-009', 'Press Release', 'Spirit Realty Capital Merger Completion', '2024-01-23', 2024, 1,
     'Realty Income completed its merger with Spirit Realty Capital on January 23, 2024. The all-stock transaction valued Spirit at approximately $9.3 billion. The merger adds 2,037 properties to Realty Incomes portfolio, enhancing diversification across tenants, industries, and geography. Expected annual synergies of approximately $50 million. The combined entity has a pro forma enterprise value exceeding $65 billion.',
     'Spirit Realty merger complete: $9.3B deal adds 2,037 properties, $50M annual synergies, $65B+ combined enterprise value.',
     'https://investor.realtyincome.com/press-releases/spirit-merger'),
    ('DOC-010', 'ESG Report', '2024 Sustainability Report', '2025-03-15', 2024, 4,
     'Realty Incomes 2024 ESG report outlines progress toward carbon neutrality goals. 42% of properties now have energy efficiency certifications. The company invested $120 million in green building improvements during 2024. Social initiatives include $15 million in community development funding. Governance highlights include 89% independent board members, annual board diversity assessment, and enhanced cybersecurity protocols. The company targets a 50% reduction in Scope 1 and 2 emissions by 2030.',
     'ESG progress: 42% energy certified, $120M green investments, 50% emission reduction target by 2030, 89% board independence.',
     'https://investor.realtyincome.com/esg-2024');

INSERT INTO RISK_ASSESSMENTS (RISK_ID, PROPERTY_ID, ASSESSMENT_DATE, RISK_CATEGORY, RISK_SCORE, RISK_LEVEL, GEOGRAPHIC_RISK, TENANT_CREDIT_RISK, MARKET_RISK, INTEREST_RATE_RISK, ENVIRONMENTAL_RISK, LEASE_EXPIRATION_RISK, NOTES)
SELECT
    'RSK-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    'PROP-' || LPAD((1 + MOD(SEQ4(), 500))::VARCHAR, 5, '0'),
    DATEADD('day', -MOD(SEQ4() * 17, 365), CURRENT_DATE())::DATE,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'Credit Risk'
        WHEN 1 THEN 'Market Risk'
        WHEN 2 THEN 'Geographic Risk'
        WHEN 3 THEN 'Environmental Risk'
        WHEN 4 THEN 'Operational Risk'
    END,
    UNIFORM(10::FLOAT, 95::FLOAT, RANDOM()),
    CASE
        WHEN UNIFORM(0::FLOAT, 100::FLOAT, RANDOM()) < 60 THEN 'Low'
        WHEN UNIFORM(0::FLOAT, 100::FLOAT, RANDOM()) < 85 THEN 'Medium'
        ELSE 'High'
    END,
    UNIFORM(5::FLOAT, 40::FLOAT, RANDOM()),
    UNIFORM(10::FLOAT, 50::FLOAT, RANDOM()),
    UNIFORM(15::FLOAT, 60::FLOAT, RANDOM()),
    UNIFORM(20::FLOAT, 70::FLOAT, RANDOM()),
    UNIFORM(5::FLOAT, 35::FLOAT, RANDOM()),
    UNIFORM(10::FLOAT, 55::FLOAT, RANDOM()),
    CASE MOD(SEQ4(), 4)
        WHEN 0 THEN 'Tenant showing stable financial performance with consistent revenue growth.'
        WHEN 1 THEN 'Property located in growing market with strong demographic trends.'
        WHEN 2 THEN 'Lease expiration within 24 months requires monitoring for renewal probability.'
        WHEN 3 THEN 'Environmental assessment completed with no material findings.'
    END
FROM TABLE(GENERATOR(ROWCOUNT => 1000));

INSERT INTO MAINTENANCE_RECORDS (MAINTENANCE_ID, PROPERTY_ID, MAINTENANCE_TYPE, DESCRIPTION, SCHEDULED_DATE, COMPLETED_DATE, ESTIMATED_COST, ACTUAL_COST, VENDOR, STATUS, PRIORITY)
SELECT
    'MNT-' || LPAD(SEQ4()::VARCHAR, 5, '0'),
    'PROP-' || LPAD((1 + MOD(SEQ4(), 500))::VARCHAR, 5, '0'),
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'HVAC'
        WHEN 1 THEN 'Roof Repair'
        WHEN 2 THEN 'Parking Lot'
        WHEN 3 THEN 'Electrical'
        WHEN 4 THEN 'Plumbing'
        WHEN 5 THEN 'Exterior Paint'
    END,
    CASE MOD(SEQ4(), 6)
        WHEN 0 THEN 'Annual HVAC system inspection and filter replacement'
        WHEN 1 THEN 'Roof membrane repair and drainage inspection'
        WHEN 2 THEN 'Parking lot resurfacing and striping'
        WHEN 3 THEN 'Electrical panel upgrade and safety inspection'
        WHEN 4 THEN 'Main water line repair and backflow prevention'
        WHEN 5 THEN 'Exterior building paint refresh and power washing'
    END,
    DATEADD('day', -MOD(SEQ4() * 13, 730), CURRENT_DATE())::DATE,
    CASE WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.7
        THEN DATEADD('day', -MOD(SEQ4() * 11, 700), CURRENT_DATE())::DATE
        ELSE NULL END,
    5000 + MOD(SEQ4() * 197, 95000)::NUMBER(12,2),
    CASE WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.7
        THEN (5000 + MOD(SEQ4() * 197, 95000)) * (0.8 + UNIFORM(0::FLOAT, 0.5::FLOAT, RANDOM()))::NUMBER(12,2)
        ELSE NULL END,
    CASE MOD(SEQ4(), 5)
        WHEN 0 THEN 'National Maintenance Corp'
        WHEN 1 THEN 'ProBuild Services LLC'
        WHEN 2 THEN 'Allied Facility Solutions'
        WHEN 3 THEN 'CRE Maintenance Group'
        WHEN 4 THEN 'Premier Property Services'
    END,
    CASE
        WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.7 THEN 'Completed'
        WHEN UNIFORM(0::FLOAT, 1::FLOAT, RANDOM()) < 0.85 THEN 'In Progress'
        ELSE 'Scheduled'
    END,
    CASE MOD(SEQ4(), 3) WHEN 0 THEN 'Low' WHEN 1 THEN 'Medium' WHEN 2 THEN 'High' END
FROM TABLE(GENERATOR(ROWCOUNT => 800));
