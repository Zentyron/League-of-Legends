if GetObjectName(myHero) ~= "Kalista" then return end

local Epics = {"SRU_Baron", "SRU_Dragon", "TT_Spiderboss"}
local Mobs = {"SRU_Baron", "SRU_Dragon", "SRU_Red", "SRU_Blue", "SRU_Krug", "SRU_Murkwolf", "SRU_Razorbeak", "SRU_Gromp", "Sru_Crab", "TT_Spiderboss"}

local KalistaMenu = Menu("Kalista", "Kalista")
KalistaMenu:SubMenu("Combo", "Combo")
KalistaMenu.Combo:Boolean("Q", "Use Q", true)
KalistaMenu.Combo:Boolean("E", "E if reset + slow target", true)
KalistaMenu.Combo:Boolean("Items", "Use Items", true)
KalistaMenu.Combo:Slider("myHP", "if HP % <", 50, 0, 100, 1)
KalistaMenu.Combo:Slider("targetHP", "if Target HP % >", 20, 0, 100, 1)
KalistaMenu.Combo:Boolean("QSS", "Use QSS", true)
KalistaMenu.Combo:Slider("QSSHP", "if My Health % <", 75, 0, 100, 1)
KalistaMenu.Combo:Key("WallJump", "WallJump", string.byte("G"))
KalistaMenu.Combo:Key("SentinelBug", "Cast Sentinel Bug", string.byte("T"))

KalistaMenu:SubMenu("Harass", "Harass")
KalistaMenu.Harass:Boolean("Q", "Use Q", true)
KalistaMenu.Harass:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

KalistaMenu:SubMenu("Ult", "Ult")
KalistaMenu.Ult:Boolean("AutoR", "Save Ally with R", true)
KalistaMenu.Ult:Slider("AutoRHP", "min Ally HP %", 5, 1, 100, 1)

KalistaMenu:SubMenu("Killsteal", "Killsteal")
KalistaMenu.Killsteal:Boolean("Q", "Killsteal with Q", true)
KalistaMenu.Killsteal:Boolean("E", "Killsteal with E", true)

KalistaMenu:SubMenu("Misc", "Misc")
KalistaMenu.Misc:Boolean("AutoIgnite", "Auto Ignite", true)
KalistaMenu.Misc:Boolean("Autolvl", "Auto level", true)
KalistaMenu.Misc:List("Autolvltable", "Priority", 1, {"E-Q-W", "Q-E-W", "W-Q-E", "W-E-Q"})
KalistaMenu.Misc:Boolean("Edie", "Cast E before die", true)
KalistaMenu.Misc:Boolean("E", "E if Target Leave Range", true)
KalistaMenu.Misc:Slider("Elvl", "E if my level <", 12, 1, 18, 1)
KalistaMenu.Misc:Slider("minE", "min E Stacks", 7, 1, 20, 1)
KalistaMenu.Misc:Slider("Mana", "if Mana % >", 30, 0, 80, 1)

KalistaMenu:SubMenu("Drawings", "Drawings")
KalistaMenu.Drawings:Boolean("Q", "Draw Q Range", true)
KalistaMenu.Drawings:Boolean("E", "Draw E Range", true)
KalistaMenu.Drawings:Boolean("R", "Draw R Range", true)
KalistaMenu.Drawings:Boolean("Edmg", "Draw E% Dmg", true)

KalistaMenu:SubMenu("Farm", "Farm")
KalistaMenu.Farm:Boolean("ECanon", "Always E Big Minions", true)
KalistaMenu.Farm:Slider("Mana", "if Mana % >", 30, 0, 80, 1)
KalistaMenu.Farm:SubMenu("LaneClear", "LaneClear")
KalistaMenu.Farm.LaneClear:Slider("Farmkills", "E if X Can Be Killed", 2, 0, 10, 1)
KalistaMenu.Farm.LaneClear:Boolean("E", "E if reset + slow", true)
KalistaMenu.Farm:SubMenu("Jungle", "Jungle Clear")
KalistaMenu.Farm.Jungle:Boolean("firstmins", "Don't E jungle first 2 minutes", true)
KalistaMenu.Farm.Jungle:List("je", "Jungle Execute:", 3, {"OFF", "Epic Only", "Large & Epic Only", "Everything"})

GoS:DelayAction(function()
  for _,k in pairs(GoS:GetAllyHeroes()) do
    if GetObjectName(k) == "Blitzcrank" then
    KalistaMenu.Ult:Boolean("Balista", "Balista Combo", true)
    end
    if GetObjectName(k) == "Skarner" then
    KalistaMenu.Ult:Boolean("Skarlista", "Skarlista Combo", true)
    end
    if GetObjectName(k) == "TahmKench" then
    KalistaMenu.Ult:Boolean("Tahmlista", "Tahmlista Combo", true)
    end
  end
end, 1)



