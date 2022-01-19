local class = require "script_server.lbr.Class"
local NPC = class()
NPC:create("NPC",function ()
    -- properties
	local o = {}
	local id
	local name


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