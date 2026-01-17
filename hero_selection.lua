local PRoles = require(GetScriptDirectory() .. "/Library/PhalanxRoles")
local PHC = require(GetScriptDirectory() .. "/Library/PhalanxHeroCounters")

-- Load CM position mapping config
local CMConfigMapping = nil
pcall(function()
	CMConfigMapping = require(GetScriptDirectory() .. "/Library/cm_position_config")
end)

-- Utility function to split strings
function split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		table.insert(t, str)
	end
	return t
end

local RadiantNames = {"Helios", "Eos", "Phos", "Chrysos", "Doxa", "Arete", "Nike", "Elpis", "Iris", "Astraea", "Sophia", "Harmonia", "Euphrosyne", "Philia", "Charis", "Eudaimonia", "Thallo", "Auxo", "Hegemone", "Phanes", "Aster", "Theia", "Eunoia", "Agape", "Selene", "Hyperion", "Leto", "Artemis", "Apollon", "Mousa", "Hera", "Eileithyia", "Zelos", "Eirene", "Tyche", "Peitho", "Eupheme", "Aeon", "Gaia", "Rhea", "Dione", "Mnemosyne", "Hebe", "Kalliope", "Thalia", "Melpomene", "Terpsichore", "Euterpe", "Polymnia", "Urania"}
local DireNames = {"Nyx", "Skotos", "Erebus", "Thanatos", "Moros", "Ker", "Eris", "Apate", "Dolos", "Lyssa", "Nemesis", "Ate", "Phobos", "Deimos", "Hades", "Tartarus", "Lethe", "Styx", "Cerberus", "Empousa", "Gorgo", "Chimera", "Typhon", "Echidna", "Makhai", "Polemos", "Enyo", "Deino", "Oneiroi", "Algos", "Achlys", "Mania", "Penthos", "Oizys", "Dysnomia", "Hybris", "Moira", "Klotho", "Lachesis", "Atropos", "Alastor", "Mormo", "Epiales", "Sybaris", "Phlegyas", "Ceto", "Ladon", "Orthrus", "Pytho"}

local bn

if GetTeam() == TEAM_RADIANT then
	bn = RadiantNames
elseif GetTeam() == TEAM_DIRE then
	bn = DireNames
end