OnLoop(function(myHero)
 if IsDead(myHero) then return end
 
 local mousePos = GetMousePos()
    if IOW:Mode() == "Combo" then
	        
	local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1700,250,1150,50,true,true)
		
        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, 1150) and KalistaMenu.Combo.Q:Value() then
        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
        end

        for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
        
          local MinionPos = GetOrigin(minion)
          local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(target), MinionPos)
          if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 1150) and KalistaMenu.Combo.Q:Value() and GetCurrentHP(minion) < GoS:CalcDamage(myHero, minion, 60*GetCastLevel(myHero,_Q) - 50 + GetBaseDamage(myHero)) and isOnSegment and GoS:GetDistance(pointSegment,minion) < 50 then
          CastSkillShot(_Q, MinionPos.x, MinionPos.y, MinionPos.z)
          end
           
          if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(target, 1000) and KalistaMenu.Combo.E:Value() and GoS:GetDistance(target) > GetRange(myHero)+GetHitBox(myHero)+(target and GetHitBox(target) or GetHitBox(myHero)) and GotBuff(target, "kalistaexpungemarker") > 0 and GetCurrentHP(minion) < Edmg(minion) then
          CastSpell(_E)
          end
  
        end
	
	if GetItemSlot(myHero,3140) > 0 and KalistaMenu.Combo.QSS:Value() and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "zedultexecute") > 0 or GotBuff(myHero, "summonerexhaust") > 0 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < KalistaMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3140))
        end

        if GetItemSlot(myHero,3139) > 0 and KalistaMenu.Combo.QSS:Value() and GotBuff(myHero, "rocketgrab2") > 0 or GotBuff(myHero, "charm") > 0 or GotBuff(myHero, "fear") > 0 or GotBuff(myHero, "flee") > 0 or GotBuff(myHero, "snare") > 0 or GotBuff(myHero, "taunt") > 0 or GotBuff(myHero, "suppression") > 0 or GotBuff(myHero, "stun") > 0 or GotBuff(myHero, "zedultexecute") > 0 or GotBuff(myHero, "summonerexhaust") > 0 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < KalistaMenu.Combo.QSSHP:Value() then
        CastTargetSpell(myHero, GetItemSlot(myHero,3139))
        end
		
   end
	
   if IOW:Mode() == "Harass" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) >= KalistaMenu.Harass.Mana:Value() then
	
	local target = GetCurrentTarget()
	local QPred = GetPredictionForPlayer(GoS:myHeroPos(),target,GetMoveSpeed(target),1700,250,1150,50,true,true)
		
        if CanUseSpell(myHero, _Q) == READY and QPred.HitChance == 1 and GoS:ValidTarget(target, 1150) and KalistaMenu.Harass.Q:Value() then
        CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
        end
		
        for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
           local MinionPos = GetOrigin(minion)
           local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(target), MinionPos)
           if CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 1150) and KalistaMenu.Harass.Q:Value() and GetCurrentHP(minion) < GoS:CalcDamage(myHero, minion, 60*GetCastLevel(myHero,_Q) - 50 + GetBaseDamage(myHero)) and isOnSegment and GoS:GetDistance(pointSegment,minion) < 50 then
           CastSkillShot(_Q, MinionPos.x, MinionPos.y, MinionPos.z)
           end
        end

    end
    
	if KalistaMenu.Misc.E:Value() then
	   for i,enemy in pairs(GoS:GetEnemyHeroes()) do
                if 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Misc.Mana:Value() and GetLevel(myHero) <= KalistaMenu.Misc.Elvl:Value() then
		   if GotBuff(enemy, "kalistaexpungemarker") >= KalistaMenu.Misc.minE:Value() and GoS:ValidTarget(target, 1100) and GoS:GetDistance(enemy) >= 1000 then
		   CastSpell(_E)
		   end
		end
	   end
	end
	
	if KalistaMenu.Misc.Edie:Value() then 
	  if CanUseSpell(myHero, _E) and GetLevel(myHero) < 6 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < 3 then
	  CastSpell(_E)
	  elseif CanUseSpell(myHero, _E) and GetLevel(myHero) > 5 and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < 5 then
	  CastSpell(_E)
	  end
	end
		
	if CanUseSpell(myHero,_W) == READY and KalistaMenu.Combo.SentinelBug:Value() then
	  if GoS:GetDistance(Vector(9882.892, -71.24, 4438.446)) < GoS:GetDistance(Vector(5087.77, -71.24, 10471.3808)) and GoS:GetDistance(Vector(9882.892, -71.24, 4438.446)) < 5200 then
          CastSkillShot(_W,9882.892, -71.24, 4438.446)	
          elseif GoS:GetDistance(Vector(5087.77, -71.24, 10471.3808)) < 5200 then
          CastSkillShot(_W,5087.77, -71.24, 10471.3808)
          end
	end
			
	if KalistaMenu.Ult.AutoR:Value() then 
	  for _, ally in pairs(GoS:GetAllyHeroes()) do
	  local soulboundhero = GotBuff(ally, "kalistacoopstrikeally") > 0
            for i,enemy in pairs(GoS:GetEnemyHeroes()) do 
	      if CanUseSpell(myHero,_R) == READY and soulboundhero and 100*GetCurrentHP(ally)/GetMaxHP(ally) <= KalistaMenu.Ult.AutoRHP:Value() and GoS:ValidTarget(ally, 1450) and GoS:GetDistance(ally, enemy) <= 1000 then
              CastSpell(_R)
	      PrintChat("Rescuing low health "..GetObjectName(ally).."")
	      end
	    end
	  end
	end
	
	for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	
           local QPred = GetPredictionForPlayer(GoS:myHeroPos(),enemy,GetMoveSpeed(enemy),1700,250,1150,50,true,true)
	
	if IOW:Mode() == "Combo" then
	   if GetItemSlot(myHero,3153) > 0 and KalistaMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < KalistaMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > KalistaMenu.Combo.targetHP:Value() then
           CastTargetSpell(enemy, GetItemSlot(myHero,3153))
           end

           if GetItemSlot(myHero,3144) > 0 and KalistaMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 550) and 100*GetCurrentHP(myHero)/GetMaxHP(myHero) < KalistaMenu.Combo.myHP:Value() and 100*GetCurrentHP(enemy)/GetMaxHP(enemy) > KalistaMenu.Combo.targetHP:Value() then
           CastTargetSpell(enemy, GetItemSlot(myHero,3144))
           end

           if GetItemSlot(myHero,3142) > 0 and KalistaMenu.Combo.Items:Value() and GoS:ValidTarget(enemy, 600) then
           CastTargetSpell(myHero, GetItemSlot(myHero,3142))
           end
		   
        end
        
	   if Ignite and KalistaMenu.Misc.AutoIgnite:Value() then
             if CanUseSpell(myHero, Ignite) == READY and 20*GetLevel(myHero)+50 > GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)*2.5 and GoS:ValidTarget(enemy, 600) then
             CastTargetSpell(enemy, Ignite)
             end
	   end
	   
           if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(enemy, 1000) and KalistaMenu.Killsteal.E:Value() and GetCurrentHP(enemy)+GetDmgShield(enemy)+GetHPRegen(enemy)/8 < Edmg(enemy) then
	   CastSpell(_E)
	   elseif CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(enemy, 1150) and KalistaMenu.Killsteal.Q:Value() and QPred.HitChance == 1 and GetCurrentHP(enemy)+GetDmgShield(enemy) < GoS:CalcDamage(myHero, enemy, 60*GetCastLevel(myHero,_Q) - 50 + GetBaseDamage(myHero)) then  
           CastSkillShot(_Q,QPred.PredPos.x,QPred.PredPos.y,QPred.PredPos.z)
           elseif CanUseSpell(myHero, _Q) == READY and GoS:ValidTarget(target, 1150) and KalistaMenu.Killsteal.Q:Value() and GetCurrentHP(enemy) < GoS:CalcDamage(myHero, enemy, 60*GetCastLevel(myHero,_Q) - 50 + GetBaseDamage(myHero)) then
             for _,minion in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
               local MinionPos = GetOrigin(minion)
               local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(GetOrigin(myHero), GetOrigin(enemy), MinionPos)
               if isOnSegment and GoS:GetDistance(pointSegment,minion) < 50 then
               CastSkillShot(_Q, MinionPos.x, MinionPos.y, MinionPos.z)
               end
             end
           end
	   
	   if KalistaMenu.Drawings.Edmg:Value() then
	     local targetPos = GetOrigin(enemy)
             local drawPos = WorldToScreen(1,targetPos.x,targetPos.y,targetPos.z)
	     if Edmg(enemy) > GetCurrentHP(enemy) then
	     DrawText("100%",20,drawPos.x,drawPos.y,0xffffffff)
	     elseif Edmg(enemy) > 0 then
             DrawText(math.floor(Edmg(enemy)/GetCurrentHP(enemy)*100).."%",20,drawPos.x,drawPos.y,0xffffffff)
             end
	   end
	   
    end
	
	for _,k in pairs(GoS:GetAllyHeroes()) do
           if GetObjectName(k) == "Blitzcrank" then
		for i,enemy in pairs(GoS:GetEnemyHeroes()) do
  	          if GotBuff(k, "kalistacoopstrikeally") > 0 and GoS:ValidTarget(enemy, 2450) and KalistaMenu.Ult.Balista:Value() and GetCurrentHP(enemy) > 300 and GetCurrentHP(myHero) > 400 and GoS:GetDistance(k, enemy) > 400 and GoS:GetDistance(enemy) > 400 and GoS:GetDistance(enemy) > GoS:GetDistance(k, enemy)+100 and GotBuff(enemy, "rocketgrab2") > 0 then
                  CastSpell(_R)
                  end
                end
	    end
	
            if GetObjectName(k) == "Skarner" then
	        for i,enemy in pairs(GoS:GetEnemyHeroes()) do
		  if GotBuff(k, "kalistacoopstrikeally") > 0 and GoS:ValidTarget(enemy, 1750) and KalistaMenu.Ult.Skarlista:Value() and GoS:GetDistance(enemy) > 400 and GetCurrentHP(enemy) > 300 and GetCurrentHP(myHero) > 400 and GotBuff(enemy, "skarnerimpale") > 0 then
                  CastSpell(_R)
                  end
                end
            end
			
	    if GetObjectName(k) == "TahmKench" then
		for i,enemy in pairs(GoS:GetEnemyHeroes()) do
	          if GotBuff(k, "kalistacoopstrikeally") > 0 and GoS:ValidTarget(enemy, 1400) and KalistaMenu.Ult.Tahmlista:Value() and GoS:GetDistance(enemy) > 400 and GetCurrentHP(enemy) > 300 and GetCurrentHP(myHero) > 400 and GotBuff(enemy, "tahmkenchwdevoured") > 0 then
                  CastSpell(_R)
                  end
                end
            end
	end	
	
    local killableminions = 0
    for _,unit in pairs(GoS:GetAllMinions(MINION_ENEMY)) do
   
      if Edmg(unit) > 0 and Edmg(unit) > GetCurrentHP(unit) and (GetObjectName(unit) == "Siege" or GetObjectName(unit) == "super") and GoS:ValidTarget(unit, 1000) and KalistaMenu.Farm.ECanon:Value() and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Farm.Mana:Value() then 
      CastSpell(_E)
      end

      if Edmg(unit) > 0 and Edmg(unit) > GetCurrentHP(unit) and GoS:ValidTarget(unit, 1000) then 
      killableminions = killableminions + 1
      end

      if IOW:Mode() == "LaneClear" and 100*GetCurrentMana(myHero)/GetMaxMana(myHero) > KalistaMenu.Farm.Mana:Value() then
      	 local target = GetCurrentTarget()
      	 
         if CanUseSpell(myHero, _E) == READY and GoS:ValidTarget(target, 1000) and KalistaMenu.Farm.LaneClear.E:Value() and GotBuff(target, "kalistaexpungemarker") > 0 and GetCurrentHP(unit) < Edmg(unit) then
         CastSpell(_E)
         end
 
         if killableminions > KalistaMenu.Farm.LaneClear.Farmkills:Value() then
         CastSpell(_E)
	 end
      end
	
    end
    
