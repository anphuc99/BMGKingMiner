local Gol = require "script_server.Golde_Valiable"
local this = Entity.GetCfg("myplugin/player1")
local PlayerModel = require "script_server.Model.Player"
Trigger.RegisterHandler(this, "ENTITY_ENTER", function(context)
    print("awoeruiwoieroiweuroi")
    local PlayerObj = PlayerModel:new(context.obj1.objID)
    Gol.Player[context.obj1.objID] = PlayerObj
end)