local randomname = RandomInt(1, #bn)
local botname1 = bn[randomname]
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
local botname2 = bn[randomname]
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
local botname3 = bn[randomname]
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
local botname4 = bn[randomname]
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
local botname5 = bn[randomname]
table.remove(bn, randomname)

function GetBotNames()
	return {botname1, botname2, botname3, botname4, botname5}
end

--[[ EDIT BY: Manslaughter ]]--

local SafeLanePool = PRoles["SafeLane"]
local MidLanePool = PRoles["MidLane"]
local OffLanePool = PRoles["OffLane"]
local SoftSupportPool = PRoles["SoftSupport"]
local HardSupportPool = PRoles["HardSupport"]

local pools = {SafeLanePool, MidLanePool, OffLanePool, SoftSupportPool, HardSupportPool}

local PickableHeroes = {}
local HeroesToAvoid = {}

local lastpicktime = -70
local delaytime = RandomInt(7, 14)
--local delaytime = RandomInt(0, 1)

function Think()
	local playerIDs = GetTeamPlayers(GetTeam())

	if GetGameMode() == GAMEMODE_AP then
		local TableIDs = GetTeamPlayers(GetTeam())
		local RandomID = RandomInt(1, #TableIDs)

		if IsPlayerInHeroSelectionControl(TableIDs[RandomID]) and IsPlayerBot(TableIDs[RandomID]) and (GetSelectedHeroName(TableIDs[RandomID]) == "" or GetSelectedHeroName(TableIDs[RandomID]) == nil) and (DotaTime() - lastpicktime) >= delaytime then
			UncounteredHeroes = {}
			PickableHeroes = {}

			local HeroPicks = GetPicks()
			local EnemyHeroPicks = GetEnemyPicks(TableIDs[RandomID])

			if #EnemyHeroPicks >= 1 then
				for v, pick in pairs(EnemyHeroPicks) do
					local CounteredHeroes = PHC[pick]

					if CounteredHeroes ~= nil then
						for i, hero in pairs(pools[RandomID]) do
							local IsHeroCountered = false

							for x, ch in pairs(CounteredHeroes) do
								if hero == ch then
									IsHeroCountered = true
									break
								end
							end

							if not IsHeroCountered then
								table.insert(UncounteredHeroes, hero)
							end
						end
					end
				end
			else
				UncounteredHeroes = pools[RandomID]
			end

			if #UncounteredHeroes <= 0 then
				UncounteredHeroes = pools[RandomID]
			end

			if #HeroPicks <= 0 then
				PickableHeroes = pools[RandomID]
			else
				for v, uch in pairs(UncounteredHeroes) do
					local IsHeroPicked = false

					for x, pick in pairs(HeroPicks) do
						if pick == uch then
							IsHeroPicked = true
							break
						end
					end

					if not IsHeroPicked then
						table.insert(PickableHeroes, uch)
					end
				end
			end

			if #PickableHeroes == 0 then
				-- Fallback: pick random hero from pool if no pickable heroes found
				PickableHeroes = pools[RandomID]
			end

			local SelectedHero = PickableHeroes[RandomInt(1, #PickableHeroes)]

			SelectHero(TableIDs[RandomID], SelectedHero)

			local SelectedPool = pools[RandomID]
			if SelectedPool == PRoles["SafeLane"] then
				PRoles["Positions"][SelectedHero] = "SafeLane"
			elseif SelectedPool == PRoles["MidLane"] then
				PRoles["Positions"][SelectedHero] = "MidLane"
			elseif SelectedPool == PRoles["OffLane"] then
				PRoles["Positions"][SelectedHero] = "OffLane"
			elseif SelectedPool == PRoles["SoftSupport"] then
				PRoles["Positions"][SelectedHero] = "SoftSupport"
			elseif SelectedPool == PRoles["HardSupport"] then
				PRoles["Positions"][SelectedHero] = "HardSupport"
			end

			lastpicktime = DotaTime()
			delaytime = RandomInt(5, 14)
			--delaytime = RandomInt(0, 1)
		end
	elseif GetGameMode() == GAMEMODE_CM then
		-- Install chat callback every tick (like in chatlisten.lua)
		if GetGameState() == GAME_STATE_HERO_SELECTION then
			InstallChatCallback(function(attr)
				CMChatCommandHandler(attr.player_id, attr.string, attr.team_only)
			end)
		end
		CMThink()
	end
end

------------------------------------------- CAPTAIN'S MODE (HUMAN CAPTAIN ONLY) ------------------------------------------------------------
-- Human captain picks heroes, then assigns positions via chat command
-- Chat command: -pos 5 4 3 2 1 (means: 1st pick→pos5, 2nd→pos4, 3rd→pos3, etc.)
-- Default (no command): Pos5 -> Pos4 -> Pos3 -> Pos2 -> Pos1
-- FIXED: Now tracks picks with TIMESTAMPS to preserve actual pick order!

local CMPickOrder = {"HardSupport", "SoftSupport", "OffLane", "MidLane", "SafeLane"}
local CMTrackedPicks = {} -- Array of {hero, timestamp} to preserve pick order
local CMPositionNames = {
	[1] = "SafeLane",
	[2] = "MidLane",
	[3] = "OffLane",
	[4] = "SoftSupport",
	[5] = "HardSupport"
}

-- Load initial mapping from config file (team-specific)
local CMCustomMapping = nil
local CMInitialLoadDone = false
local CMPickCounter = 0 -- Counter to track pick order
local CMRolesAssigned = false -- Flag to prevent repeated assignment spam

-- Chat command handler for position mapping
function CMChatCommandHandler(PlayerID, ChatText, bTeamOnly)
	local text = string.lower(ChatText)
	local words = split(text)

	if not words or #words < 1 then
		return
	end

	local command = words[1]

	-- -check command to show current positions
	if command == "-check" or command == "-status" then
		CMShowCurrentPositions()
		return
	end

	if #words < 2 then
		return
	end

	local targetTeam = nil
	local commandType = nil

	-- Detect command type: -pos, -radiant, or -dire
	if command == "-pos" then
		-- Only respond if it's team chat from our team
		if bTeamOnly and GetTeamForPlayer(PlayerID) == GetTeam() then
			targetTeam = GetTeam()
			commandType = "current"
		else
			print("[CM] ERROR: -pos must be used in TEAM CHAT only!")
			return -- Ignore if not team chat or not our team
		end
	elseif command == "-radiant" then
		targetTeam = TEAM_RADIANT
		commandType = "radiant"
	elseif command == "-dire" then
		targetTeam = TEAM_DIRE
		commandType = "dire"
	else
		return -- Not a position command
	end

	-- Extract position numbers (should have exactly 5)
	local positions = {}
	for i = 2, #words do
		local num = tonumber(words[i])
		if num then
			table.insert(positions, num)
		end
	end

	-- Validate positions
	if #positions ~= 5 then
		print("[CM] ERROR: Need exactly 5 positions. Example: -pos 5 4 3 2 1")
		print("[CM] You provided: " .. #positions .. " positions")
		return
	end

	-- Check all positions are 1-5 and no duplicates
	local used = {}
	for _, pos in ipairs(positions) do
		if pos < 1 or pos > 5 then
			print("[CM] ERROR: Positions must be 1-5. You used: " .. pos)
			return
		end
		if used[pos] then
			print("[CM] ERROR: Duplicate position " .. pos)
			return
		end
		used[pos] = true
	end

	-- Valid command! Apply it
	local teamName = (targetTeam == TEAM_RADIANT) and "Radiant" or "Dire"
	print("========================================")
	print("[CM] COMMAND ACCEPTED!")
	print("[CM] Team: " .. teamName)
	print("[CM] Command: -" .. commandType .. " " .. table.concat(positions, " "))
	print("========================================")

	-- Update mapping for our team if applicable
	if targetTeam == GetTeam() then
		CMCustomMapping = positions
		CMRolesAssigned = false -- Allow reassignment with new mapping
		print("[CM] *** POSITION MAPPING UPDATED ***")
		print("[CM] Pick Order:")
		print(CMFormatPositions(positions))
		print("========================================")

		-- Reapply role assignments immediately (works during draft or after)
		if #CMTrackedPicks >= 1 then
			CMApplyRoleAssignments()
			CMRolesAssigned = true
			print("[CM] Roles have been reassigned!")
		else
			print("[CM] Waiting for hero picks to apply roles...")
		end
	end

	-- Save to config file
	local commandData = {
		mapping = positions,
		team = targetTeam
	}
	CMSaveConfigFile(commandData)
end

function CMShowCurrentPositions()
	print("========================================")
	print("[CM] CURRENT POSITION MAPPING")
	print("========================================")

	local mapping = CMCustomMapping or {5, 4, 3, 2, 1}
	print(CMFormatPositions(mapping))

	print("----------------------------------------")
	print("[CM] Picked Heroes (" .. #CMTrackedPicks .. "/5):")
	if #CMTrackedPicks == 0 then
		print("  No heroes picked yet")
	else
		for i, pickData in ipairs(CMTrackedPicks) do
			local hero = pickData.hero
			local pos = mapping[i]
			local posName = CMPositionNames[pos]
			print("  " .. i .. ". " .. hero .. " -> Pos" .. pos .. " (" .. posName .. ") [Order: " .. pickData.order .. "]")
		end
	end
	print("========================================")
end

function CMFormatPositions(positions)
	local posNames = {"Carry", "Mid", "Off", "Soft", "Hard"}
	local result = {}
	for i, pos in ipairs(positions) do
		table.insert(result, "  Pick " .. i .. " -> Pos" .. pos .. " (" .. posNames[pos] .. ")")
	end
	return table.concat(result, "\n")
end

function CMThink()
	-- Load initial mapping on first run
	if not CMInitialLoadDone then
		if CMConfigMapping then
			local currentTeam = GetTeam()
			if currentTeam == TEAM_RADIANT and CMConfigMapping.Radiant then
				CMCustomMapping = CMConfigMapping.Radiant
				print("[CM] Loaded Radiant mapping: " .. table.concat(CMCustomMapping, " "))
			elseif currentTeam == TEAM_DIRE and CMConfigMapping.Dire then
				CMCustomMapping = CMConfigMapping.Dire
				print("[CM] Loaded Dire mapping: " .. table.concat(CMCustomMapping, " "))
			end
		end
		print("[CM] Chat Commands Available:")
		print("[CM]   -pos 5 4 3 2 1  (set positions in team chat)")
		print("[CM]   -check          (show current positions)")
		print("[CM] FIX APPLIED: Pick order now tracked correctly!")
		CMInitialLoadDone = true
	end

	-- Build list of all unique heroes across all pools
	local allUniqueHeroes = {}
	local heroSet = {}

	for _, pool in ipairs(pools) do
		for _, hero in ipairs(pool) do
			if not heroSet[hero] then
				heroSet[hero] = true
				table.insert(allUniqueHeroes, hero)
			end
		end
	end

	-- Check for newly picked heroes WITH TIMESTAMP
	for _, hero in ipairs(allUniqueHeroes) do
		if IsCMPickedHero(GetTeam(), hero) and not CMIsAlreadyTracked(hero) then
			-- Add to tracked picks list WITH PICK ORDER
			CMPickCounter = CMPickCounter + 1
			table.insert(CMTrackedPicks, {
				hero = hero,
				order = CMPickCounter,
				timestamp = DotaTime()
			})

			-- Show feedback
			local mapping = CMCustomMapping or {5, 4, 3, 2, 1}
			local pickNum = #CMTrackedPicks
			if pickNum <= 5 then
				local pos = mapping[pickNum]
				local posName = CMPositionNames[pos]
				print("========================================")
				print("[CM] PICK #" .. pickNum .. " DETECTED!")
				print("[CM] Hero: " .. hero)
				print("[CM] Pick Order Number: " .. CMPickCounter)
				print("[CM] Will be assigned to: Pos" .. pos .. " (" .. posName .. ")")
				print("[CM] Current mapping: " .. table.concat(mapping, " "))
				print("========================================")
			end
		end
	end

	-- Sort picks by order (just in case detection order was wrong)
	table.sort(CMTrackedPicks, function(a, b)
		return a.order < b.order
	end)

	-- Apply role assignments (only once to prevent spam)
	if #CMTrackedPicks == 5 and not CMRolesAssigned then
		CMApplyRoleAssignments()
		CMRolesAssigned = true
	end
end

function CMReadConfigFile()
	-- Read team-specific mappings from config file
	local success, config = pcall(function()
		return require(GetScriptDirectory() .. "/Library/cm_position_config")
	end)

	if success and config then
		-- Return the mapping for current team
		local currentTeam = GetTeam()
		if currentTeam == TEAM_RADIANT and config.Radiant then
			return config.Radiant
		elseif currentTeam == TEAM_DIRE and config.Dire then
			return config.Dire
		end
	end

	-- Default fallback
	return {5, 4, 3, 2, 1}
end

function CMSaveConfigFile(commandData)
	-- commandData = { mapping = {5,4,3,2,1}, team = TEAM_RADIANT }
	local mapping = commandData.mapping or commandData
	local targetTeam = commandData.team

	-- Read current config
	local success, config = pcall(function()
		return require(GetScriptDirectory() .. "/Library/cm_position_config")
	end)

	if not success or not config then
		config = {
			Radiant = {5, 4, 3, 2, 1},
			Dire = {5, 4, 3, 2, 1}
		}
	end

	-- Update the specific team's mapping
	if targetTeam == TEAM_RADIANT then
		config.Radiant = mapping
	elseif targetTeam == TEAM_DIRE then
		config.Dire = mapping
	else
		-- If no team specified, update current team
		if GetTeam() == TEAM_RADIANT then
			config.Radiant = mapping
		else
			config.Dire = mapping
		end
	end

	-- Write back to file
	local file = io.open(GetScriptDirectory() .. "/Library/cm_position_config.lua", "w")
	if not file then
		print("[CM] ERROR: Could not save config file!")
		return
	end

	file:write("-- Auto-updated by chat command\n")
	file:write("-- Last update: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n")
	file:write("return {\n")
	file:write("\tRadiant = {" .. table.concat(config.Radiant, ", ") .. "},\n")
	file:write("\tDire = {" .. table.concat(config.Dire, ", ") .. "},\n")
	file:write("}\n")
	file:close()

	print("[CM] Config saved to: Library/cm_position_config.lua")
end

function CMApplyRoleAssignments()
	-- Apply even if not all 5 picks are done (allows mid-draft changes)
	local mapping = CMCustomMapping or {5, 4, 3, 2, 1}

	-- Find which hero the human player has selected
	local humanHero = nil
	local teamPlayers = GetTeamPlayers(GetTeam())
	for _, playerID in pairs(teamPlayers) do
		if not IsPlayerBot(playerID) then
			-- This is the human player
			local heroName = GetSelectedHeroName(playerID)
			if heroName and heroName ~= "" then
				humanHero = heroName
				print("[CM] Detected human player's hero: " .. humanHero)
				break
			end
		end
	end

	-- Assign positions to all picked heroes
	for pickIndex = 1, #CMTrackedPicks do
		local pickData = CMTrackedPicks[pickIndex]
		local hero = pickData.hero
		local position = mapping[pickIndex]
		local roleName = CMPositionNames[position]

		if hero and roleName then
			-- Only assign to bots, skip human's hero
			if hero ~= humanHero then
				PRoles["Positions"][hero] = roleName
			else
				print("[CM] Skipping position assignment for human's hero: " .. hero)
			end
		end
	end

	-- Show confirmation when all 5 are assigned
	if #CMTrackedPicks == 5 then
		print("========================================")
		print("[CM] ALL ROLES ASSIGNED!")
		print("========================================")
		for i = 1, 5 do
			local pickData = CMTrackedPicks[i]
			local hero = pickData.hero
			local pos = mapping[i]
			local posName = CMPositionNames[pos]
			local isHuman = (hero == humanHero) and " [HUMAN]" or ""
			print("[CM] Pick #" .. i .. " (Order " .. pickData.order .. "): " .. hero .. " = Pos" .. pos .. " (" .. posName .. ")" .. isHuman)
		end
		print("========================================")
	end
end

function CMIsAlreadyTracked(heroName)
	for _, pickData in ipairs(CMTrackedPicks) do
		if pickData.hero == heroName then
			return true
		end
	end
	return false
end

------------------------------------------- END CAPTAIN'S MODE ------------------------------------------------------------

function UpdateLaneAssignments()
	if GetGameMode() == GAMEMODE_CM then
		return CMLaneAssignment()
	end

	if ( GetTeam() == TEAM_RADIANT )
	then
		return {
		[1] = LANE_BOT, -- Position 1 (Safe Lane)
		[2] = LANE_MID, -- Position 2 (Mid Lane)
		[3] = LANE_TOP, -- Position 3 (Off Lane)
		[4] = LANE_TOP, -- Position 4 (Soft Support)
		[5] = LANE_BOT, -- Position 5 (Hard Support)
}
	elseif ( GetTeam() == TEAM_DIRE )
	then
		return {
		[1] = LANE_TOP, -- Position 1 (Safe Lane)
		[2] = LANE_MID, -- Position 2 (Mid Lane)
		[3] = LANE_BOT, -- Position 3 (Off Lane)
		[4] = LANE_BOT, -- Position 4 (Soft Support)
		[5] = LANE_TOP, -- Position 5 (Hard Support)
}
	end
end

function CMLaneAssignment()
	-- CM mode lane assignment based on hero roles
	local lanes = {}
	local teamMembers = GetTeamPlayers(GetTeam())

	for i = 1, #teamMembers do
		local member = GetTeamMember(i)
		if member ~= nil and member:IsHero() then
			local heroName = member:GetUnitName()
			local role = PRoles["Positions"][heroName]

			if role == "SafeLane" then
				if GetTeam() == TEAM_RADIANT then
					lanes[i] = LANE_BOT
				else
					lanes[i] = LANE_TOP
				end
			elseif role == "MidLane" then
				lanes[i] = LANE_MID
			elseif role == "OffLane" then
				if GetTeam() == TEAM_RADIANT then
					lanes[i] = LANE_TOP
				else
					lanes[i] = LANE_BOT
				end
			elseif role == "SoftSupport" then
				if GetTeam() == TEAM_RADIANT then
					lanes[i] = LANE_TOP
				else
					lanes[i] = LANE_BOT
				end
			elseif role == "HardSupport" then
				if GetTeam() == TEAM_RADIANT then
					lanes[i] = LANE_BOT
				else
					lanes[i] = LANE_TOP
				end
			else
				-- Default lane if role not found
				lanes[i] = LANE_MID
			end
		end
	end

	return lanes
end

function GetPicks()
    local selectedHeroes = {}

	for i=0,20,1 do
		if IsTeamPlayer(i)==true then
			local hName = GetSelectedHeroName(i)
			if hName ~= "" and hName ~= nil then
				table.insert(selectedHeroes,hName)
			end
		end
    end

    return selectedHeroes
end

function GetEnemyPicks(id)
    local selectedHeroes = {}

	for v, i in pairs(GetTeamPlayers(GetOpposingTeam())) do
		local hName = GetSelectedHeroName(i)
		if hName ~= "" and hName ~= nil then
			table.insert(selectedHeroes,hName)
		end
    end

    return selectedHeroes
end