for _,spot in pairs(WallSpots) do
  if KalistaMenu.Combo.WallJump:Value() then 
  
    if GoS:GetDistance(spot) <= 7000 and GoS:GetDistance(spot, mousePos) > 125 then                
    DrawCircle(spot.x,spot.y,spot.z,80,2,100,ARGB(255, 255, 255, 0))
    end
    
    if GoS:GetDistance(spot) <= 7000 and GoS:GetDistance(spot, mousePos) <= 125 then 
    DrawCircle(spot.x,spot.y,spot.z,80,2,100,ARGB(255, 0, 255, 0))
    end
    
    if GoS:GetDistance(spot, mousePos) <= 125 and GoS:GetDistance(spot) > 22 then
    MoveToXYZ(spot.x, spot.y, spot.z)
    end
    
    if GoS:GetDistance(spot) <= 22 then
    CastSkillShot(_Q, (Vector(spot)+(Vector((Vector(spot.x2, spot.y2, spot.z2)))-Vector(spot)):normalized()*100).x+110, (Vector(spot)+(Vector((Vector(spot.x2, spot.y2, spot.z2)))- Vector(spot)):normalized()* 100).y+110, (Vector(spot)+ (Vector((Vector(spot.x2, spot.y2, spot.z2)))-Vector(spot)):normalized()*100).z+110)
    GoS:DelayAction(function() MoveToXYZ(Vector(Vector(spot.x2, spot.y2, spot.z2)).x, Vector(Vector(spot.x2, spot.y2, spot.z2)).y, Vector(Vector(spot.x2, spot.y2, spot.z2)).z) end, 5)
    end
  end
