-- ============================================================
-- PHASE 5 — SQL BUSINESS ANALYSIS
-- Credit Risk Analytics & Loan Default Prediction
-- ============================================================


-- ============================================================
-- 5.1 Overall Default Rate
-- ============================================================

-- Business Question:
-- What percentage of loans in the portfolio resulted in default?

-- Business Purpose:
-- Establish the overall default rate as the baseline measure
-- of credit risk in the portfolio.


SELECT
    COUNT(*) AS total_loans,
    SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS default_loans,
    ROUND(
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),2
        ) AS default_rate_pct
    FROM loans;


-- ============================================================
-- 5.2 Default Rate by Loan Purpose
-- ============================================================

-- Business Question:
-- Which loan purposes have higher or lower default rates?

-- Business Purpose:
-- Compare observed default rates across different loan-purpose
-- categories.

 SELECT
        purpose,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS default_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),2
            ) AS default_rate_pct
        FROM loans
        GROUP BY purpose
        ORDER BY default_rate_pct DESC;


-- ============================================================
-- 5.3 Default Rate by FICO Category
-- ============================================================

-- Business Question:
-- How does observed default rate vary across different
-- FICO score categories?

-- Business Purpose:
-- Evaluate whether borrowers with different levels of credit
-- quality show different historical default rates.



  SELECT
        CASE
            WHEN fico_n < 650 THEN 'Poor'
            WHEN fico_n BETWEEN 650 AND 699 THEN 'Fair'
            WHEN fico_n BETWEEN 700 AND 749 THEN 'Good'
            ELSE 'Excelent'
        END AS fico_category,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
            ) AS default_rate_pct
        FROM loans
        GROUP BY fico_category
        ORDER BY default_rate_pct DESC;

-- ============================================================
-- 5.4 Default Rate by DTI Category
-- ============================================================

-- Business Question:
-- How does observed default rate change across different
-- debt-to-income (DTI) categories?

-- Business Purpose:
-- Evaluate whether borrowers with higher DTI levels show
-- higher historical default rates.



SELECT
        CASE
            WHEN dti_n < 10 THEN '<10'
            WHEN dti_n BETWEEN 10 AND 19.99 THEN '10-20'
            WHEN dti_n BETWEEN 20 AND 29.99 THEN '20-30'
            WHEN dti_n BETWEEN 30 AND 39.99 THEN '30-40'
            ELSE '40+'
        END AS dti_category,

        COUNT(*) AS total_loans,

        SUM(
            CASE
                WHEN "Default" = 1 THEN 1
                ELSE 0
            END
        ) AS defaulted_loans,

        ROUND(
            SUM(
                CASE
                    WHEN "Default" = 1 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS default_rate_pct

    FROM loans

    WHERE dti_n IS NOT NULL

    GROUP BY dti_category

    ORDER BY default_rate_pct DESC;

-- ============================================================
-- 5.5 Default Rate by Loan Amount
-- ============================================================

-- Business Question:
-- How does observed default rate vary across different
-- loan amount bands?

-- Business Purpose:
-- Determine whether larger or smaller loans are associated
-- with different historical default rates.


 SELECT
        CASE
            WHEN loan_amnt < 5000 THEN '<5k'
            WHEN loan_amnt BETWEEN 5000 AND 10000 THEN '5k-10k'
            WHEN loan_amnt BETWEEN 10000 AND 20000 THEN '10k-20k'
            WHEN loan_amnt BETWEEN 20000 AND 30000 THEN '20k-30k'
            ELSE '30k+'
        END AS loan_amnt_band,
        COUNT(*) AS total_loan,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),2
            ) AS default_rate_pct
        FROM loans
        GROUP BY loan_amnt_band
        ORDER BY default_rate_pct DESC;



-- ============================================================
-- 5.6 Default Rate by Employment Length
-- ============================================================

-- Business Question:
-- Does observed default rate vary across different
-- employment-length categories?

-- Business Purpose:
-- Examine whether employment history is associated with
-- differences in historical loan default rates.




SELECT
        emp_length,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) *100.0
            /COUNT(*),2
        ) AS default_rate_pct
    FROM loans
    GROUP BY emp_length
    ORDER BY default_rate_pct DESC;



-- ============================================================
-- 5.7 Default Rate by Home Ownership
-- ============================================================

-- Business Question:
-- How does observed default rate differ across borrower
-- home-ownership categories?

-- Business Purpose:
-- Compare historical default patterns among different
-- home-ownership groups.



 SELECT
        home_ownership_n,
        COUNT(*) AS total_loans,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
        ) AS default_rate_pct
    FROM loans
    GROUP BY home_ownership_n
    ORDER BY default_rate_pct DESC;


-- ============================================================
-- 5.8 Default Rate by State
-- ============================================================

-- Business Question:
-- Which borrower states have relatively higher or lower
-- observed loan default rates?

-- Business Purpose:
-- Examine geographic variation in historical default rates
-- across borrower states.


