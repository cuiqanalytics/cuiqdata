-- There is no need to INSTALL EXCEL, it is already installed in the previous step.
LOAD EXCEL;
COPY sales_summary TO './sales_summary.xlsx' (HEADER TRUE)
