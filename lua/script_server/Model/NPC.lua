local class = require "script_common.lbr.Class"
local NPC = class()
NPC:create("NPC",function ()
    local o = {}
    -- properties
	local id
	local name

    function o:__constructor(data)
        -- constructor
		id = data.id
		name = data.name
        
    end
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

    return o
end)

return NPC