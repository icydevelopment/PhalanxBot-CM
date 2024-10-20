local PRoles = require(GetScriptDirectory() .. "/Library/PhalanxRoles")
local PHC = require(GetScriptDirectory() .. "/Library/PhalanxHeroCounters")

local bn = {"Aquila", "Commodus", "Buteo", "Aurelius", "Priscus", "Modius", "Cassius", "Galeo", "Nerva", "Rufius", "Paetus", "Claudius", "Corvus", "Cornelius", "Verus", "Strabo", "Maximus", "Lucinius", "Flavius", "Severus", "Calidus", "Agrippa", "Tiberus", "Cicurinius"}
local prefixes = {"B", "C", "D", "E", "F", "G", "H", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "W"}

local prefix
local suffix

if GetTeam() == TEAM_RADIANT then
	suffix = "I"
elseif GetTeam() == TEAM_DIRE then
	suffix = "V"
end

local randomname = RandomInt(1, #bn)
prefix = prefixes[RandomInt(1, #prefixes)]
local botname1 = (prefix..". "..bn[randomname].." "..suffix)
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
prefix = prefixes[RandomInt(1, #prefixes)]
local botname2 = (prefix..". "..bn[randomname].." "..suffix)
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
prefix = prefixes[RandomInt(1, #prefixes)]
local botname3 = (prefix..". "..bn[randomname].." "..suffix)
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
prefix = prefixes[RandomInt(1, #prefixes)]
local botname4 = (prefix..". "..bn[randomname].." "..suffix)
table.remove(bn, randomname)

randomname = RandomInt(1, #bn)
prefix = prefixes[RandomInt(1, #prefixes)]
local botname5 = (prefix..". "..bn[randomname].." "..suffix)
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

-- For Captain's Mode
local HeroLanes = {
	[1] = LANE_MID,
	[2] = LANE_TOP,
	[3] = LANE_TOP,
	[4] = LANE_BOT,
	[5] = LANE_BOT,
};

local humanPick = {};
--------------------

function Think()
	local playerIDs = GetTeamPlayers(GetTeam())

	if GetGameMode() == GAMEMODE_AP then
		local TableIDs = GetTeamPlayers(GetTeam()) -- create a table with number of players, for example 5 and 5
		local RandomID = RandomInt(1, #TableIDs) -- to get a randomID
		
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
			
			SelectHero(TableIDs[RandomID], PickableHeroes[RandomInt(1, #PickableHeroes)])
			lastpicktime = DotaTime()
			delaytime = RandomInt(5, 14)
		end
	elseif GetGameMode() == GAMEMODE_CM then -- 855965029 Bot Experiment CM
		--CaptainModeLogic(); -- needed for bot captain
		AddToList(); -- needed for human captain for both teams
	end
end

	function UpdateLaneAssignments()
		if GetGameMode() == GAMEMODE_AP then
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
		elseif GetGameMode() == GAMEMODE_CM then
			return CMLaneAssignment()
		end
	end

---------------------------------------------------------CAPTAIN'S MODE LANE ASSIGNMENT------------------------------------------------
function CMLaneAssignment()
	FillLAHumanCaptain()
	return HeroLanes;
end

--Fill the lane assignment if the captain is human
function FillLAHumanCaptain()
	local TeamMember = GetTeamPlayers(GetTeam());
	for i = 1, #TeamMember do
		if GetTeamMember(i) ~= nil and GetTeamMember(i):IsHero() then
			local unit_name = GetTeamMember(i):GetUnitName();
			local key = GetFromHumanPick(unit_name);
			if key ~= nil then
				if key == 1 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_TOP;
					else
						HeroLanes[i] = LANE_BOT;
					end
				elseif key == 3 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_BOT;
					else
						HeroLanes[i] = LANE_TOP;
					end
				elseif key == 2 then
					HeroLanes[i] = LANE_MID;
				elseif key == 4 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_BOT;
					else
						HeroLanes[i] = LANE_TOP;
					end
				elseif key == 5 then
					if GetTeam() == TEAM_DIRE then
						HeroLanes[i] = LANE_TOP;
					else
						HeroLanes[i] = LANE_BOT;
					end
				end
			end
		end
	end
end

--Get human picked heroes if the captain is human player
function GetFromHumanPick(hero_name)
	local i = nil;
	for key, h in pairs(humanPick) do
		if hero_name == h then
			i = key;
		end
	end
	return i;
end

------------------------------------------- CAPTAIN'S MODE HERO and ROLE SELECTION ------------------------------------------------------------
function AddToList()
	if not IsPlayerBot(GetCMCaptain()) then
		for _, h in pairs(pools) do
			for _, j in pairs(h) do
				if IsCMPickedHero(GetTeam(), j) and not alreadyInTable(j) then
					table.insert(humanPick, j)
				end
			end
		end
	end
end

--Check if selected hero already picked by human
function alreadyInTable(hero_name)
	for _, h in pairs(humanPick) do
		if hero_name == h then
			return true
		end
	end
	return false
end


---------------------------------------------------------------------------------------------------------------------------------------
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