local class = require "script_server.lbr.Class"
local FleaMarket = class()
FleaMarket:create("FleaMarket",function ()
    -- properties
	local o = {}
	local idItem
	local idNPC
	local price


    -- method

    function o:getIdItem()
        return idItem
    end
    function o:setIdItem(_idItem)
        idItem = _idItem
    end

    function o:getIdNPC()
        return idNPC
    end
    function o:setIdNPC(_idNPC)
        idNPC = _idNPC
    end

    function o:getPrice()
        return price
    end
    function o:setPrice(_price)
        price = _price
    end
	return o    
end)

return FleaMarket