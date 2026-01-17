-- ========================================
-- CAPTAIN MODE - TEAM-SPECIFIC POSITIONS
-- ========================================
-- Her takım için AYRI sıralama!
--
-- IN-GAME CHAT COMMANDS:
--   -radiant 5 4 3 2 1  = Radiant pozisyonlarını ayarla
--   -dire 4 3 5 1 2     = Dire pozisyonlarını ayarla
--   -pos 5 4 3 2 1      = Kendi takımının pozisyonlarını ayarla
--
-- Pozisyonlar:
--   1 = Pos1 (Carry), 2 = Pos2 (Mid), 3 = Pos3 (Offlane)
--   4 = Pos4 (Soft Support), 5 = Pos5 (Hard Support)
-- ========================================

return {
	-- RADIANT TEAM Pick Order
	Radiant = {5, 4, 3, 2, 1},
	-- Means: 1st pick→Pos5, 2nd pick→Pos4, 3rd→Pos3, 4th→Pos2, 5th→Pos1

	-- DIRE TEAM Pick Order
	Dire = {5, 4, 3, 2, 1},
	-- Means: 1st pick→Pos4, 2nd pick→Pos3, 3rd→Pos5, 4th→Pos1, 5th→Pos2
}
