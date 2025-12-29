-- Export low/out-of-stock items requiring immediate action
COPY (SELECT sku, product_name, warehouse_id, warehouse_name, available_quantity, reorder_point, stock_status FROM inventory_enriched WHERE stock_status IN ('low_stock', 'out_of_stock'))
TO './output/low_stock_alert.csv' (FORMAT CSV, HEADER);