end
	
for _,unit in pairs(GoS:GetAllMinions(MINION_JUNGLE)) do
   
    if GoS:ValidTarget(unit, 1000) and CanUseSpell(myHero, _E) == READY and KalistaMenu.Farm.Jungle.je:Value() ~= 1 then
      if KalistaMenu.Farm.Jungle.je:Value() == 2 then
        for i,Epic in pairs(Epics) do
          if GetObjectName(unit) == Epic and GetCurrentHP(unit) < Edmg(unit) then  
          CastSpell(_E)
          end
        end
      end 
      
      if KalistaMenu.Farm.Jungle.je:Value() == 3 then
        for i,Mob in pairs(Mobs) do
          if GetObjectName(unit) == Mob and GetCurrentHP(unit) < Edmg(unit) then  
          CastSpell(_E)
          end
        end
      end 
      
      if KalistaMenu.Farm.Jungle.je:Value() == 4 then
        if GetCurrentHP(unit) < Edmg(unit) then  
        CastSpell(_E)
        end
      end
      
    end
   
        if Gos:ValidTarget(unit, 2000) and KalistaMenu.Drawings.Edmg:Value() then
	local mobPos = GetOrigin(unit)
        local drawPos = WorldToScreen(1,mobPos.x,mobPos.y,mobPos.z)
          if Edmg(unit) > GetCurrentHP(unit) then
	  DrawText("100%",20,drawPos.x,drawPos.y,0xffffffff)
	  elseif Edmg(unit) > 0 then
          DrawText(math.floor(Edmg(unit)/GetCurrentHP(unit)*100).."%",20,drawPos.x,drawPos.y,0xffffffff)
          end
        end
