-- Wipes the existing product catalog and seeds a fresh set of placeholder rows.
-- Each product gets a single placeholder variant (uom='EA', color='N/A', unit_rate=0)
-- so that it shows up as a card in the admin Product Catalog UI, ready to be
-- edited with real UOMs, colors, and rates.
--
-- Products with vendor='ALL' are manufacturer-agnostic and are merged into
-- every specific-vendor filter in the Material tab at render time.
--
-- Duplicates from the source list have been removed. Items flagged as appearing
-- in multiple categories were kept in the first category they appeared in.
--
-- Run once in the Supabase SQL editor after migration 002.

BEGIN;

DELETE FROM public.products_catalog;

INSERT INTO public.products_catalog
  (vendor, category, product_name, color, uom, unit_rate, color_pricing, active)
VALUES
  -- ============ SW ============
  -- Primers and Sealers
  ('SW', 'Primers and Sealers', 'RESUPRIME 3477 EPOXY WATER PRIMER/SEALER', 'N/A', 'EA', 0, false, true),
  ('SW', 'Primers and Sealers', 'RESUPRIME 3504 HIGH SOLID CLEAR PRIMER/SEALER', 'N/A', 'EA', 0, false, true),
  ('SW', 'Primers and Sealers', 'RESUPRIME 3579 HIGH SOLID EPOXY PRIMER/BINDER', 'N/A', 'EA', 0, false, true),
  ('SW', 'Primers and Sealers', 'RESUPRIME 3831 MVB MOISTURE EPOXY PRIMER', 'N/A', 'EA', 0, false, true),
  ('SW', 'Primers and Sealers', 'RESUPRIME 5531 OIL STOP PRIMER', 'N/A', 'EA', 0, false, true),
  ('SW', 'Primers and Sealers', 'RESUPRIME MVP EPOXY PRIMER', 'N/A', 'EA', 0, false, true),

  -- Crack Filler, Patching, Colorant
  ('SW', 'Crack Filler, Patching, Colorant', 'RESUFLOR 3500 EPOXY QUICK PATCH (FAST)', 'N/A', 'EA', 0, false, true),
  ('SW', 'Crack Filler, Patching, Colorant', 'RESUFLOR 3513 SCRATCH COAT MASTIC (THICK/SLOW)', 'N/A', 'EA', 0, false, true),
  ('SW', 'Crack Filler, Patching, Colorant', 'CEMLACK UM. URETHANE CEMENT PATCH 1:1:1', 'N/A', 'EA', 0, false, true),
  ('SW', 'Crack Filler, Patching, Colorant', 'HPF UNIVERSAL COLORANT', 'N/A', 'EA', 0, false, true),

  -- Poly-Crete
  ('SW', 'Poly-Crete', 'POLY-CRETE COLOR-FAST', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE HF ACCELERATOR LOW TEMPERATURE AID', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE HF HS URETHANE CONCRETE COATING', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE MD HS URETHANE CONCRETE COATING', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE SL HS SELF LEVELING URETHANE', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE TF PLUS COVE VERTICAL APPLICATIONS', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE TF PLUS PRIMER/TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Poly-Crete', 'POLY-CRETE WR COVE BASE, SLOPE/PATCHING', 'N/A', 'EA', 0, false, true),

  -- MMA
  ('SW', 'MMA', 'CRYLAFLOR P-101 PRIMER', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR G-201 BINDER', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR T-301 TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR T-303 FLEXIBLE TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR COVE', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR CURE (BPO)', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR COLOR - BACKGROUND ONLY', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR BOND ENHANCER TO P-101', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR SL FILLER BLEND TO G-201', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR BOND MT METAL/TILE ENHANCER', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR LTC ADDITIVE LOW TEMPERATURE', 'N/A', 'EA', 0, false, true),
  ('SW', 'MMA', 'CRYLAFLOR CLEAN SOLVENT TO CLEAN TOOLS', 'N/A', 'EA', 0, false, true),

  -- Epoxy (RESUTILE 4638 kept in Polyurethane only)
  ('SW', 'Epoxy', 'RESUFLOR 3725 STATIC CONTROL EPOXY', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR AQUA 3461 HIGH SOLIDS WB EPOXY GROUT/TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR 3746 HIGH PERFORMANCE EPOXY', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR 3760 MPE MULTI-PURPOSE EPOXY', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR AQUA 3460 WB EPOXY PRIMER, BINDER, TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR PT 250 THICKENED EPOXY 2:1', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR 3760 RCE RAPID CURE EPOXY', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'GP 3555 EPOFLEX 1:1', 'N/A', 'EA', 0, false, true),
  ('SW', 'Epoxy', 'RESUFLOR 3741 CHEMICAL RESISTANT NOVOLAC', 'N/A', 'EA', 0, false, true),

  -- Polyaspartic
  ('SW', 'Polyaspartic', 'ACCELERA 4850 GROUT/TOPCOAT POLYASPARTIC', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyaspartic', 'RESUDECK FLA CLEAR ALIPHATIC POLYASPARTIC TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyaspartic', 'ACCELERA EXT SMALL 1R:1H', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyaspartic', 'ACCELERA ONE RESIN (SEE MIX CHART)', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyaspartic', 'ACCELERA ONE HARDENER (SEE MIX CHART)', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyaspartic', 'ACCELERA 5 66% SOLIDS 1:1', 'N/A', 'EA', 0, false, true),

  -- Polyurethane
  ('SW', 'Polyurethane', 'RESUTILE 4638 HS POLYURETHANE FLOOR ENAMEL', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyurethane', 'RESUTILE 4640 HTS 100 HS HIGH TRAFFIC URETHANE ENAMEL', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyurethane', 'RESUTILE 4641 HPS 100 HS ALIPHATIC URETHANE TOPCOAT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyurethane', 'RESUTILE AQUA 4410 WB ALIPHATIC URETHANE - COLOR', 'N/A', 'EA', 0, false, true),
  ('SW', 'Polyurethane', 'RESUTILE AQUA 4411 WB ALIPHATIC URETHANE - CLEAR', 'N/A', 'EA', 0, false, true),

  -- Aggregates
  ('SW', 'Aggregates', '5115 MORTAR AGGREGATE BLEND', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '7310 PEA GRAVEL 3/16 X 3/8', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', 'F-60', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '1-16IN DECO FLAKE - 40LB BAG', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '1-8IN DECO FLAKE - 40LB BAG', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '1-4IN DECO FLAKE - 40LB BAG', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', 'RESUFLOR NO SAG', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', 'Q-ROCK 16 GRIT', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '5310 DRY SILICA SAND - 20/40', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '5310 DRY SILICA SAND - 40/60', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', '5310 DRY SILICA SAND - 80/120', 'N/A', 'EA', 0, false, true),
  ('SW', 'Aggregates', 'HPF COLOR QUARTZ', 'N/A', 'EA', 0, false, true),

  -- ============ SGC ============
  -- Epoxy / Deck Coatings
  ('SGC', 'Epoxy / Deck Coatings', 'SGC DECK BASE COAT 308', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Epoxy / Deck Coatings', 'SGC SHIELD FLEX', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Epoxy / Deck Coatings', 'FIBERGLASS TAPE', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Epoxy / Deck Coatings', 'RIO COAT EPT', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Epoxy / Deck Coatings', 'ROADWARE 10 MIN CONCRETE MENDER', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Epoxy / Deck Coatings', 'RIO COAT EMP', 'N/A', 'EA', 0, false, true),

  -- Colorant
  ('SGC', 'Colorant', 'POLYASPARTIC COLORANT', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Colorant', 'CRETE COLORANT', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Colorant', 'CRETE COLORANT - LARGE', 'N/A', 'EA', 0, false, true),

  -- Polyaspartic
  ('SGC', 'Polyaspartic', 'SGC POLYASPARTIC (100% Solid)', 'N/A', 'EA', 0, false, true),

  -- Crete
  ('SGC', 'Crete', 'SGC CRETE PART A', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'SGC CRETE PART B', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'SL - PART C', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'SF - PART C', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'CB - PART C', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'TC - PART C', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Crete', 'SGC SPEED', 'N/A', 'EA', 0, false, true),

  -- Aggregates
  ('SGC', 'Aggregates', 'FLAKE', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Aggregates', 'QUARTZ', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Aggregates', 'TROWEL QUARTZ', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Aggregates', 'ALUMINUM OXIDE', 'N/A', 'EA', 0, false, true),
  ('SGC', 'Aggregates', 'RIO TROWEL CLAD SAND', 'N/A', 'EA', 0, false, true),

  -- MMA
  ('SGC', 'MMA', 'SGC SHIELD BODY COAT', 'N/A', 'EA', 0, false, true),
  ('SGC', 'MMA', 'SGC SHIELD TOP COAT', 'N/A', 'EA', 0, false, true),
  ('SGC', 'MMA', 'SGC BPO CATALYST', 'N/A', 'EA', 0, false, true),
  ('SGC', 'MMA', 'SGC COAT MMA CLEANER', 'N/A', 'EA', 0, false, true),
  ('SGC', 'MMA', 'SGC MMA PRIMER', 'N/A', 'EA', 0, false, true),
  ('SGC', 'MMA', 'RIO MMA BONDING ADDITIVE', 'N/A', 'EA', 0, false, true),

  -- ============ SIKA ============
  -- Primers
  ('SIKA', 'Primers', 'SIKAFLOOR-160 CLEAR EPOXY PRIMER', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Primers', 'SIKAFLOOR-161 VERSATILE EPOXY PRIMER', 'N/A', 'EA', 0, false, true),

  -- Epoxy
  ('SIKA', 'Epoxy', 'SIKAFLOOR-264 VERSATILE PIGMENTED EPOXY', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Epoxy', 'SIKAFLOOR-264 FS FAST SETTING EPOXY', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Epoxy', 'SIKAFLOOR-264 TEXTURED PIGMENTED EPOXY', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Epoxy', 'SIKAFLOOR-265 FLEXABLE MEMBRANE W/ CRACK BRIDGING', 'N/A', 'EA', 0, false, true),

  -- Urethane/Polyaspartic
  ('SIKA', 'Urethane/Polyaspartic', 'SIKAFLOOR-315 N HS ALIPHATIC POLYURETHANE', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Urethane/Polyaspartic', 'SIKAFLOOR-510 LPL HS UV RESISTANT POLYASPARTIC', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Urethane/Polyaspartic', 'SIKAGARD CV 20 VINYL ESTER COATING - MTO', 'N/A', 'EA', 0, false, true),

  -- Ucrete Polyurethane Cement
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE UD200 TROWEL APPLIED CRETE', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE UD200SR SLIP RESISTANT TROWEL APPLIED CRETE', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE HS22 NA HIGH BUILD SL SLURRY', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE HS24 NA SL SLURRY', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE RG 29 NA VERTICAL GRADE COVE MORTAR', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE TC31 NA MULTI PURPOSE HIGH BUILD COATING', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE TCCS COLOR STABLE TOP COAT', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Ucrete Polyurethane Cement', 'SIKA UCRETE ACCELERATOR', 'N/A', 'EA', 0, false, true),

  -- Colorant
  ('SIKA', 'Colorant', 'SIKA UCRETE PIGMENT PACKS', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Colorant', 'SIKAFLOOR EPOXY PIGMENT PACK', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Colorant', 'SIKAFLOOR URETHANE PIGMENT PACK', 'N/A', 'EA', 0, false, true),

  -- Aggregate/Other
  ('SIKA', 'Aggregate/Other', 'SIKADUR 508 MEDIUM BROADCAST AGGREGATE', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Aggregate/Other', 'SIKADUR 509 - COARSE BROADCAST AGGREGATE', 'N/A', 'EA', 0, false, true),
  ('SIKA', 'Aggregate/Other', 'SIKAQUICK 1000', 'N/A', 'EA', 0, false, true),

  -- ============ ALL (manufacturer-agnostic) ============
  ('ALL', 'Additional Products', 'NP-1 TUBES (30 TUBE/CASE)', 'N/A', 'EA', 0, false, true),
  ('ALL', 'Additional Products', '600 UV (SSP JS-600 ALIPHATIC POLYUREA)', 'N/A', 'EA', 0, false, true),
  ('ALL', 'Additional Products', 'RS88 (12 TUBES / CASE)', 'N/A', 'EA', 0, false, true),
  ('ALL', 'Additional Products', 'RS65 (12 TUBES / CASE)', 'N/A', 'EA', 0, false, true);

COMMIT;
