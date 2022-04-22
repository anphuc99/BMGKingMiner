local Context = require "script_common.lbr.Context"
local messager = require "script_server.Helper.SendMesseger"
local itemTuotrial = {
    {
        item = "myplugin/M_Tree1",
        num = 5,
        money = 100       
    },
    {
        item = "myplugin/M_Iron",
        num = 10,
        money = 200 
    },
    {
        item = "myplugin/Sh_giay_1_1",
        num = 1,
        money = 300         
    },
    {
        item = "myplugin/V_Vortex",
        num = 5,
        money = 500         
    },
    {
        item = "myplugin/P_cup_2",
        num = 1,
        money = 1000         
    }
}

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PLAYER_ADD_ITEM_IN_BALO", function(context)    
    if itemTuotrial[context.model:getTutorial()] ~= nil then
        if itemTuotrial[context.model:getTutorial()].item == context.itemid then               
          Trigger.CheckTriggers(context.obj1:cfg(), "PALYER_CHECK_TUTORIAL_MISSION", {obj1 = context.obj1, model = context.model})
        end        
    end
end)

Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "PALYER_CHECK_TUTORIAL_MISSION", function(context)
    if not itemTuotrial[context.model:getTutorial()] then
        return
    end
    local objPlayer = context.model
    local playerItem = objPlayer:getPlayerItem()
    local contex_playerItem = Context:new(playerItem)
    local count = contex_playerItem:where("idItem",itemTuotrial[context.model:getTutorial()].item):sum("num")
    if count >= itemTuotrial[context.model:getTutorial()].num then
        context.model:increaseMoney(itemTuotrial[context.model:getTutorial()].money)            
        context.model:setTutorial(context.model:getTutorial() + 1)
        PackageHandlers.sendServerHandler(context.obj1, "setMission", {})
        context.model:setTakingMissionTutorial(false)
        World.Timer(4, function ()
            messager(context.obj1,{Text = {"messeger_completeMission"}, Color = {r=0,b=0,g=0}})
            local proPlayer = objPlayer:toTable()
            proPlayer.UI = "Tutorial"
            PackageHandlers.sendServerHandler(context.obj1, "UI", proPlayer)
            return false
        end)        
    else
        PackageHandlers.sendServerHandler(context.obj1, "setMission", {{item = itemTuotrial[context.model:getTutorial()].item, num = count, count = itemTuotrial[context.model:getTutorial()].num}})
    end
end)