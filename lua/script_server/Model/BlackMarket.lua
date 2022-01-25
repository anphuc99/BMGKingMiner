local class = require "script_common.lbr.Class"
local BlackMarket = class()
BlackMarket:create("BlackMarket",function ()
    local o = {}
    -- properties
	local idItem
	local price
	local quantily
	local idPlayer

    function o:__constructor(data)
        -- constructor
		idItem = data.idItem
		price = data.price
		quantily = data.quantily
		idPlayer = data.idPlayer
        
    end
    -- method

    function o:getIdItem()
        return idItem
    end
    function o:setIdItem(_idItem)
        idItem = _idItem
    end

    function o:getPrice()
        return price
    end
    function o:setPrice(_price)
        price = _price
    end

    function o:getQuantily()
        return quantily
    end
    function o:setQuantily(_quantily)
        quantily = _quantily
    end

    function o:getIdPlayer()
        return idPlayer
    end
    function o:setIdPlayer(_idPlayer)
        idPlayer = _idPlayer
    end

    return o
end)

return BlackMarket