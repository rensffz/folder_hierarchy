INSERT INTO folder_hierarchy (data) VALUES 
(
    jsonb_build_object(
        'id', '0',
        'name', 'Проект',
        'type', 'project'
    )
),
(
    jsonb_build_object(
        'id', 'A',
        'name', 'Папка A',
        'parentId', '0',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'B',
        'name', 'Папка B',
        'parentId', '0',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'C',
        'name', 'Папка C',
        'parentId', '0',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'D',
        'name', 'Папка D',
        'parentId', 'A',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'E',
        'name', 'Папка E',
        'parentId', 'A',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'F',
        'name', 'Папка F',
        'parentId', 'B',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'G',
        'name', 'Папка G',
        'parentId', 'E',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'H',
        'name', 'Папка H',
        'parentId', 'E',
        'type', 'folder'
    )
),
(
    jsonb_build_object(
        'id', 'I',
        'name', 'Папка I',
        'parentId', 'G',
        'type', 'folder'
    )
);