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

return Maket