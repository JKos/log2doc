champions = {}
skills = { 
	"accuracy","athletics", "armors", "critical", "dodge", "missile_weapons",
	"throwing", "firearms", "light_weapons", "heavy_weapons", "concentration", "alchemy",
	"fire_magic","earth_magic","water_magic","air_magic" 
}

stats = {'strength','dexterity','vitality','willpower'}

conditions = {}

traits = {
	"fighter","barbarian","knight","rogue","wizard","battle_mage","alchemist","farmer","human",
	"minotaur","lizardman","insectoid","ratling","skilled","fast_learner","head_hunter","rage",
	"fast_metabolism","endure_elements","poison_immunity","chitin_armor","quick","mutation","athletic",
	"agile","healthy","strong_mind","tough","aura","aggressive","evasive","fire_resistant","cold_resistant",
	"poison_resistant","natural_armor","endurance","weapon_specialization","pack_mule","meditation",
	"two_handed_mastery","light_armor_proficiency","heavy_armor_proficiency","armor_expert","shield_expert",
	"staff_defence","improved_alchemy","bomb_expert","backstab","assassin","firearm_mastery","dual_wield",
	"improved_dual_wield","piercing_arrows","double_throw","reach","uncanny_speed","fire_mastery","air_mastery",
	"earth_mastery","water_mastery","leadership","nightstalker"
}



function storeChampion(champ)
	champions[champ:getName()] ={
		baseStats = getBaseStats(champ),
		class = champ:getClass(),
		dualClass = champ:getDualClass(),
		energy = champ:getEnergy(),
		evasion = champ:getEvasion(),
		experience = champ:getExp(),
		food = champ:getFood(),
		health = champ:getHealth(),
		level = champ:getLevel(),
		load = champ:getLoad(),
		maxEnergy = champ:getMaxEnergy(),
		maxHealth = champ:getMaxHealth(),
		maxLoad = champ:getMaxLoad(),
		name = champ:getName(),
		protection = champ:getProtection(),
		race = champ:getRace(),
		sex = champ:getSex(),
		skillLevels = getSkillLevels(champ),
		traits = getTraits(champ),
		skillPoints = champ:getSkillPoints()
	}
end

function defineChampion(def)
	champions[def.name] = def
end

function loadChampion(name,replaceChamp)
	local data = champions[name]
	replaceChamp:setEnabled(true)
	replaceChamp:setName(data.name) 
	setBaseStats(replaceChamp,data.baseStats) 	
	replaceChamp:setRace(data.race) 	
	replaceChamp:setSex(data.sex) 	
	replaceChamp:setClass(data.class) 	
	--replaceChamp:setCondition(name) 	
	--replaceChamp:setConditionValue(name, value) 	
	replaceChamp:setEnergy(data.energy) 	
	replaceChamp:setFood(data.food) 	
	replaceChamp:setHealth(data.health) 	
	
	if data.portrait then
		replaceChamp:setPortrait(data.portrait)
	end 	
	local toTargetXp = data.experience - replaceChamp:getExp()
	replaceChamp:gainExp(toTargetXp)

	setSkillLevels(replaceChamp,data.skillLevels)
	replaceChamp:setSkillPoints(data.skillPoints)
	setTraits(replaceChamp,data.traits)	
	hudPrint('') hudPrint('') hudPrint('') hudPrint('') 
	hudPrint(name..' joined to your party.')
end


function getSkillLevels(champ)
	local result = {}
	for _,skill in ipairs(skills) do
		result[skill] = champ:getSkillLevel(skill)
	end
	return result
end

function setSkillLevels(champ,champSkills)
	for _,skill in ipairs(skills) do
		local value = champSkills[skill] or 0
		local currentLevel = champ:getSkillLevel(skill)
		local trainToTarget = value - currentLevel
		champ:trainSkill(skill,trainToTarget)
	end
end

function getBaseStats(champ)
	local result = {}
	for _,stat in ipairs(stats) do
		result[stat] = champ:getBaseStat(stat)
	end
	return result
end


function setBaseStats(champ,stats)
	for stat,value in pairs(stats) do
		champ:setBaseStat(stat,value)
	end
end

function getTraits(champ)
	local result = {}
	for _,trait in ipairs(traits) do
		result[trait] = champ:hasTrait(trait)
	end
	return result
end
function setTraits(champ,champTraits)
	for _,trait in ipairs(traits) do
		if champTraits[trait] then
			champ:addTrait(trait)
		else
			champ:removeTrait(trait)
		end
	end
end

function getChampionByName(name)
	for i=1,4 do
		if party.party:getChampion(i):getName() == name then
			return party.party:getChampion(i)
		end
	end
	return false
end

function getDisabledChampion()
	for i=1,4 do
		if not party.party:getChampion(i):getEnabled() then
			return party.party:getChampion(i)
		end
	end
	return false
end

-- GUI RELATED STUFF
guiEnabled = false
function showGui(bool)
	guiState = 1
	selectedChampion = nil
	guiEnabled = bool
