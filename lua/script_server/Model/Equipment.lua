local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Equipment = class()
Equipment:create("Equipment",function ()
    -- properties
	local o = Item:extend()
	local level
	local percentage
	local rarity
	local recipe


    -- method

    function o:getLevel()
        return level
    end
    function o:setLevel(_level)
        level = _level
    end

    function o:getPercentage()
        return percentage
    end
    function o:setPercentage(_percentage)
        percentage = _percentage
    end

    function o:getRarity()
        return rarity
    end
    function o:setRarity(_rarity)
        rarity = _rarity
    end

    function o:getRecipe()
        return recipe
    end
    function o:setRecipe(_recipe)
        recipe = _recipe
    end
	return o    
end)

return Equipment