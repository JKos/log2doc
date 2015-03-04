
defineObject{
	name = "champion_recruit",
	baseObject = "script_entity",
	components = {
		{
			class = "Script",
			source = [[
--DON'T MODIFY THESE METHODS(unless you know what you are doing)
championDefs = {}

function defineChampion(def)
	self.championDefs[def.name] = def
end
-- Call this function to show the gui
function enable()
	champions.script.setStore(self.go.id)
	if champions.script.hasChampions() then
		champions.script.showGui(true)
	end
end

-- ADD YOUR CHAMPION DEFINITIONS HERE
-- This is just a template, you can modify it as you like and add more champions
defineChampion{
      name = 'Champion Name',
      race = 'ratling',
      class = 'farmer',
      sex='male',
      portrait='assets/textures/portraits/ratling_male_02.tga',
      experience=6000,
      baseStats = {
         strength=20,
         dexterity=13,
         vitality=18,
         willpower=15
      },
      skillLevels = {
         accuracy=1,
         light_weapons=4
      },
      energy=110,
      food=1000,
      health=100,
      level=4,
      skillPoints=0,
      traits={
         agile=true,
      },
	  description = "Decription of the champion",
	  items={
	     'dagger',
         'potion_healing',
	  },
   }
]]
		}
	}

}