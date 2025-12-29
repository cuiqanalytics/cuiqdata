-- Export results as Parquet (no TOML needed)
LOAD EXCEL;
COPY processed_data TO './output/resultados.xlsx' (header true);
