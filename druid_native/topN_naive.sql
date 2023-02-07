SELECT cohort,
  THETA_SKETCH_ESTIMATE(DS_THETA(theta_user)) AS th_u
FROM "sketch-topn"
GROUP BY cohort
ORDER BY th_u DESC
LIMIT 5
