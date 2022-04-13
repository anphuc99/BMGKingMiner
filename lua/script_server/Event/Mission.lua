local Context = require "script_common.lbr.Context"
local messager = require "script_server.Helper.SendMesseger"
local Gol = require "script_server.Golde_Valiable"
PackageHandlers.registerServerHandler("takingMission", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local mission = objPlayer:getMission()
    mission.takMs = true
    objPlayer:setMission(mission)
    objPlayer:save(false)  
    Trigger.CheckTriggers(player:cfg(), "PLAYER_CHECK_MISSION", {obj1 = player})
end)

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PLAYER_CHECK_MISSION", function(context)
    local player = context.obj1    
    local objPlayer = Gol.Player[player.platformUserId]
    local player_mission = objPlayer:getMission()
    local context_mission = Context:new("Mission")
    local getMission = context_mission:where("id",player_mission.msid):firstData()
    if getMission then
        local playerItem = objPlayer:getPlayerItem()
        local context_playerItem = Context:new(playerItem)
        local itemMission = {}
        local isFinish = true
        for key, value in pairs(getMission.item) do
            local mission = {
                item = key,
                count = value,
                num = context_playerItem:where("idItem",key):sum("num")
            }
            itemMission[#itemMission+1] = mission
            if mission.num < mission.count then
                isFinish = false
            end
        end
        PackageHandlers.sendServerHandler(context.obj1, "setMission", itemMission)  
        if isFinish then
            PackageHandlers.sendServerHandler(player, "MissionComplate", nil)
        end        
    end
end)

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PLAYER_ADD_ITEM_IN_BALO", function(context)
    Trigger.CheckTriggers(context.obj1:cfg(), "PLAYER_CHECK_MISSION", {obj1 = context.obj1})
end)

Trigger.addHandler(Entity.GetCfg("myplugin/Enti_NPC_Mission"), "ENTITY_ENTER", function(context)    
    Lib.objMission = context.obj1.objID
    PackageHandlers.sendServerHandlerToAll("Entity_mission", {objid = context.obj1.objID})
end)