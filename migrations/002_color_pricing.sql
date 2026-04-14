-- Adds the color_pricing flag to products_catalog.
-- When false (default): all rows sharing (vendor, product_name, uom) must share unit_rate.
--   Colors are effectively "options" and don't affect price.
-- When true: each (uom, color) combo can have its own unit_rate.
--
-- Run this once in the Supabase SQL editor.

ALTER TABLE public.products_catalog
  ADD COLUMN IF NOT EXISTS color_pricing boolean NOT NULL DEFAULT false;

-- Optional: backfill based on whether existing rows already have divergent
-- rates across colors for the same uom. Skipped here — defaults to false,
-- which matches the common case.
