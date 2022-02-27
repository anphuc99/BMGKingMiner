local cheat = {
    ["122122"] = {
        coin = 10000
    },
    ["212212"] = {
        item = {
            ["myplugin/V_Vortex"] = 1000
        }
    },
    ["112211"] = {
        
    }
}


Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "HAND_ITEM_CHANGED", function(context)
    local newItem = context.item
    
end)