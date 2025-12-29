-- Export denied claims for manual review and appeals
COPY denial_analysis TO './output/denied_claims.csv' (FORMAT CSV, HEADER);
