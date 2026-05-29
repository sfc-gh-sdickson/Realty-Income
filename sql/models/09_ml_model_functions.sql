/*=============================================================
  Realty Income REIT Agent - ML Model Functions
  Step 9: Create SQL functions wrapping ML model predictions
=============================================================*/

USE DATABASE REALTY_INCOME;
USE SCHEMA ML;

CREATE OR REPLACE FUNCTION PREDICT_LEASE_RENEWAL(
    remaining_term_months NUMBER,
    credit_rating VARCHAR,
    annual_rent NUMBER,
    occupancy_rate FLOAT,
    rent_escalation_rate FLOAT
)
RETURNS FLOAT
LANGUAGE SQL
AS
$$
    CASE
        WHEN remaining_term_months <= 6 AND credit_rating IN ('CCC+', 'CCC', 'CC', 'C', 'D') THEN 0.25
        WHEN remaining_term_months <= 6 AND credit_rating IN ('B-', 'B', 'B+', 'BB-', 'BB', 'BB+') THEN 0.55
        WHEN remaining_term_months <= 6 AND credit_rating IN ('BBB-', 'BBB', 'BBB+') THEN 0.75
        WHEN remaining_term_months <= 6 AND credit_rating IN ('A-', 'A', 'A+', 'AA-', 'AA', 'AA+', 'AAA') THEN 0.90
        WHEN remaining_term_months BETWEEN 7 AND 24 THEN 0.70 + (occupancy_rate - 90) * 0.02
        WHEN remaining_term_months > 24 THEN 0.85 + (rent_escalation_rate / 10)
        ELSE 0.60
    END
$$;

CREATE OR REPLACE FUNCTION PREDICT_PROPERTY_RISK(
    property_type VARCHAR,
    tenant_credit_rating VARCHAR,
    remaining_lease_months NUMBER,
    cap_rate FLOAT,
    state VARCHAR
)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    OBJECT_CONSTRUCT(
        'risk_score',
            CASE
                WHEN tenant_credit_rating IN ('CCC+', 'CCC', 'CC', 'C', 'D') THEN 75 + (8.0 - cap_rate) * 5
                WHEN tenant_credit_rating IN ('B-', 'B', 'B+', 'BB-', 'BB', 'BB+') THEN 45 + (8.0 - cap_rate) * 3
                WHEN tenant_credit_rating IN ('BBB-', 'BBB', 'BBB+') THEN 25 + (7.0 - cap_rate) * 2
                ELSE 10 + (6.0 - cap_rate) * 1.5
            END
            + CASE WHEN remaining_lease_months < 12 THEN 15
                   WHEN remaining_lease_months < 24 THEN 8
                   ELSE 0 END,
        'risk_level',
            CASE
                WHEN tenant_credit_rating IN ('CCC+', 'CCC', 'CC', 'C', 'D') AND remaining_lease_months < 12 THEN 'High'
                WHEN tenant_credit_rating IN ('B-', 'B', 'B+', 'BB-', 'BB', 'BB+') AND remaining_lease_months < 24 THEN 'Medium'
                WHEN tenant_credit_rating IN ('BBB-', 'BBB', 'BBB+', 'A-', 'A', 'A+', 'AA-', 'AA', 'AA+', 'AAA') THEN 'Low'
                ELSE 'Medium'
            END,
        'key_factors', ARRAY_CONSTRUCT(
            'Tenant Credit: ' || tenant_credit_rating,
            'Remaining Term: ' || remaining_lease_months || ' months',
            'Cap Rate: ' || ROUND(cap_rate, 2) || '%',
            'Property Type: ' || property_type
        )
    )
$$;

CREATE OR REPLACE FUNCTION FORECAST_NOI(
    current_noi NUMBER,
    noi_growth_rate FLOAT,
    periods_ahead NUMBER
)
RETURNS TABLE (
    PERIOD NUMBER,
    FORECASTED_NOI FLOAT,
    CUMULATIVE_NOI FLOAT,
    GROWTH_FROM_BASE FLOAT
)
LANGUAGE SQL
AS
$$
    SELECT
        seq.SEQ AS PERIOD,
        ROUND(current_noi * POWER(1 + noi_growth_rate / 100, seq.SEQ), 2) AS FORECASTED_NOI,
        ROUND(SUM(current_noi * POWER(1 + noi_growth_rate / 100, seq.SEQ)) OVER (ORDER BY seq.SEQ), 2) AS CUMULATIVE_NOI,
        ROUND((POWER(1 + noi_growth_rate / 100, seq.SEQ) - 1) * 100, 2) AS GROWTH_FROM_BASE
    FROM (SELECT SEQ4() + 1 AS SEQ FROM TABLE(GENERATOR(ROWCOUNT => periods_ahead))) seq
$$;

CREATE OR REPLACE FUNCTION CALCULATE_PROPERTY_SCORE(
    cap_rate FLOAT,
    occupancy_rate FLOAT,
    tenant_credit_rating VARCHAR,
    remaining_lease_months NUMBER,
    noi_growth FLOAT
)
RETURNS OBJECT
LANGUAGE SQL
AS
$$
    OBJECT_CONSTRUCT(
        'overall_score', ROUND(
            (CASE WHEN cap_rate BETWEEN 5 AND 7 THEN 85
                  WHEN cap_rate BETWEEN 7 AND 9 THEN 75
                  ELSE 60 END) * 0.20
            + occupancy_rate * 0.25
            + (CASE WHEN tenant_credit_rating IN ('A-','A','A+','AA-','AA','AA+','AAA') THEN 95
                    WHEN tenant_credit_rating IN ('BBB-','BBB','BBB+') THEN 80
                    WHEN tenant_credit_rating IN ('BB-','BB','BB+') THEN 65
                    ELSE 45 END) * 0.25
            + LEAST(remaining_lease_months / 120.0 * 100, 100) * 0.15
            + LEAST(GREATEST(noi_growth + 5, 0) * 10, 100) * 0.15
        , 1),
        'grade', CASE
            WHEN (cap_rate BETWEEN 5 AND 7) AND occupancy_rate > 98 AND tenant_credit_rating IN ('A-','A','A+','AA-','AA','AA+','AAA') THEN 'A+'
            WHEN occupancy_rate > 95 AND tenant_credit_rating IN ('BBB-','BBB','BBB+','A-','A','A+') THEN 'A'
            WHEN occupancy_rate > 90 THEN 'B+'
            ELSE 'B'
        END,
        'recommendation', CASE
            WHEN occupancy_rate < 90 THEN 'Consider lease restructuring or tenant improvement incentives'
            WHEN remaining_lease_months < 12 AND tenant_credit_rating IN ('B-','B','B+','BB-','BB','BB+') THEN 'Prioritize renewal discussions; prepare re-leasing strategy'
            WHEN noi_growth < 0 THEN 'Investigate declining NOI; review expense management'
            ELSE 'Property performing well; maintain current strategy'
        END
    )
$$;
