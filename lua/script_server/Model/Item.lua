local class = require "script_server.lbr.Class"
local Item = class()
Item:create("Item",function ()
    -- properties
	local o = {}
	local id
	local name
	local icon


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

    function o:getIcon()
        return icon
    end
    function o:setIcon(_icon)
        icon = _icon
    end
	return o    
end)

return Item