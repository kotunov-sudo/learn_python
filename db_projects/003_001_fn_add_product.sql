-- 1. Добавление нового товара add_product - добавление товара с проверкой категории.
-- 003_001_fn_add_product.sql
CREATE OR REPLACE FUNCTION add_product(
    p_name         VARCHAR(255),
    p_slug         VARCHAR(255),
    p_description  TEXT,
    p_price        DECIMAL(10,2),
    p_discount     DECIMAL(10,2) DEFAULT NULL,
    p_category_id  INTEGER,
    p_stock        INTEGER DEFAULT 0,
    p_sku          VARCHAR(100) DEFAULT NULL
)
RETURNS INTEGER AS $$
DECLARE
    v_product_id INTEGER;
BEGIN
    -- Проверяем, что категория существует
    IF NOT EXISTS (SELECT 1 FROM categories WHERE id = p_category_id) THEN
        RAISE EXCEPTION 'Категория с id % не найдена', p_category_id;
    END IF;

    -- Вставляем товар
    INSERT INTO products (name, slug, description, price, discount_price,
                          category_id, stock_quantity, sku)
    VALUES (p_name, p_slug, p_description, p_price, p_discount,
            p_category_id, p_stock, p_sku)
    RETURNING id INTO v_product_id;

    RETURN v_product_id;
END;
$$ LANGUAGE plpgsql;

-- Пример использования:
SELECT add_product('Ноутбук Pro', 'laptop-pro', 'Мощный ноутбук', 1500.00, NULL, 1, 5, 'NB-001');