-- local gameReport = Game.GetService("GameReport")
-- local Context = require "script_common.lbr.Context"
-- local cjson = require "cjson"
-- Trigger.addHandler(this:cfg(), "PLAYER_END_MINE", function(context)
--     local name = Context:new("Item"):where("id",context.item):firstData().name
--     local mine = {
--         id = context.item,
--         realTime = os.time(),
--     }
--     gameReport:reportGameData("mine",cjson.encode(mine) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_CRAFTING", function(context)
--     local crafting = {
--         id = context.item,
--         realTime = os.time(),
--     }
--     gameReport:reportGameData("crafting",cjson.encode(crafting) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_SELL_ITEM", function(context)
--     local sell_item = {
--         id = context.item,
--         realTime = os.time(),
--         where = context.where,
--     }
--     gameReport:reportGameData("sell_item",cjson.encode(sell_item) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_BUY_ITEM", function(context)
--     local buy_item = {
--         id = context.item,
--         realTime = os.time(),
--         where = context.where,
--     }
--     gameReport:reportGameData("buy_item",cjson.encode(buy_item) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_UPGRATE", function(context)
--     local playerItem = context.obj1:getValue("PlayerItem")
--     local vortex = Context:new(playerItem):where("idItem","myplugin/V_Vortex"):sum("num")
--     local upgrate = {
--         item = context.item,
--         olditem = context.olditem,
--         realTime = os.time(),
--         totalVortex = vortex
--     }
--     gameReport:reportGameData("upgrate",cjson.encode(upgrate) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_UPGRATE_BALO", function(context)
--     local balo = {
--         cell = context.cell,
--         realTime = os.time(),        
--     }
--     gameReport:reportGameData("upgrateBalo",cjson.encode(balo) , context.obj1)
-- end)


-- Trigger.addHandler(this:cfg(), "PLAYER_SET_MONEY", function(context)
--     local money = {
--         money = context.money,
--         realTime = os.time(),
--     }
--     gameReport:reportGameData("money",cjson.encode(money) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_UPDATE_IDCARD", function(context)
--     local idcard = {
--         idcard = context.idcard,
--         realTime = os.time(),
--     }
--     gameReport:reportGameData("idcard",cjson.encode(idcard) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_FINISH_MISSiON", function(context)
--     local mission = {
--         id = context.msid,
--         receivingTime = context.receivingTime,
--         completionTime = context.completionTime
--     }
--     gameReport:reportGameData("mission",cjson.encode(mission) , context.obj1)
-- end)

-- Trigger.addHandler(this:cfg(), "PLAYER_REMOVE_BLACKMARKET", function(context)
--     local removeBlackMarket = {
--         id = context.item,
--         realTime = os.time(),
--     }
--     gameReport:reportGameData("removeBlackMarket",cjson.encode(removeBlackMarket) , context.obj1)
-- end)