end

if KalistaMenu.Misc.Autolvl:Value() then  
      if KalistaMenu.Misc.Autolvltable:Value() == 1 then leveltable = {_E, _W, _Q, _E, _E, _R, _E, _Q, _E, _Q, _R, _Q, _Q, _W, _W, _R, _W, _W}
      elseif KalistaMenu.Misc.Autolvltable:Value() == 2 then leveltable = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}
      elseif KalistaMenu.Misc.Autolvltable:Value() == 3 then leveltable = {_W, _Q, _E, _W, _W, _R, _W, _Q, _W, _Q, _R, _Q, _Q, _E, _E, _R, _E, _E}
      elseif KalistaMenu.Misc.Autolvltable:Value() == 4 then leveltable = {_W, _E, _Q, _W, _W, _R, _W, _E, _W, _E, _R, _E, _E, _Q, _Q, _R, _Q, _Q}
      end
LevelSpell(leveltable[GetLevel(myHero)]) 
end

if KalistaMenu.Drawings.Q:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1150,1,128,0xff00ff00) end
if KalistaMenu.Drawings.E:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1000,1,128,0xff00ff00) end
if KalistaMenu.Drawings.R:Value() then DrawCircle(GoS:myHeroPos().x, GoS:myHeroPos().y, GoS:myHeroPos().z,1450,1,128,0xff00ff00) end
end)

OnProcessSpell(function(unit, spell)
if unit and unit == myHero and spell then
  if spell.name:lower():find("kalistapspellcast") then
  PrintChat("You are now pledged to "..GetObjectName(spell.target).."")
  end
end
end)

function CalcDamage(source, target, addmg)
    local ADDmg = addmg or 0
    local ArmorPen = GetObjectType(source) == Obj_AI_Minion and 0 or math.floor(GetArmorPenFlat(source))
    local ArmorPenPercent = GetObjectType(source) == Obj_AI_Minion and 1 or math.floor(GetArmorPenPercent(source)*100)/100
    local Armor = GetArmor(target)*ArmorPenPercent-ArmorPen
    local ArmorPercent = (GetObjectType(source) == Obj_AI_Minion and Armor < 0) and 0 or Armor > 0 and math.floor(Armor*100/(100+Armor))/100 or math.ceil(Armor*100/(100-Armor))/100
    return (GotBuff(target, "ferocioushowl") > 0 and 0.3 or GotBuff(target, "meditate") > 0 and 0.55-0.05*GetCastLevel(target,_W) or GotBuff(target, "galioidolofdurand") > 0 and 0.5 or GotBuff(source,"exhausted")  > 0 and 0.6 or GotBuff(target, "garenw") > 0 and 0.7 or GotBuff(target, "braumshieldbuff") > 0 and 0.725-0.025*GetCastLevel(target, _E) or GotBuff(target, "maokaidrain3defense") > 0 and 0.8 or GotBuff(target, "katarinaereduction") > 0 and 0.85 or GotBuff(target, "gragaswself") > 0 and 0.92-0.02*GetCastLevel(target, _W) or GotBuff(target, "vladimirhemoplaguedebuff") > 0 and 1.12 or 1) * math.floor(ADDmg*(1-ArmorPercent))
end

