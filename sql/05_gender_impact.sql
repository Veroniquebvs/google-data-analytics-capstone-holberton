=========================================================================
Question: What is the profile of the participants who convert best?
Note: Analysis limited to attendance by gender (registrations vs. actual attendance) 
due to the lack of individual traceability for signatures (PI).
=========================================================================

WITH table_of_genres AS (
  SELECT
    -- Counting registered users per session based on the text
    COALESCE(ARRAY_LENGTH(REGEXP_EXTRACT_ALL(LOWER(Genre_Inscription_nettoye), r'\bhomme\b')), 0) AS hommes_inscrits,
    COALESCE(ARRAY_LENGTH(REGEXP_EXTRACT_ALL(LOWER(Genre_Inscription_nettoye), r'\bfemme\b')), 0) AS femmes_inscrits,

    -- Direct numerical columns for those present
    Nb_hommes_presents,
    Nb_femmes_presents
  FROM
    `positive-oven-493718-i1.holberton_events.events_clean`
)

SELECT
  'Hommes' AS genre,
  SUM(hommes_inscrits) AS total_inscrits,
  SUM(Nb_hommes_presents) AS total_presents,
  ROUND(SAFE_DIVIDE(SUM(Nb_hommes_presents), SUM(hommes_inscrits)) * 100, 2) AS taux_presence
FROM
  table_of_genres

UNION ALL

SELECT
  'Femmes' AS genre,
  SUM(femmes_inscrits) AS total_inscrits,
  SUM(Nb_femmes_presents) AS total_presents,
  ROUND(SAFE_DIVIDE(SUM(Nb_femmes_presents), SUM(femmes_inscrits)) * 100, 2) AS taux_presence
FROM
  table_of_genres;