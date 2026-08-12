ALTER TABLE inquiries ADD COLUMN color_mode TEXT NOT NULL DEFAULT '';
ALTER TABLE inquiries ADD COLUMN pairing_id TEXT NOT NULL DEFAULT '';
ALTER TABLE inquiries ADD COLUMN cassette_color_id TEXT NOT NULL DEFAULT '';
ALTER TABLE inquiries ADD COLUMN stand_color_id TEXT NOT NULL DEFAULT '';
ALTER TABLE inquiries ADD COLUMN custom_color_notes TEXT NOT NULL DEFAULT '';

CREATE TABLE IF NOT EXISTS orders (
  stripe_session_id TEXT PRIMARY KEY,
  stripe_event_id TEXT NOT NULL DEFAULT '',
  created_at TEXT NOT NULL,
  updated_at TEXT NOT NULL,
  payment_status TEXT NOT NULL DEFAULT '',
  amount_total INTEGER,
  currency TEXT NOT NULL DEFAULT '',
  customer_email TEXT NOT NULL DEFAULT '',
  offering_id TEXT NOT NULL DEFAULT '',
  image_option_id TEXT NOT NULL DEFAULT '',
  color_mode TEXT NOT NULL DEFAULT '',
  pairing_id TEXT NOT NULL DEFAULT '',
  cassette_color_id TEXT NOT NULL DEFAULT '',
  stand_color_id TEXT NOT NULL DEFAULT '',
  color_summary TEXT NOT NULL DEFAULT '',
  fulfillment_status TEXT NOT NULL DEFAULT 'new'
    CHECK (fulfillment_status IN ('new', 'in_progress', 'fulfilled', 'cancelled'))
);

CREATE INDEX IF NOT EXISTS orders_fulfillment_created_idx
  ON orders (fulfillment_status, created_at DESC);
