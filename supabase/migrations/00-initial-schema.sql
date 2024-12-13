-- Enable necessary extensions
create extension if not exists "uuid-ossp";

-- Sources table for content sources
create table if not exists sources (
    id uuid primary key default uuid_generate_v4(),
    user_id uuid references auth.users,
    name varchar(255) not null,
    type varchar(50) not null, -- 'rss', 'twitter', 'newsletter', 'webpage'
    url text,
    credentials jsonb,
    settings jsonb,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

-- Content table for storing original content
create table if not exists content (
    id uuid primary key default uuid_generate_v4(),
    source_id uuid references sources,
    user_id uuid references auth.users,
    title text,
    content text,
    content_type varchar(50), -- 'article', 'tweet', 'video', 'image'
    metadata jsonb,
    original_url text,
    created_at timestamptz default now(),
    updated_at timestamptz default now()
);

-- Tags table
create table if not exists tags (
    id uuid primary key default uuid_generate_v4(),
    name varchar(100) not null,
    user_id uuid references auth.users,
    created_at timestamptz default now()
);

-- Content tags relation
create table if not exists content_tags (
    content_id uuid references content,
    tag_id uuid references tags,
    primary key (content_id, tag_id)
);

-- Content analysis table
create table if not exists content_analysis (
    id uuid primary key default uuid_generate_v4(),
    content_id uuid references content,
    summary text,
    keywords text[],
    sentiment varchar(50),
    topics text[],
    entities jsonb,
    created_at timestamptz default now()
);

-- Remixes table
create table if not exists remixes (
    id uuid primary key default uuid_generate_v4(),
    user_id uuid references auth.users,
    title varchar(255) not null,
    description text,
    content text,
    template_id uuid,
    source_contents jsonb, -- Array of source content IDs and metadata
    metadata jsonb,
    created_at timestamptz default now(),
    updated_at timestamptz default now(),
    published_at timestamptz
);

-- Create indexes
create index if not exists idx_content_source on content(source_id);
create index if not exists idx_content_user on content(user_id);
create index if not exists idx_content_type on content(content_type);
create index if not exists idx_tags_name on tags(name);
create index if not exists idx_remixes_user on remixes(user_id);

-- Add RLS (Row Level Security) policies
alter table sources enable row level security;
alter table content enable row level security;
alter table tags enable row level security;
alter table content_tags enable row level security;
alter table content_analysis enable row level security;
alter table remixes enable row level security;

-- Create policies
create policy "Users can read their own sources"
    on sources for select
    using (auth.uid() = user_id);

create policy "Users can insert their own sources"
    on sources for insert
    with check (auth.uid() = user_id);

-- Similar policies for other tables
create policy "Users can read their own content"
    on content for select
    using (auth.uid() = user_id);

create policy "Users can insert their own content"
    on content for insert
    with check (auth.uid() = user_id);
