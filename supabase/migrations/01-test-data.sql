-- Insert or update test data for sources
INSERT INTO sources (id, name, type, url, settings)
VALUES 
    ('e99a2799-3a48-4715-9e4a-8e6555b7d7bc', 'Example Blog', 'webpage', 'https://example.com/blog', '{"update_frequency": "daily"}'::jsonb),
    ('7c9e6679-7055-404e-944b-e07fc490c8e7', 'Dev.to', 'webpage', 'https://dev.to', '{"update_frequency": "daily"}'::jsonb),
    ('b667af25-d953-4567-bd90-83cbd4567f8a', 'Medium', 'webpage', 'https://medium.com', '{"update_frequency": "daily"}'::jsonb)
ON CONFLICT (id) 
DO UPDATE SET 
    name = EXCLUDED.name,
    type = EXCLUDED.type,
    url = EXCLUDED.url,
    settings = EXCLUDED.settings;

-- Insert or update test data for content
INSERT INTO content (id, title, content, content_type, metadata, original_url, source_id)
VALUES 
    ('c89ae534-0234-4678-c501-234cf567f8e9', 'Best Practices for Content Curation', 'Content curation is more than just collecting links...', 'article', '{"tags": ["curation", "best-practices"]}'::jsonb, 'https://example.com/curation-tips', 'e99a2799-3a48-4715-9e4a-8e6555b7d7bc'),
    ('b667af25-d953-4567-bd90-83cbd4567f8a', 'The Future of AI in Content Creation', 'Artificial Intelligence is revolutionizing how we create...', 'article', '{"tags": ["ai", "content-creation"]}'::jsonb, 'https://example.com/ai-content', 'e99a2799-3a48-4715-9e4a-8e6555b7d7bc'),
    ('7c9e6679-7055-404e-944b-e07fc490c8e7', 'Understanding Modern Web Development', 'Web development has evolved significantly...', 'article', '{"tags": ["web-dev", "programming"]}'::jsonb, 'https://example.com/web-dev', 'b667af25-d953-4567-bd90-83cbd4567f8a')
ON CONFLICT (id)
DO UPDATE SET
    title = EXCLUDED.title,
    content = EXCLUDED.content,
    content_type = EXCLUDED.content_type,
    metadata = EXCLUDED.metadata,
    original_url = EXCLUDED.original_url,
    source_id = EXCLUDED.source_id;

-- Insert or update test data for tags
INSERT INTO tags (id, name)
VALUES 
    ('d9e0f345-f345-4789-d012-34f5a6789b0c', 'AI'),
    ('e0f1a456-a456-4890-e123-45a6b7890c1d', 'Web Development'),
    ('f1a2b567-b567-4901-f234-56a7b8901c2e', 'Content Curation')
ON CONFLICT (id)
DO UPDATE SET
    name = EXCLUDED.name;

-- Insert or update test data for content_tags
INSERT INTO content_tags (content_id, tag_id)
VALUES 
    ('c89ae534-0234-4678-c501-234cf567f8e9', 'f1a2b567-b567-4901-f234-56a7b8901c2e'),
    ('b667af25-d953-4567-bd90-83cbd4567f8a', 'd9e0f345-f345-4789-d012-34f5a6789b0c'),
    ('7c9e6679-7055-404e-944b-e07fc490c8e7', 'e0f1a456-a456-4890-e123-45a6b7890c1d')
ON CONFLICT (content_id, tag_id)
DO NOTHING;
