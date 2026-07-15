CREATE OR REPLACE FUNCTION get_parents(
    p_object_id TEXT  -- принять аргумент id
)
RETURNS TEXT[] AS $$  -- вернуть массив id родителей
DECLARE
    v_result TEXT[] := ARRAY[]::TEXT[];
    v_current_id TEXT := p_object_id;
    v_parent_id TEXT;
    v_max_depth INTEGER := 100;
    v_depth INTEGER := 0;
BEGIN
    IF p_object_id IS NULL OR p_object_id = '' THEN
        RAISE EXCEPTION 'Идентификатор объекта не может быть NULL или пустым';
    END IF;

    IF NOT EXISTS (
        SELECT 1 
        FROM folder_hierarchy 
        WHERE data->>'id' = p_object_id
    ) THEN
        RAISE EXCEPTION 'Объект с идентификатором % не найден', p_object_id;
    END IF;

    v_result := array_append(v_result, v_current_id);

    WHILE v_depth < v_max_depth LOOP
        SELECT data->>'parentId'
        INTO v_parent_id
        FROM folder_hierarchy
        WHERE data->>'id' = v_current_id
        AND data ? 'parentId';

        IF v_parent_id IS NULL THEN
            EXIT;
        END IF;

        IF NOT EXISTS (
            SELECT 1 
            FROM folder_hierarchy 
            WHERE data->>'id' = v_parent_id
        ) THEN
            RAISE EXCEPTION 'Нарушение целостности: родитель с ID % не найден', v_parent_id;
        END IF;

        v_result := array_append(v_result, v_parent_id);
        v_current_id := v_parent_id;
        v_depth := v_depth + 1;
    END LOOP;

    IF v_depth >= v_max_depth THEN
        RAISE WARNING 'Достигнута максимальная глубина %', v_max_depth;
    END IF;

    RETURN v_result;
END;
$$ LANGUAGE plpgsql;