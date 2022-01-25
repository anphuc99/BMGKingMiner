local class = require "script_common.lbr.Class"
local Equiment = require "script_server.Model.Equipment"
local Trophy = class()
Trophy:create("Trophy",function ()
    local o = Equiment:extend()
    -- properties
	local mineSpeed

    function o:__constructor(data)
        -- constructor
        data = data or {}
		o:setId(data.id)
		o:setName(data.name)
		o:setIcon(data.icon)
		o:setTypeItem(data.typeItem)
        o:setLevel(data.level)
		o:setPercentage(data.percentage)
		o:setRarity(data.rarity)
		o:setRecipe(data.recipe)
		o:setTypeEquiment(data.typeEquiment)
		mineSpeed = data.mineSpeed
        
    end
    -- method

    function o:getId()
        return id
    end
    function o:setId(_id)
        id = _id
    end

    function o:getMineSpeed()
        return mineSpeed
    end
    function o:setMineSpeed(_mineSpeed)
        mineSpeed = _mineSpeed
    end

    return o
end)

return Trophy