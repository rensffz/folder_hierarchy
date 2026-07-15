CREATE TABLE IF NOT EXISTS folder_hierarchy (
    id TEXT PRIMARY KEY DEFAULT,
    title TEXT NOT NULL,
    parentId UUID,
    folderType TEXT
);

CREATE TABLE IF NOT EXISTS files (
    id TEXT PRIMARY KEY DEFAULT,
    title TEXT NOT NULL,
    directoryId TEXT,
    fileType TEXT
);

-- create indexes for fast search
CREATE INDEX IF NOT EXISTS idx_folder_id 
    ON folder_hierarchy (id);

CREATE INDEX IF NOT EXISTS idx_folder_parent 
    ON folder_hierarchy (parentId);

CREATE INDEX IF NOT EXISTS idx_folder_type 
    ON folder_hierarchy (folderType);

-- create indexes for fast search
CREATE INDEX IF NOT EXISTS idx_file_id 
    ON files (id);

CREATE INDEX IF NOT EXISTS idx_files_dir 
    ON files (directoryId);

CREATE INDEX IF NOT EXISTS idx_file_type 
    ON files (fileType);