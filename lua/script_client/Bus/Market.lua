local Context = require "script_common.lbr.Context"
local Maket = {}

function Maket:getFleaMaket(NPC)
    local context_flea = Context:new("FleaMarket")
    local fleaMarket = context_flea:where("idNPC",NPC):getData()
    local data = {}
    for key, value in pairs(fleaMarket) do
        if type(key) == "number" then
            
        end
    end
end