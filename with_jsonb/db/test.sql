-- ============================================
-- ЗЕЛЕНЫЙ ТЕСТ: с отображением путей
-- ============================================

DO $$
DECLARE
    v_id TEXT := 'H';
    v_result TEXT[];
    v_expected TEXT[];
    v_test_passed BOOLEAN;
    v_path TEXT;
BEGIN
    v_result := get_parents(v_id);
    v_expected := ARRAY[
        'H'::TEXT,
        'E'::TEXT,
        'A'::TEXT,
        '0'::TEXT
    ];

    SELECT array_to_string(
        ARRAY(
            SELECT data->>'name'
            FROM folder_hierarchy
            WHERE data->>'id' = ANY(v_result)
            ORDER BY array_position(v_result, data->>'id')
        ),
        ' -> '
    ) INTO v_path;

    RAISE NOTICE 'Путь: %', v_path;
    RAISE NOTICE '';

    IF v_result = v_expected THEN
        RAISE NOTICE 'Accepted';
        v_test_passed := TRUE;
    ELSE
        RAISE NOTICE 'Failed';
        RAISE NOTICE '   Expected: %', array_to_string(v_expected, ' -> ');
        RAISE NOTICE '   Fact: %', array_to_string(v_result, ' -> ');
        v_test_passed := FALSE;
    END IF;

    -- ВЕРДИКТ
    RAISE NOTICE '';
    IF v_test_passed THEN
        RAISE NOTICE 'Test passed';
    ELSE
        RAISE NOTICE 'Test failed';
    END IF;
END $$;