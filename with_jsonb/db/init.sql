CREATE TABLE IF NOT EXISTS folder_hierarchy (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    data JSONB NOT NULL
);
-- create indexes for fast search
CREATE INDEX IF NOT EXISTS idx_folder_id 
    ON folder_hierarchy ((data->>'id'));

CREATE INDEX IF NOT EXISTS idx_folder_parent 
    ON folder_hierarchy ((data->>'parentId'));

CREATE INDEX IF NOT EXISTS idx_folder_type 
    ON folder_hierarchy ((data->>'type'));

-- validatation
ALTER TABLE folder_hierarchy 
ADD CONSTRAINT check_data_has_id 
CHECK (data ? 'id');

ALTER TABLE folder_hierarchy 
ADD CONSTRAINT check_data_has_name 
CHECK (data->>'name' IS NOT NULL AND data->>'name' != '');

ALTER TABLE folder_hierarchy 
ADD CONSTRAINT check_data_type 
CHECK (data->>'type' IN ('project', 'folder'));