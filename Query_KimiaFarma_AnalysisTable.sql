CREATE OR REPLACE TABLE `rakamin-kimiafarma-bda.kimia_farma.kf_analisa` AS
SELECT 
    ft.transaction_id,
    ft.date,
    kc.branch_id,
    kc.branch_name,
    kc.kota,
    kc.provinsi,
    kc.rating AS rating_cabang,
    ft.customer_name,
    ft.product_id,
    p.product_name,
    ft.price AS actual_price,
    ft.discount_percentage,
    -- Hitung Persentase Gross Laba
    CASE 
        WHEN ft.price <= 50000 THEN 10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 25
        ELSE 30
    END AS persentase_gross_laba,
    -- Hitung Nett Sales (Harga setelah Diskon)
    (ft.price * (1 - ft.discount_percentage / 100)) AS nett_sales,
    -- Hitung Nett Profit
    ((ft.price * (1 - ft.discount_percentage / 100)) * 
    CASE 
        WHEN ft.price <= 50000 THEN 0.10
        WHEN ft.price > 50000 AND ft.price <= 100000 THEN 0.15
        WHEN ft.price > 100000 AND ft.price <= 300000 THEN 0.20
        WHEN ft.price > 300000 AND ft.price <= 500000 THEN 0.25
        ELSE 0.30
    END) AS nett_profit,
    ft.rating AS rating_transaksi
FROM `rakamin-kimiafarma-bda.kimia_farma.kf_final_transaction` ft
LEFT JOIN `rakamin-kimiafarma-bda.kimia_farma.kf_kantor_cabang` kc
ON ft.branch_id = kc.branch_id
LEFT JOIN `rakamin-kimiafarma-bda.kimia_farma.kf_product` p
ON ft.product_id = p.product_id;
