local Material = require "script_common.database.Material"
local Context = require "script_common.lbr.Context"
local Gol = require "script_server.Golde_Valiable"
local MaterialModel = require "script_server.Model.Material"

for key, value in pairs(Material) do
    if key ~= "option" then
        -- local block= Block.GetNameCfg(value.blockId)
        -- Trigger.RegisterHandler(block, "BLOCK_BREAK", function(context)
        --     Gol.Player[context.obj1.objID]:beginMine(value,context.pos)
        -- end)        
        local cfg = Entity.GetCfg(value.entityId)
        Trigger.RegisterHandler(cfg, "ENTITY_ENTER", function(context)
            Gol.Material[context.obj1.objID] = MaterialModel:new(value,context.obj1.objID)
        end)
        Trigger.RegisterHandler(cfg, "ENTITY_DIE", function(context)
            Gol.Material[context.obj1.objID] = nil
        end)
        Trigger.RegisterHandler(cfg, "ENTITY_REBIRTH", function(context)
            Gol.Material[context.obj1.objID] = MaterialModel:new(value,context.obj1.objID)
        end)
        Trigger.RegisterHandler(cfg, "ENTITY_CLICK", function(context)
            print(context.obj2.objID)
            print(Lib.pv(Gol.Player))
            Gol.Player[context.obj2.objID]:beginMine(Gol.Material[context.obj1.objID])
        end)
    end
end