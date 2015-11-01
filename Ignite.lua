import { Callback, Game }
local IGNITESlot
local Enemy = {}

Bind('GameStart', function()
	IGNITESlot = (player:GetSpellData(SUMMONER_1).name:find('SummonerDot') and SUMMONER_1) or (player:GetSpellData(SUMMONER_2).name:find('SummonerDot') and SUMMONER_2) or nil
	Enemy = GetEnemies()
end)

Bind('Tick', function()
	if not IGNITESlot or player:CanUseSpell(IGNITESlot) ~= READY then return end
	Ignite()
end)

function Ignite()
	for index, enemy in ipairs(Enemy) do
		if enemy and enemy.valid and ValidTarget(enemy, 600) and enemy.health < 50 + 20*player.level then CastSpell(IGNITESlot, enemy) return end
	end
end

function ValidTarget(object, distance)
    return object and object.valid and object.visible and not object.dead and object.bTargetable and object.bInvulnerable == 0 and (distance == nil or player:DistanceTo(object) <= distance * distance)
end

function GetEnemies()
	local rT = {}
	for i = 1, HeroCount() do
		local hero = Hero(i)
		if hero and hero.valid and hero.team == TEAM_ENEMY then rT[#rT+1] = hero end
	end
	return rT
end
