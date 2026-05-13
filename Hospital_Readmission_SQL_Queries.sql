USE Hospital_Readmission_Analysis;
GO
-- Query 1: Total Overview
SELECT 
    COUNT(*) AS Total_Encounters,
    COUNT(DISTINCT Patient_ID) AS Unique_Patients
FROM dbo.Patient_Encounters;

-- Query 2: Readmission Breakdown
SELECT 
    Readmission_Group,
    COUNT(*) AS Total_Count,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) AS Percentage
FROM dbo.Patient_Encounters
GROUP BY Readmission_Group
ORDER BY Total_Count DESC;

-- Query 3: 30-Day Readmission Rate
SELECT 
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) 
    AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters;

-- Query 4: Age Group Analysis
SELECT 
    age,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY age
ORDER BY age;

-- Query 5: Readmission Rate by Length of Stay Group
SELECT 
    CASE 
        WHEN Length_of_Stay BETWEEN 1 AND 3 THEN 'Short Stay'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay'
        ELSE 'Long Stay'
    END AS Stay_Group,
    
    COUNT(*) AS Total,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted,
    
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Rate

FROM dbo.Patient_Encounters
GROUP BY 
    CASE 
        WHEN Length_of_Stay BETWEEN 1 AND 3 THEN 'Short Stay'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay'
        ELSE 'Long Stay'
    END
ORDER BY Rate DESC;

-- Query 6: Readmission Rate by Medication Count Group
SELECT 
    CASE
        WHEN Medications BETWEEN 1 AND 10 THEN 'Low Medication Count (1-10)'
        WHEN Medications BETWEEN 11 AND 20 THEN 'Medium Medication Count (11-20)'
        ELSE 'High Medication Count (21+)'
    END AS Medication_Group,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY
    CASE
        WHEN Medications BETWEEN 1 AND 10 THEN 'Low Medication Count (1-10)'
        WHEN Medications BETWEEN 11 AND 20 THEN 'Medium Medication Count (11-20)'
        ELSE 'High Medication Count (21+)'
    END
ORDER BY Readmission_30_Day_Rate DESC;

-- Query 7: Readmission Rate by Emergency Visit Group
SELECT 
    CASE
        WHEN Emergency_Visits = 0 THEN 'No Emergency Visit'
        WHEN Emergency_Visits BETWEEN 1 AND 2 THEN '1-2 Emergency Visits'
        ELSE '3+ Emergency Visits'
    END AS Emergency_Visit_Group,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY
    CASE
        WHEN Emergency_Visits = 0 THEN 'No Emergency Visit'
        WHEN Emergency_Visits BETWEEN 1 AND 2 THEN '1-2 Emergency Visits'
        ELSE '3+ Emergency Visits'
    END
ORDER BY Readmission_30_Day_Rate DESC;


-- Query 8: Readmission Rate by Diabetes Medication Status
SELECT 
    diabetesMed,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY diabetesMed

-- Query 9: Readmission Rate by A1C Result
SELECT 
    A1Cresult,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY A1Cresult
ORDER BY Readmission_30_Day_Rate DESC;

-- Query 10: High-Risk Patient Segments
SELECT 
    age,
    CASE 
        WHEN Length_of_Stay BETWEEN 1 AND 3 THEN 'Short Stay (1-3 days)'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay (4-7 days)'
        ELSE 'Long Stay (8+ days)'
    END AS Stay_Group,
    CASE
        WHEN Emergency_Visits = 0 THEN 'No Emergency Visit'
        WHEN Emergency_Visits BETWEEN 1 AND 2 THEN '1-2 Emergency Visits'
        ELSE '3+ Emergency Visits'
    END AS Emergency_Visit_Group,
    COUNT(*) AS Total_Encounters,
    SUM(CAST(Readmitted_30_Day_Flag AS INT)) AS Readmitted_Within_30_Days,
    ROUND(100.0 * SUM(CAST(Readmitted_30_Day_Flag AS INT)) / COUNT(*), 2) AS Readmission_30_Day_Rate
FROM dbo.Patient_Encounters
GROUP BY 
    age,
    CASE 
        WHEN Length_of_Stay BETWEEN 1 AND 3 THEN 'Short Stay (1-3 days)'
        WHEN Length_of_Stay BETWEEN 4 AND 7 THEN 'Medium Stay (4-7 days)'
        ELSE 'Long Stay (8+ days)'
    END,
    CASE
        WHEN Emergency_Visits = 0 THEN 'No Emergency Visit'
        WHEN Emergency_Visits BETWEEN 1 AND 2 THEN '1-2 Emergency Visits'
        ELSE '3+ Emergency Visits'
    END
HAVING COUNT(*) >= 100
ORDER BY Readmission_30_Day_Rate DESC;
