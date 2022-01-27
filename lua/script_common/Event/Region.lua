local Mines = require "script_common.database.Mines"

-- Trigger.RegisterHandler(World.cfg, "GAME_START", function(context)
--     for key, value in pairs(Mines) do
--         if type(key) == "number" then
--             local map = World.CurWorld:createDynamicMap(value.curMap)
--             local this = map:getRegion(value.gate)
--             print("eeeeeeeeeeeeeeeeeee")            
--             print(Lib.pv(this))
--             Trigger.RegisterHandler(this.cfg, "REGION_ENTER", function(context)
--                 local dynamicMap = World.CurWorld:createDynamicMap(value.map, true) 
--                 context.obj1:setMapPos(dynamicMap, Lib.pv(value.x, value.y, value.z))
--             end)
--         end
--     end
-- end)
