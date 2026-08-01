CREATE TABLE IF NOT EXISTS inquiries (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL,
  type TEXT NOT NULL DEFAULT '',
  kit TEXT NOT NULL DEFAULT '',
  name TEXT NOT NULL DEFAULT '',
  email TEXT NOT NULL,
  timeline TEXT NOT NULL DEFAULT '',
  message TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'new' CHECK (status IN ('new', 'in_progress', 'closed'))
);

CREATE INDEX IF NOT EXISTS inquiries_status_created_idx
  ON inquiries (status, created_at DESC);

CREATE TABLE IF NOT EXISTS gallery_entries (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL,
  published_at TEXT,
  title TEXT NOT NULL DEFAULT '',
  reveal_title TEXT NOT NULL DEFAULT '',
  description TEXT NOT NULL DEFAULT '',
  submitter_email TEXT NOT NULL DEFAULT '',
  cover_key TEXT,
  reveal_key TEXT,
  cover_url TEXT,
  reveal_url TEXT,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'published', 'rejected')),
  source TEXT NOT NULL DEFAULT 'website',
  sort_order INTEGER NOT NULL DEFAULT 0,
  CHECK ((cover_key IS NOT NULL AND reveal_key IS NOT NULL) OR
         (cover_url IS NOT NULL AND reveal_url IS NOT NULL))
);

CREATE INDEX IF NOT EXISTS gallery_status_sort_idx
  ON gallery_entries (status, sort_order DESC, published_at DESC, created_at DESC);
