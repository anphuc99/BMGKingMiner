local class = require "script_common.lbr.Class"
local Item = require "script_server.Model.Item"
local Equipment = class()
Equipment:create("Equipment",function ()
    local o,super = Item:extend()
    -- properties
	local level
	local percentage
	local rarity
	local recipe
	local typeEquiment

    function o:__constructor(data)
        -- constructor
        o:setId(data.id)
		o:setName(data.name)
		o:setIcon(data.icon)
		o:setTypeItem(data.typeItem)       
		level = data.level
		percentage = data.percentage
		rarity = data.rarity
		recipe = data.recipe
		typeEquiment = data.typeEquiment
        
    end
    -- method

    function o:getId()
        return id
    end
    function o:setId(_id)
        id = _id
    end

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

    function o:getTypeEquiment()
        return typeEquiment
    end
    function o:setTypeEquiment(_typeEquiment)
        typeEquiment = _typeEquiment
    end

    return o
end)

return Equipment