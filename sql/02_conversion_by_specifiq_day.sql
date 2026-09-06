=========================================================================
Question 02 : Do specific dates (seasonality, month of the year, day of 
the week) have a significant impact on engagement and registration?
Table : holberton_events.events_clean
=========================================================================


-- Impact on the day of the week
SELECT
  CASE 
    WHEN Week_End = 1 THEN 'Week-end'
    ELSE 'Semaine'
  END AS type_periode,

  COUNT(Name) AS total_evenements,
  SUM(Nb_inscrits) AS total_inscrits,
  SUM(Nb_presents) AS total_presents,
  SUM(Nb_presents_avec_PI_signe) AS total_convertis,

  -- Actual attendance rate (Attendees / Enrolled students)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents), SUM(Nb_inscrits)) * 100, 2) AS taux_presence,

  -- Conversion rate: the proportion of participants present who sign a contract (PI)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents_avec_PI_signe), SUM(Nb_presents)) * 100, 2) AS taux_transformation_presents,

  -- Overall conversion rate: the proportion of all applicants who sign a contract (PI)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents_avec_PI_signe), SUM(Nb_inscrits)) * 100, 2) AS taux_conversion_global

FROM `positive-oven-493718-i1.holberton_events.events_clean`

GROUP BY Week_End

ORDER BY taux_conversion_global DESC;


-- Impact of the specific day of the week
SELECT
  CASE EXTRACT(DAYOFWEEK FROM Date_seule)
  WHEN 2 THEN 'Lundi'
  WHEN 3 THEN 'Mardi'
  WHEN 4 THEN 'Mercredi'
  WHEN 5 THEN 'Jeudi'
  WHEN 6 THEN 'Vendredi'
  WHEN 7 THEN 'Samedi'
  WHEN 1 THEN 'Mercredi'
  END AS jour_semaine,

  COUNT(Name) AS total_evenements,
  SUM(Nb_inscrits) AS total_inscrits,
  SUM(Nb_presents) AS total_presents,
  SUM(Nb_presents_avec_PI_signe) AS total_convertis,

  -- Actual attendance rate (Attendees / Enrolled students)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents), SUM(Nb_inscrits)) * 100, 2) AS taux_presence,

  -- Conversion rate: the proportion of participants present who sign a contract (PI)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents_avec_PI_signe), SUM(Nb_presents)) * 100, 2) AS taux_transformation_presents,

  -- Overall conversion rate: the proportion of all applicants who sign a contract (PI)
  ROUND(SAFE_DIVIDE(SUM(Nb_presents_avec_PI_signe), SUM(Nb_inscrits)) * 100, 2) AS taux_conversion_global

FROM `positive-oven-493718-i1.holberton_events.events_clean`

GROUP BY jour_semaine

ORDER BY taux_conversion_global DESC;

--Monitoring: Breakdown by event type on Thursday
SELECT
  Type_evenement,
  COUNT(Name) AS total_evenements,
  SUM(Nb_inscrits) AS total_inscrits,
  SUM(Nb_presents) AS total_presents,
  SUM(Nb_presents_avec_PI_signe) AS total_convertis,

  ROUND(SAFE_DIVIDE(SUM(Nb_presents), SUM(Nb_inscrits)) * 100, 2) AS taux_presence,
  ROUND(SAFE_DIVIDE(SUM(Nb_presents_avec_PI_signe), SUM(Nb_presents)) * 100, 2) AS taux_transformation_presents

FROM `positive-oven-493718-i1.holberton_events.events_clean`

WHERE EXTRACT(DAYOFWEEK FROM Date_seule) = 5

GROUP BY Type_evenement;