function Edmg(unit)
  dmg = {10,14,19,25,32}
  scaling = {0.2,0.225,0.25,0.275,0.3}
  
  local Stacks = GetBuffData(unit, "kalistaexpungemarker")
  local dmg = CalcDamage(myHero, unit, Stacks.Count > 0 and (10 + 10 * GetCastLevel(myHero,_E) + 0.6 * (GetBaseDamage(myHero) + GetBonusDmg(myHero)) + (Stacks.Count - 1) * (dmg[GetCastLevel(myHero,_E)] + scaling[GetCastLevel(myHero,_E)] * (GetBaseDamage(myHero) + GetBonusDmg(myHero))) or 0))

  return dmg
end

WallSpots = {
      {
        x = 8260,
        y = 51,
        z = 2890,
        x2 = 8210,
        y2 = 51.75,
        z2 = 3165
      },
      {
        x = 4630,
        y = 95.7,
        z = 3020,
        x2 = 4924,
        y2 = 50.98,
        z2 = 3058
      },
      {
        x = 4924,
        y = 51,
        z = 3058,
        x2 = 4594,
        y2 = 95,
        z2 = 2964
      },
      {
        x = 8222,
        y = 51,
        z = 3158,
        x2 = 8300,
        y2 = 51,
        z2 = 2888
      },
      {
        x = 11872,
        y = -72,
        z = 4358,
        x2 = 12072,
        y2 = 51,
        z2 = 4608
      },
      {
        x = 12072,
        y = 51,
        z = 4608,
        x2 = 11818,
        y2 = -71,
        z2 = 4456
      },
      {
        x = 10772,
        y = 51,
        z = 7208,
        x2 = 10738,
        y2 = 52,
        z2 = 7450
      },
      {
        x = 10738,
        y = 52,
        z = 7450,
        x2 = 10772,
        y2 = 51,
        z2 = 7208
      },
      {
        x = 11572,
        y = 52,
        z = 8706,
        x2 = 11768,
        y2 = 51,
        z2 = 8904
      },
      {
        x = 11768,
        y = 51,
        z = 8904,
        x2 = 11572,
        y2 = 52,
        z2 = 8706
      },
      {
        x = 7972,
        y = 51,
        z = 5908,
        x2 = 8002,
        y2 = 52,
        z2 = 6208
      },
      {
        x = 7194,
        y = 51,
        z = 5630,
        x2 = 7372,
        y2 = 52,
        z2 = 5858
      },
      {
        x = 7372,
        y = 52,
        z = 5858,
        x2 = 7194,
        y2 = 51,
        z2 = 5630
      },
      {
        x = 7572,
        y = 51,
        z = 6158,
        x2 = 7718,
        y2 = 52,
        z2 = 6420
      },
      {
        x = 7024,
        y = -71,
        z = 8406,
        x2 = 7224,
        y2 = 53,
        z2 = 8556
      },
      {
        x = 7224,
        y = 53,
        z = 8556,
        x2 = 7088,
        y2 = -71,
        z2 = 8378
      },
      {
        x = 8204,
        y = -71,
        z = 6080,
        x2 = 8058,
        y2 = 51,
        z2 = 5838
      },
      {
        x = 7772,
        y = -49,
        z = 6358,
        x2 = 7610,
        y2 = 52,
        z2 = 6128
      },
      {
        x = 5774,
        y = 55,
        z = 10656,
        x2 = 5430,
        y2 = -71,
        z2 = 10640
      },
      {
        x = 5474,
        y = -71.2406,
        z = 10665,
        x2 = 5754,
        y2 = 55.9,
        z2 = 10718
      },
      {
        x = 3666,
        y = 51.8,
        z = 7430,
        x2 = 3674,
        y2 = 51.7,
        z2 = 7706
      },
      {
        x = 3672,
        y = 51.7,
        z = 7686,
        x2 = 3774,
        y2 = 51.8,
        z2 = 7408
      },
      {
        x = 3274,
        y = 52.46,
        z = 6208,
        x2 = 3086,
        y2 = 57,
        z2 = 6032
      },
      {
        x = 3086,
        y = 57,
        z = 6032,
        x2 = 3274,
        y2 = 52.46,
        z2 = 6208
      },
      {
        x = 5126,
        y = -71,
        z = 9988,
        x2 = 5130,
        y2 = -70,
        z2 = 9664
      },
      {
        x2 = 5126,
        y2 = -71,
        z2 = 9988,
        x = 5018,
        y = -70,
        z = 9734
      },
      {
        x = 10462,
        y = -71,
        z = 4352,
        x2 = 10660,
        y2 = -72,
        z2 = 4488
      },
      {
        x = 6582,
        y = 53.8,
        z = 11694,
        x2 = 6516,
        y2 = 56.4,
        z2 = 11990
      },
      {
        x = 6516,
        y = 56.4,
        z = 11990,
        x2 = 6582,
        y2 = 53.8,
        z2 = 11694
      },
      {
        x = 5231,
        y = 56.4,
        z = 12092,
        x2 = 5212,
        y2 = 56.8,
        z2 = 11794
      },
      {
        x = 5212,
        y = 56.8,
        z = 11794,
        x2 = 5231,
        y2 = 56.4,
        z2 = 12092
      },
      {
        x = 9654,
        y = 64,
        z = 3052,
        x2 = 9630,
        y2 = 49.2,
        z2 = 2794
      },
      {
        x = 9630,
        y = 49.2,
        z = 2794,
        x2 = 9654,
        y2 = 64,
        z2 = 3052
      },
      {
        x = 3324,
        y = -64,
        z = 10160,
        x2 = 3124,
        y2 = 53,
        z2 = 9956
      },
      {
        x = 3124,
        y = 53,
        z = 9956,
        x2 = 3324,
        y2 = -64,
        z2 = 10160
      },
      {
        x = 9314,
        y = -71.24,
        z = 4518,
        x2 = 9022,
        y2 = 52.44,
        z2 = 4508
      },
      {
        x = 4424,
        y = 49.11,
        z = 8056,
        x2 = 4134,
        y2 = 50.53,
        z2 = 7986
      },
      {
        x = 4134,
        y = 50.53,
        z = 7986,
        x2 = 4424,
        y2 = 49.11,
        z2 = 8056
      },
      {
        x = 2596,
        y = 51.7,
        z = 9228,
        x2 = 2874,
        y2 = 50.6,
        z2 = 9256
      },
      {
        x = 2874,
        y = 50.6,
        z = 9256,
        x2 = 2596,
        y2 = 51.7,
        z2 = 9228
      },
      {
        x = 11722,
        y = 51.7,
        z = 5024,
        x2 = 11556,
        y2 = -71.24,
        z2 = 4870
      },
      {
        x = 11556,
        y = -71.24,
        z = 4870,
        x2 = 11722,
        y2 = 51.7,
        z2 = 5024
      },
      {
        x = 2924,
        y = 53.5,
        z = 4958,
        x2 = 2894,
        y2 = 95.7,
        z2 = 4648
      },
      {
        x2 = 2924,
        y2 = 53.5,
        z2 = 4958,
        x = 2894,
        y = 95.7,
        z = 4648
      },
      {
        x = 11922,
        y = 51.7,
        z = 4758,
        x2 = 11772,
        y2 = -71.24,
        z2 = 4608
      },
      {
        x = 11772,
        y = -71.24,
        z = 4608,
        x2 = 11922,
        y2 = 51.7,
        z2 = 4758
      },
      {
        x = 11592,
        y = 52.8,
        z = 5316,
        x2 = 11342,
        y2 = -61,
        z2 = 5274
      },
      {
        x2 = 11592,
        y2 = 52.8,
        z2 = 5316,
        x = 11342,
        y = -61,
        z = 5274
      },
      {
        x = 10694,
        y = -70.24,
        z = 4526,
        x2 = 10472,
        y2 = -71.24,
        z2 = 4408
      },
      {
        x = 9722,
        y = -71.24,
        z = 4908,
        x2 = 9700,
        y2 = -72.5,
        z2 = 5198
      },
      {
        x2 = 9722,
        y2 = -71.24,
        z2 = 4908,
        x = 9700,
        y = -72.5,
        z = 5198
      },
      {
        x = 6126,
        y = 48.5,
        z = 5304,
        x2 = 6090,
        y2 = 51.7,
        z2 = 5572
      },
      {
        x2 = 6126,
        y2 = 48.5,
        z2 = 5304,
        x = 6090,
        y = 51.7,
        z = 5572
      },
      {
        x = 3388,
        y = 95.7,
        z = 4414,
        x2 = 3524,
        y2 = 54.15,
        z2 = 4708
      },
      {
        x = 3108,
        y = 51.5,
        z = 6428,
        x2 = 2924,
        y2 = 57,
        z2 = 6208
      },
      {
        x2 = 3108,
        y2 = 51.5,
        z2 = 6428,
        x = 2924,
        y = 57,
        z = 6208
      },
      {
        x2 = 2824,
        y2 = 56.4,
        z2 = 6708,
        x = 3074,
        y = 51.5,
        z = 6758
      },
      {
        x = 2824,
        y = 56.4,
        z = 6708,
        x2 = 3074,
        y2 = 51.5,
        z2 = 6758
      },
      {
        x = 11860,
        y = 52.3,
        z = 10032,
        x2 = 11914,
        y2 = 91.4,
        z2 = 10360
      },
      {
        x2 = 11860,
        y2 = 52.3,
        z2 = 10032,
        x = 11914,
        y = 91.4,
        z = 10360
      },
      {
        x2 = 12372,
        y2 = 91.4,
        z2 = 10256,
        x = 12272,
        y = 52.3,
        z = 9956
      },
      {
        x = 12372,
        y = 91.4,
        z = 10256,
        x2 = 12272,
        y2 = 52.3,
        z2 = 9956
      },
      {
        x = 11772,
        y = 54.54,
        z = 8206,
        x2 = 12072,
        y2 = 52.3,
        z2 = 8156
      },
      {
        x2 = 11772,
        y2 = 54.54,
        z2 = 8206,
        x = 12072,
        y = 52.3,
        z = 8156
      },
      {
        x2 = 11338,
        y2 = 52.2,
        z2 = 7496,
        x = 11372,
        y = 51.7,
        z = 7208
      },
      {
        x = 11338,
        y = 52.2,
        z = 7496,
        x2 = 11372,
        y2 = 51.7,
        z2 = 7208
      },
      {
        x = 12272,
        y = 51.7,
        z = 5408,
        x2 = 12034,
        y2 = 54.6,
        z2 = 5420
      },
      {
        x2 = 12272,
        y2 = 51.7,
        z2 = 5408,
        x = 12034,
        y = 54.6,
        z = 5420
      },
      {
        x = 10432,
        y = 51.9,
        z = 6768,
        x2 = 10712,
        y2 = 51.7,
        z2 = 6906
      },
      {
        x = 12272,
        y = 52.6,
        z = 5558,
        x2 = 11966,
        y2 = 53.5,
        z2 = 5592
      },
      {
        x2 = 12272,
        y2 = 52.6,
        z2 = 5558,
        x = 11966,
        y = 53.5,
        z = 5592
      },
      {
        x2 = 6824,
        y2 = -71.24,
        z2 = 8606,
        x = 6924,
        y = 52.8,
        z = 8856
      },
      {
        x = 6824,
        y = -71.24,
        z = 8606,
        x2 = 6924,
        y2 = 52.8,
        z2 = 8856
      },
      {
        x = 4908,
        y = 56.6,
        z = 11884,
        x2 = 4974,
        y2 = 56.4,
        z2 = 12102
      },
      {
        x2 = 4908,
        y2 = 56.6,
        z2 = 11884,
        x = 4974,
        y = 56.4,
        z = 12102
      },
      {
        x2 = 3474,
        y2 = -64.6,
        z2 = 9806,
        x = 3208,
        y = 51.4,
        z = 9696
      },
      {
        x = 3474,
        y = -64.6,
        z = 9806,
        x2 = 3208,
        y2 = 51.4,
        z2 = 9696
      },
      {
        x = 2574,
        y = 53,
        z = 9456,
        x2 = 2832,
        y2 = 51.2,
        z2 = 9480
      },
      {
        x2 = 2574,
        y2 = 53,
        z2 = 9456,
        x = 2832,
        y = 51.2,
        z = 9480
      },
      {
        x2 = 4474,
        y2 = -71.2,
        z2 = 10456,
        x = 4234,
        y = -71.2,
        z = 10306
      },
      {
        x = 4474,
        y = -71.2,
        z = 10456,
        x2 = 4234,
        y2 = -71.2,
        z2 = 10306
      },
      {
        x = 8086,
        y = 51.8,
        z = 9684,
        x2 = 8396,
        y2 = 50.3,
        z2 = 9672
      },
      {
        x2 = 9972,
        y2 = 52.3,
        z2 = 11756,
        x = 10278,
        y = 91.4,
        z = 11858
      },
      {
        x = 9972,
        y = 52.3,
        z = 11756,
        x2 = 10278,
        y2 = 91.4,
        z2 = 11858
      },
      {
        x2 = 10122,
        y2 = 91.4,
        z2 = 12406,
        x = 9822,
        y = 52.3,
        z = 12306
      },
      {
        x = 10122,
        y = 91.4,
        z = 12406,
        x2 = 9822,
        y2 = 52.3,
        z2 = 12306
      },
      {
        x = 4674,
        y = 95.74,
        z = 2608,
        x2 = 4974,
        y2 = 51.19,
        z2 = 2658
      },
      {
        x2 = 4674,
        y2 = 95.74,
        z2 = 2608,
        x = 4974,
        y = 51.19,
        z = 2658
      },
      {
        x = 2474,
        y = 95.74,
        z = 4708,
        x2 = 2524,
        y2 = 52.79,
        z2 = 5008
      },
      {
        x2 = 2474,
        y2 = 95.74,
        z2 = 4708,
        x = 2524,
        y = 52.79,
        z = 5008
      },
      {
        x = 9632,
        y = 52.65,
        z = 9160,
        x2 = 9192,
        y2 = 52.01,
        z2 = 9400
      },
      {
        x2 = 9632,
        y2 = 52.65,
        z2 = 9160,
        x = 9192,
        y = 52.01,
        z = 9400
      }
}
