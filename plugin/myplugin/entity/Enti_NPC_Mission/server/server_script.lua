local cancelFunc = Trigger.addHandler(this:cfg(), "ENTITY_CLICK", function(context)
    local player = context.obj2
    local Context = require "script_common.lbr.Context"
    local messager = require "script_server.Helper.SendMesseger"
    local compareDate = require "script_common.lbr.compareDate"
    local Gol = require "script_server.Golde_Valiable"
    local mission = player:getValue("mission")
    local valuePlayer = player:getValue("Player")
    if mission.msid then
        local finish = true
        local context_mission = Context:new("Mission")
        local getMission = context_mission:where("id",mission.msid):firstData()
        local itemPlayer = player:getValue("PlayerItem")
        local context_playerItem = Context:new(itemPlayer)
        for key, value in pairs(getMission.item) do
            local count = context_playerItem:where("idItem",key):sum("num")
            print(count,value, count < value)
            if count < value then
                finish = false
            end
        end
        if finish then
            local objPlayer = Gol.Player[player.objID]
            for key, value in pairs(getMission.item) do
                objPlayer:removeItemInBalo(key,value)
            end
            objPlayer:increaseMoney(getMission.money)
            mission.lastCompleteMs = os.time()
            Trigger.CheckTriggers(player:cfg(), "PLAYER_FINISH_MISSiON", {id = mission.msid, receivingTime = mission.curReceived, completionTime = mission.lastCompleteMs, obj1 = player})
            mission.msid = nil
            mission.takMs = false
            player:setValue("mission", mission)
            World.Timer(4, function ()
                PackageHandlers.sendServerHandler(context.obj2, "setMission", {})
                messager(player,{Text = {"messeger_completeMission"}, Color = {r=0,b=0,g=0}})
            end)
        else
            PackageHandlers.sendServerHandler(player, "UI", {UI = "Tutorial", tutorial = mission.msid}) 
        end        
    else        
        if valuePlayer.tutorial >= 6 then             
            if mission.lastCompleteMs == nil or compareDate(mission.lastCompleteMs,os.time()) >= 1 then
                local context_mission = Context:new("Mission")
                local getAllMission = context_mission:where("id_card",valuePlayer.idCard):getData()
                mission.msid =  getAllMission[math.random(1,#getAllMission)].id
                mission.curReceived = os.time()
                player:setValue("mission",mission)
                PackageHandlers.sendServerHandler(player, "UI", {UI = "Tutorial", tutorial = mission.msid}) 
            end
        end
    end
end)