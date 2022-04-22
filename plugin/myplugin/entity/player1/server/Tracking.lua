local gameReport = {}
local Context = require "script_common.lbr.Context"
local cjson = require "cjson"
local DBHandler = require "dbhandler"
local Gol = require "script_server.Golde_Valiable"
function gameReport:reportGameData (id,data,player)
    DBHandler:getDataByUserId(player.platformUserId, id, function (userId,jdata)
        if jdata == nil or jdata == "" then
            jdata = "[]"
        end
        local datas = cjson.decode(jdata)
        datas[#datas+1] = data
        DBHandler:setData(player.platformUserId, id,cjson.encode(datas), false)
    end)    
end
Trigger.addHandler(this:cfg(), "PLAYER_END_MINE", function(context)
    local name = Context:new("Item"):where("id",context.item):firstData().name
    local mine = {
        id = context.item,
        realTime = os.time(),
    }
    gameReport:reportGameData("mine",mine , context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_CRAFTING", function(context)
    local crafting = {
        id = context.item,
        realTime = os.time(),
    }
    gameReport:reportGameData("crafting",crafting , context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_BUY_ITEM", function(context)
    local sell_item = {
        id = context.item,
        realTime = os.time(),
        where = context.where,
    }
    gameReport:reportGameData("buy_item",sell_item , context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_SELL_ITEM", function(context)
    local buy_item = {
        id = context.item,
        realTime = os.time(),
        where = context.where,
    }
    gameReport:reportGameData("sell_item",buy_item , context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_UPGRATE", function(context)    
    local playerItem = Gol.Player[context.obj1.platformUserId]:getPlayerItem()
    local vortex = Context:new(playerItem):where("idItem","myplugin/V_Vortex"):sum("num")
    local upgrate = {
        item = context.item,
        olditem = context.olditem,
        realTime = os.time(),
        totalVortex = vortex
    }
    gameReport:reportGameData("upgrate",upgrate, context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_UPGRATE_BALO", function(context)
    local balo = {
        cell = context.cell,
        realTime = os.time(),        
    }
    gameReport:reportGameData("upgrateBalo",balo, context.obj1)
end)


Trigger.addHandler(this:cfg(), "PLAYER_SET_MONEY", function(context)
    local money = {
        money = context.money,
        realTime = os.time(),
    }
    gameReport:reportGameData("money",money, context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_UPDATE_IDCARD", function(context)
    local idcard = {
        idcard = context.idcard,
        realTime = os.time(),
    }
    gameReport:reportGameData("idcard",idcard, context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_FINISH_MISSiON", function(context)
    local mission = {
        id = context.msid,
        receivingTime = context.receivingTime,
        completionTime = context.completionTime
    }
    gameReport:reportGameData("mission",mission, context.obj1)
end)

Trigger.addHandler(this:cfg(), "PLAYER_REMOVE_BLACKMARKET", function(context)
    local removeBlackMarket = {
        id = context.item,
        realTime = os.time(),
    }
    gameReport:reportGameData("removeBlackMarket",removeBlackMarket, context.obj1)
end)

Trigger.addHandler(this:cfg(), "ENTITY_ENTER", function(context)
    local player = {
        id = context.obj1.platformUserId,
        time = os.time()
    }
    gameReport:reportGameData("playerEnter",player, context.obj1)
end)

Trigger.addHandler(this:cfg(), "ENTITY_LEAVE", function(context)
    local player = {
        id = context.obj1.platformUserId,
        time = os.time()
    }
    gameReport:reportGameData("playerLeave",player, context.obj1)
end)

-- gửi tracking lên server
local block= Block.GetNameCfg("myplugin/5facbff6-fd52-4a84-88b0-aff6a152581f")
Trigger.addHandler(block, "BLOCK_CLICK", function(context)
    print("lalalala")
    DBHandler:getDataByUserId(Gol.subKey.AllPlayer, Gol.dataKey.AllPlayer, function (userId, jdata)
        local data = load("return {"..jdata.."}")()
        local tracking = {
            mine = {},
            crafting = {},
            sell_item = {},
            buy_item = {},
            upgrate = {},
            upgrateBalo = {},
            money = {},
            idcard = {},
            mission = {},
            removeBlackMarket = {},
            Player = {},
            PlayerItem = {},
            playerEnter = {},
            playerLeave = {}
        }
        local key = {"Player","PlayerItem","mine","crafting","sell_item","buy_item","upgrate","upgrateBalo","money","idcard","mission","removeBlackMarket","playerEnter","playerLeave"}
        for index, value in ipairs(data) do
            local function getData(key2,i)
                DBHandler:getDataByUserId(value, key2, function (userId,jdata2)
                    if jdata2 == nil or jdata2 =="" then
                        jdata2 = "{}"
                    end
                    local data2 = cjson.decode(jdata2)
                    tracking[key2][#tracking[key2]+1] = data2
                    if i ~= #key then
                        getData(key[i+1],i+1)    
                    else
                        if index == #data then
                            print("lalalaal")
                            AsyncProcess.HttpRequest("POST", "http://testlua.devmini.com/test.php", nil, function (data)
                                print("done")
                            end, tracking)
                        end
                    end
                end)                
            end
            getData(key[1],1)
        end
    end)
end)