end
function guiOption(g,text,x,y,w)
	_,h = g.drawParagraph(text,x+7,y+19,w)
	if guiMouseInRec(g,x,y,w,h+4) then
		g.color(60,60,60,100)
		g.drawParagraph(text,x+7,y+19,w)
	end
	g.color(255,255,255,255)
	return _,h
end

function guiText(g,text,x,y,w)
	local rw,h = g.drawParagraph(text,x+5,y+17,w)
	return rw,h+8,y-2+h+8
end

function guiMouseInRec(g, bx, by, bw, bh)
	return (g.mouseX >= bx) and (g.mouseX <= bx + bw) 
		and (g.mouseY >= by) and (g.mouseY <= by + bh)
end

dragStartedAt = nil
function guiDragBar(g)
	if g.mouseDown(0) then
		if dragStartedAt == nil and guiMouseInRec(g,guiX-25,guiY-25,500,40) then
			dragStartedAt = {g.mouseX-guiX,g.mouseY-guiY}
		end
		if dragStartedAt then
			guiX = g.mouseX - dragStartedAt[1]
			guiY = g.mouseY - dragStartedAt[2]
			if guiX < 25 then guiX = 25 end
			if guiX > g.width - 500 then guiX = g.width - 500 end
			if guiY < 25 then guiY = 25 end
			if guiY > g.height - 400 then guiY = g.height - 400 end
		end
	else
		dragStartedAt = nil
	end
end

guiX = 100
guiY = 200
guiW = 150
guiState = 1
selectedChampion = nil
function gui(g)
	if guiEnabled == false then return end
	guiDragBar(g)
	-- spacing,x,y,height,dummy
	local s,x,y,h,_ = 5,guiX,guiY,0,0
	g.drawImage('mod_assets/jkos/Dialog.tga',guiX-25,guiY-25)
	g.drawImage('mod_assets/jkos/PortraitSlot.tga',guiX, guiY+30)	
	g.font('large')
	_,h = guiText(g,'Recruit champion',x,y,200)
	g.font('small')
	_,h = guiOption(g,'Close',x+400,y,60)
	if g.button('recruit', x+400,y, 60, h+s) then
		guiEnabled = false
	end
	if guiState == 2 then
		guiChampionSelected(g)
		return
	end
	guiDrawInfo(g,'Click a name to recruit')
	y = y+180
	local removeChamp = false
	for name,champ in pairs(champions) do
		_,h = guiOption(g,name,x,y,guiW)
		if guiMouseInRec(g,x,y,guiW,h+4) then
			guiShowChampion(g,champ,x,y)
		end
		if g.button(name, x, y, guiW, h+s) then
			--storeChampion(party.party:getChampion(1))
			local freeSlot = getDisabledChampion()
			if freeSlot then
				loadChampion(name,freeSlot)
				removeChamp = name
				guiEnabled = false
			else
				guiState = 2
				selectedChampion = name
			end
			
		end
		y = y+h+s
	end
	-- can't remove inside of the loop
	if removeChamp then
		champions[removeChamp] = nil
	end
end

function formatText(text)
	text = string.gsub(text,'_',' ')
	return string.gsub(" "..text, "%W%l", string.upper):sub(2)
end

function guiShowChampion(g,champ)
	local y = guiY + 30
	local width = 250
	g.drawImage(champ.portrait, guiX+8, guiY+30+9)
	_,h,y = guiText(g,
		formatText(champ.race)..' '
		..formatText(champ.sex)..' '
		..formatText(champ.class)..' '
		..'Level '..champ.level
		,guiX+guiW,y,width)
	_,h,y = guiText(g,'Exp: '..champ.experience,guiX+guiW,y,width)	
	_,h,y = guiText(g,'Strength: '..champ.baseStats.strength,guiX+guiW,y,width)
	_,h,y = guiText(g,'Dexterity: '..champ.baseStats.dexterity,guiX+guiW,y,width)
	_,h,y = guiText(g,'Vitality: '..champ.baseStats.vitality,guiX+guiW,y,width)
	for skill,level in pairs(champ.skillLevels) do
		_,h,y = guiText(g, formatText(skill)..': '..level,guiX+guiW,y,width)
	end

end

function guiDrawInfo(g,info)
	_,h = guiText(g,'('..info..')',guiX+160, guiY+330,190)
end

function guiChampionSelected(g)
	guiShowChampion(g,champions[selectedChampion])
	local s,x,y,h = 5,guiX, guiY+180,0
	for i=1,4 do
		local name = party.party:getChampion(i):getName()
		_,h = guiOption(g,name,x, y,150)
		if g.button('recruit', x, y, 150, h+s) then
			loadChampion(selectedChampion,party.party:getChampion(i))
			champions[selectedChampion] = nil
			guiEnabled = false
		end
		y = y + h + s
	end	
	guiDrawInfo(g,'Who will have to go?')
	_,h = guiOption(g,'Cancel',x+150+200, guiY+330,100)
	if g.button('recruit', x+150+200, guiY+330, 100, h+s) then
		guiState = 1
	end
end



