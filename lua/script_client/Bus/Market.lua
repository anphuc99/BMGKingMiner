local Context = require "script_common.lbr.Context"
local Maket = {}

function Maket:getFleaMaket(NPC)
    local context_flea = Context:new("FleaMarket")
    local fleaMarket = context_flea:where("idNPC",NPC):getData()
    local context_item = Context:new("Item")
    local data = {}
    for key, value in pairs(fleaMarket) do
        if type(key) == "number" then
            local item = context_item:where("id",value.idItem):firstData()
            item.name = Lang:toText({item.name,1})
            item.price = value.price
            data[#data+1] = item
        end
    end
    return data
end

function Maket:getSaleMarket()
    local context_sale = Context:new("Equipment")
    local data = {}
    local ctData = context_sale:where("rarity",">=",2):getData()
    for key, value in pairs(ctData) do
        if type(key) == "number" then
            data[#data+1] = value
        end
    end
    return data
end

function Maket:getBlackMarket(bMk)    
    local context_item = Context:new("Item")    
    local data = {}
    for key, value in pairs(bMk) do
        local item = context_item:where("id",value.idItem):firstData()
        item.playerId = value.playerId
        item.created_at = value.created_at
        item.key = key
        item.playerName = value.playerName
        item.price = value.price
        item.quantily = value.quantily
        data[#data+1] = item
    end
    return data
end

return Maket