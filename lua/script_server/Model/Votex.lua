local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Votex = class()
Votex:create("Votex",function ()
    local o = Item:extend()
    -- properties
	local percentage

    function o:__constructor(data)
        -- constructor
		o:setId(data.id)
		o:setName(data.name)
		o:setIcon(data.icon)
		o:setTypeItem(data.typeItem)
		percentage = data.percentage
        
    end
    -- method

    function o:getId()
        return id
    end
    function o:setId(_id)
        id = _id
    end

    function o:getPercentage()
        return percentage
    end
    function o:setPercentage(_percentage)
        percentage = _percentage
    end

    return o
end)

return Votex