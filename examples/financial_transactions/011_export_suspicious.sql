-- Export flagged transactions for compliance review
COPY suspicious_transactions TO './output/suspicious_transactions.csv' (FORMAT CSV, HEADER);
