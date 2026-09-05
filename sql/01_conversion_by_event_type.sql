=========================================================================
Question 01 : What type of event generates the highest conversion rate?
Table : holberton_events.events_clean
=========================================================================

SELECT Type_evenement, 
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

GROUP BY Type_evenement

ORDER BY taux_conversion_global DESC;