SELECT
        addr_state,
        COUNT(*) AS total_loans,

        SUM(
            CASE
                WHEN "Default" = 1 THEN 1
                ELSE 0
            END
        ) AS defaulted_loans,

        ROUND(
            SUM(
                CASE
                    WHEN "Default" = 1 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS default_rate_pct

    FROM loans

    GROUP BY addr_state

    ORDER BY default_rate_pct DESC;


-- ============================================================
-- 5.9 Default Rate by Year
-- ============================================================

-- Business Question:
-- How has the observed loan default rate changed across
-- different issue years?

-- Business Purpose:
-- Identify changes in historical default patterns over time.



 SELECT
        SUBSTR(issue_d, 1, 4) AS issue_year,
         COUNT(*) AS total_loans,
        SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) AS defaulted_loans,
        ROUND(
            SUM(CASE WHEN "Default" = 1 THEN 1 ELSE 0 END) * 100.0
            / COUNT(*),
            2
        ) AS default_rate_pct
    FROM loans
    GROUP BY issue_year
    ORDER BY issue_year;



-- ============================================================
-- 5.12 Average FICO by Default Status
-- ============================================================

-- Business Question:
-- Do borrowers who default have a different average FICO
-- score compared with borrowers who do not default?

-- Business Purpose:
-- Compare average credit score between defaulted and
-- non-defaulted loans.


SELECT
        "Default",
        COUNT(*) AS total_loans,
        ROUND(AVG(loan_amnt), 2) AS average_loan_amount,
        MIN(loan_amnt) AS minimum_loan_amount,
        MAX(loan_amnt) AS maximum_loan_amount
    FROM loans
    GROUP BY "Default"
    ORDER BY "Default";


-- ============================================================
-- 5.11 Higher-Risk Borrower Segments
-- ============================================================

-- Business Question:
-- Which combinations of borrower credit quality and loan
-- amount show comparatively higher observed default rates?

-- Business Purpose:
-- Combine FICO category and loan amount band to identify
-- borrower segments with higher historical default rates.
--
-- Only segments with at least 1,000 loans are considered.

SELECT
        CASE
            WHEN fico_n < 650 THEN 'Poor'
            WHEN fico_n BETWEEN 650 AND 699 THEN 'Fair'
            WHEN fico_n BETWEEN 700 AND 749 THEN 'Good'
            ELSE 'Excellent'
        END AS fico_category,

        CASE
            WHEN loan_amnt < 5000 THEN '<5k'
            WHEN loan_amnt BETWEEN 5000 AND 9999 THEN '5k-10k'
            WHEN loan_amnt BETWEEN 10000 AND 19999 THEN '10k-20k'
            WHEN loan_amnt BETWEEN 20000 AND 29999 THEN '20k-30k'
            ELSE '30k+'
        END AS loan_amount_band,

        COUNT(*) AS total_loans,

        SUM(
            CASE
                WHEN "Default" =1 THEN 1 
                ELSE 0 
            END
        ) AS default_loans,
        
         ROUND(
            SUM(
                CASE
                    WHEN "Default" = 1 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*),
            2
        ) AS default_rate_pct

    FROM loans

    GROUP BY fico_category, loan_amount_band

    HAVING COUNT(*) >= 1000

    ORDER BY default_rate_pct DESC;


-- ============================================================
-- 5.14 High-Risk Segment Identification
-- ============================================================

-- Business Question:
-- How many loans belong to borrower segments whose observed
-- default rate is higher than the overall portfolio default rate?

-- Business Purpose:
-- Identify the portion of the portfolio represented by
-- comparatively higher-risk segments.

 WITH segment_analysis AS (
        SELECT
            CASE
                WHEN fico_n < 650 THEN 'Poor'
                WHEN fico_n BETWEEN 650 AND 699 THEN 'Fair'
                WHEN fico_n BETWEEN 700 AND 749 THEN 'Good'
                ELSE 'Excellent'
            END AS fico_category,

            CASE
                WHEN loan_amnt < 5000 THEN '<5k'
                WHEN loan_amnt BETWEEN 5000 AND 9999 THEN '5k-10k'
                WHEN loan_amnt BETWEEN 10000 AND 19999 THEN '10k-20k'
                WHEN loan_amnt BETWEEN 20000 AND 29999 THEN '20k-30k'
                ELSE '30k+'
            END AS loan_amount_band,

            COUNT(*) AS segment_loans,

            SUM(
                CASE
                    WHEN "Default" = 1 THEN 1
                    ELSE 0
                END
            ) AS segment_defaults,

            ROUND(
                SUM(
                    CASE
                        WHEN "Default" = 1 THEN 1
                        ELSE 0
                    END
                ) * 100.0 / COUNT(*),
                2
            ) AS segment_default_rate

        FROM loans

        GROUP BY fico_category, loan_amount_band

        HAVING COUNT(*) >= 1000
    ),

    portfolio_rate AS (
        SELECT
            SUM(
                CASE
                    WHEN "Default" = 1 THEN 1
                    ELSE 0
                END
            ) * 100.0 / COUNT(*) AS overall_default_rate
        FROM loans
    ),

    high_risk_segments AS (
        SELECT
            segment_loans
        FROM segment_analysis
        CROSS JOIN portfolio_rate
        WHERE segment_default_rate > overall_default_rate
    )

    SELECT
        SUM(segment_loans) AS high_risk_segment_loans,

        (SELECT COUNT(*) FROM loans) AS total_loans,

        ROUND(
            SUM(segment_loans) * 100.0 /
            (SELECT COUNT(*) FROM loans),
            2
        ) AS high_risk_loan_share_pct

    FROM high_risk_segments;