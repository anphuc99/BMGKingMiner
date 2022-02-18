local Mines = require "script_common.database.Mines"
local messager = require "script_server.Helper.SendMesseger"
local loopy = "map001"

Trigger.RegisterHandler(World.cfg, "GAME_START", function(context)
    for key, value in pairs(Mines) do
        if type(key) == "number" then
            local map = World.CurWorld:getOrCreateStaticMap(loopy)            
            local this = map:addRegion(Lib.v3(0, 0, 0), Lib.v3(0, 0, 0), "myplugin/"..value.In)
            -- dịch chuyển đến hang
            Trigger.RegisterHandler(this.cfg, "REGION_ENTER", function(context)
                local proPlayer = context.obj1:getValue("Player")
                if proPlayer.idCard >= value.Id_card then
                    local dynamicMap = World.CurWorld:getOrCreateStaticMap(value.map, true) 
                    context.obj1:setMapPos(dynamicMap, Lib.v3(value.InPosition.x, value.InPosition.y, value.InPosition.z))
                else
                    messager(context.obj1,{Text = {"messeger_NotEnoughIdCard"}})
                end
                
            end)
            -- dịch chuyển về nhà
            local map2 = World.CurWorld:getOrCreateStaticMap(value.map)  
            local this2 = map2:addRegion(Lib.v3(0, 0, 0), Lib.v3(0, 0, 0), "myplugin/"..value.Out)
            Trigger.RegisterHandler(this2.cfg, "REGION_ENTER", function(context)
                local dynamicMap = World.CurWorld:getOrCreateStaticMap(loopy, true) 
                context.obj1:setMapPos(dynamicMap, Lib.v3(value.OutPosition.x, value.OutPosition.y, value.OutPosition.z))
            end)
        end
    end
end)