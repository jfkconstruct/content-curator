-- First, disable RLS on all tables
ALTER TABLE sources DISABLE ROW LEVEL SECURITY;
ALTER TABLE content DISABLE ROW LEVEL SECURITY;
ALTER TABLE tags DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_tags DISABLE ROW LEVEL SECURITY;
ALTER TABLE content_analysis DISABLE ROW LEVEL SECURITY;
ALTER TABLE remixes DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DO $$ 
BEGIN
    -- Drop policies if they exist (this won't error if they don't exist)
    DROP POLICY IF EXISTS "Users can read their own sources" ON sources;
    DROP POLICY IF EXISTS "Users can insert their own sources" ON sources;
    DROP POLICY IF EXISTS "Users can read their own content" ON content;
    DROP POLICY IF EXISTS "Allow public read access to sources" ON sources;
    DROP POLICY IF EXISTS "Allow public read access to content" ON content;
    DROP POLICY IF EXISTS "Allow public read access to tags" ON tags;
    DROP POLICY IF EXISTS "Allow public read access to content_tags" ON content_tags;
    DROP POLICY IF EXISTS "Allow public read access to content_analysis" ON content_analysis;
    DROP POLICY IF EXISTS "Allow public read access to remixes" ON remixes;
END $$;

-- Re-enable RLS on all tables
ALTER TABLE sources ENABLE ROW LEVEL SECURITY;
ALTER TABLE content ENABLE ROW LEVEL SECURITY;
ALTER TABLE tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_tags ENABLE ROW LEVEL SECURITY;
ALTER TABLE content_analysis ENABLE ROW LEVEL SECURITY;
ALTER TABLE remixes ENABLE ROW LEVEL SECURITY;

-- Create new public access policies
CREATE POLICY "Allow public read access to sources"
ON sources FOR SELECT
TO public
USING (true);

CREATE POLICY "Allow public read access to content"
ON content FOR SELECT
TO public
USING (true);

CREATE POLICY "Allow public read access to tags"
ON tags FOR SELECT
TO public
USING (true);

CREATE POLICY "Allow public read access to content_tags"
ON content_tags FOR SELECT
TO public
USING (true);

CREATE POLICY "Allow public read access to content_analysis"
ON content_analysis FOR SELECT
TO public
USING (true);

CREATE POLICY "Allow public read access to remixes"
ON remixes FOR SELECT
TO public
USING (true);
