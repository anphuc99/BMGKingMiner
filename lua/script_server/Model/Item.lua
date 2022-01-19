local class = require "script_server.lbr.Class"
local Item = class()
Item:create("Item",function ()
    local o = {}
    -- properties
	local id
	local name
	local icon
	local typeItem

    function o:__constructor(data)
        -- constructor       
		id = data.id
		name = data.name
		icon = data.icon
		typeItem = data.typeItem
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

    function o:getIcon()
        return icon
    end
    function o:setIcon(_icon)
        icon = _icon
    end

    function o:getTypeItem()
        return typeItem
    end
    function o:setTypeItem(_typeItem)
        typeItem = _typeItem
    end

    return o
end)

return Item