local Context = require "script_common.lbr.Context"
local messager = require "script_server.Helper.SendMesseger"
PackageHandlers.registerServerHandler("takingMission", function(player, packet)
    local mission = player:getValue("mission")
    mission.takMs = true
    player:setValue("mission", mission)    
    Trigger.CheckTriggers(player:cfg(), "PLAYER_CHECK_MISSION", {obj1 = player})
end)

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PLAYER_CHECK_MISSION", function(context)
    local player = context.obj1
    local player_mission = player:getValue("mission")
    local context_mission = Context:new("Mission")
    local getMission = context_mission:where("id",player_mission.msid):firstData()
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    local itemMission = {}
    for key, value in pairs(getMission.item) do
        itemMission[#itemMission+1] = {
            item = key,
            count = value,
            num = context_playerItem:where("idItem",key):sum("num")
        }
    end
    PackageHandlers.sendServerHandler(context.obj1, "setMission", itemMission)  
end)

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PLAYER_ADD_ITEM_IN_BALO", function(context)
    Trigger.CheckTriggers(context.obj1:cfg(), "PLAYER_CHECK_MISSION", {obj1 = context.obj1})
end)