-- GameDesk tables (run once in Supabase SQL Editor)
CREATE TABLE IF NOT EXISTS gamedesk_settings (
  id TEXT PRIMARY KEY DEFAULT 'main',
  hour_price NUMERIC DEFAULT 30,
  half_price NUMERIC DEFAULT 15,
  minute_price NUMERIC DEFAULT 0.5,
  sound_enabled BOOLEAN DEFAULT true,
  browser_notify BOOLEAN DEFAULT true,
  shop_name TEXT DEFAULT '',
  alert_phone TEXT DEFAULT '',
  alert_repeat INT DEFAULT 3,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
INSERT INTO gamedesk_settings (id) VALUES ('main') ON CONFLICT DO NOTHING;

CREATE TABLE IF NOT EXISTS gamedesk_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  machine INT NOT NULL,
  customer_name TEXT DEFAULT '',
  customer_phone TEXT DEFAULT '',
  duration_min INT NOT NULL,
  price NUMERIC NOT NULL DEFAULT 0,
  paid NUMERIC NOT NULL DEFAULT 0,
  note TEXT DEFAULT '',
  start_at BIGINT NOT NULL,
  end_at BIGINT NOT NULL,
  status TEXT NOT NULL DEFAULT 'active',
  finished_at BIGINT,
  created_at BIGINT NOT NULL,
  inserted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS gamedesk_expenses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  category TEXT NOT NULL,
  amount NUMERIC NOT NULL,
  date TEXT NOT NULL,
  note TEXT DEFAULT '',
  created_at BIGINT NOT NULL,
  inserted_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS gamedesk_receipts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID,
  machine INT,
  customer_name TEXT DEFAULT '',
  amount NUMERIC NOT NULL,
  kind TEXT DEFAULT '',
  created_at BIGINT NOT NULL,
  date TEXT NOT NULL,
  inserted_at TIMESTAMPTZ DEFAULT NOW()
);

ALTER TABLE gamedesk_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE gamedesk_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE gamedesk_expenses ENABLE ROW LEVEL SECURITY;
ALTER TABLE gamedesk_receipts ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  CREATE POLICY "all settings" ON gamedesk_settings FOR ALL USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "all sessions" ON gamedesk_sessions FOR ALL USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "all expenses" ON gamedesk_expenses FOR ALL USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;
DO $$ BEGIN
  CREATE POLICY "all receipts" ON gamedesk_receipts FOR ALL USING (true) WITH CHECK (true);
EXCEPTION WHEN duplicate_object THEN NULL; END $$;

CREATE INDEX IF NOT EXISTS idx_gd_sessions_status ON gamedesk_sessions(status);
CREATE INDEX IF NOT EXISTS idx_gd_sessions_machine ON gamedesk_sessions(machine);
CREATE INDEX IF NOT EXISTS idx_gd_expenses_date ON gamedesk_expenses(date);
CREATE INDEX IF NOT EXISTS idx_gd_receipts_date ON gamedesk_receipts(date);
