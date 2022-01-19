local class = require "script_server.lbr.Class"
local Mission = class()
Mission:create("Mission",function ()
    -- properties
	local o = {}
	local id
	local name
	local level
	local bonus
	local MaterialNeeded


    -- method

    function o:getId()
        return id
    end
    function o:setId(_id)
        id = _id
    end

    function o:getName()
        return name
    end
    function o:setName(_name)
        name = _name
    end

    function o:getLevel()
        return level
    end
    function o:setLevel(_level)
        level = _level
    end

    function o:getBonus()
        return bonus
    end
    function o:setBonus(_bonus)
        bonus = _bonus
    end

    function o:getMaterialNeeded()
        return MaterialNeeded
    end
    function o:setMaterialNeeded(_MaterialNeeded)
        MaterialNeeded = _MaterialNeeded
    end
	return o    
end)

return Mission