local Gol = require "script_server.Golde_Valiable"
local this = Entity.GetCfg("myplugin/player1")
---@class Player
local PlayerModel = require "script_server.Model.Player"
local cupLv1 = "myplugin/P_cup_1"
local riuLv1 = "myplugin/A_riu_1"
local cup = "myplugin/P_cup"
local Context = require "script_common.lbr.Context"
local deepCopy = require "script_common.lbr.DeepCopyTable"
local positionItem = require "script_common.positionItem"
local SlotBalo = require "script_common.SlotBalo"
local messeger = require "script_server.Helper.SendMesseger"
local split = require "script_common.lbr.split"
local Upgrate = require "script_common.database.Upgrate"
local Vortex = require "script_common.database.Vortex"
local compareDate = require "script_common.lbr.compareDate"
-- local lang = require "script_server.lbr.lang"
local cjson = require "cjson"
local DBHandler = require "dbhandler"
local BlackMarket = require "script_server.Model.BlackMarket"

Trigger.RegisterHandler(this, "ENTITY_ENTER", function(context)    
    DBHandler:getDataByUserId(context.obj1.platformUserId, Gol.dataKey.Player, function(userId, jdata)
        local function check()
            local rs, msg = pcall(function ()
                local a = cjson.decode(jdata)
            end)
            return rs
        end
        local PlayerProperty
        if not check() then
            PlayerProperty = {
                id = context.obj1.platformUserId,
                name = context.obj1.name,
                money = 0,
                balo = 6,
                idCard = 1,
                Lv = 1,
                exp = 0,
                Mine = 0,
                tutorial = 1,
                takingMissionTutorial = false,
                lastLogin = os.time(),
                lastRollUp7 = nil,
                lastRollUp28 = nil,
                countRollUp7 = 0,
                countRollUp28 = 0,
                Upgrate = 0,
                Crafting = 0,
                Equipment = {},
                Achievement = {
                    done = {},
                    proceed = {}
                },
                mission = {
                    msid = nil,
                    takMs = false,
                    lastCompleteMs = nil
                }
            }
        else
            PlayerProperty = cjson.decode(jdata)
        end
        PlayerProperty.lastLogin = os.time()
        DBHandler:setData(context.obj1.platformUserId, Gol.dataKey.Player, cjson.encode(PlayerProperty), false)
        DBHandler:getDataByUserId(context.obj1.platformUserId, Gol.dataKey.PlayerItem, function(userid, jdata)
            local playerItem
            if jdata == nil or jdata == "" then
                playerItem = {
                    { idPlayer = context.obj1.platformUserId, idItem = cupLv1, cellNum = 1, num = 1, position = positionItem.hand,
                        lv = 1 },
                    { idPlayer = context.obj1.platformUserId, idItem = riuLv1, cellNum = 2, num = 1, position = positionItem.hand,
                        lv = 1 },
                }
            else
                playerItem = cjson.decode(jdata)
            end
            Gol.Player[context.obj1.platformUserId] = PlayerModel:new(PlayerProperty, playerItem)
            Trigger.CheckTriggers(this, "PLAYER_INIT", context)
        end, function()

        end)
    end, function()
        local PlayerProperty = {
            id = context.obj1.platformUserId,
            name = context.obj1.name,
            money = 0,
            balo = 6,
            idCard = 1,
            Lv = 1,
            exp = 0,
            Mine = 0,
            tutorial = 1,
            takingMissionTutorial = false,
            lastLogin = os.time(),
            lastRollUp7 = nil,
            lastRollUp28 = nil,
            countRollUp7 = 0,
            countRollUp28 = 0,
            Upgrate = 0,
            Crafting = 0,
            Equipment = {},
            Achievement = {
                done = {},
                proceed = {}
            },
            mission = {
                msid = nil,
                takMs = false,
                lastCompleteMs = nil
            }
        }
        local playerItem = {
            { idPlayer = context.obj1.platformUserId, idItem = cupLv1, cellNum = 1, num = 1, position = positionItem.hand,
                lv = 1 },
            { idPlayer = context.obj1.platformUserId, idItem = riuLv1, cellNum = 2, num = 1, position = positionItem.hand,
                lv = 1 },
        }
        Gol.Player[context.obj1.platformUserId] = PlayerModel:new(PlayerProperty, playerItem)
        Trigger.CheckTriggers(this, "PLAYER_INIT", context)
    end)
    local objid = {}
    for key, value in pairs(Gol.Material) do
        objid[#objid + 1] = {
            objid = key,
            type = value:getTypeMar()
        }
    end
    PackageHandlers.sendServerHandler(context.obj1, "setObjMaterial", objid)
end)

-- sau khi th??m d??? li???u v??o model s??? k??ch ho???t
Trigger.RegisterHandler(this, "PLAYER_INIT", function(context)
    ---@class Player
    local PlayerObj = Gol.Player[context.obj1.platformUserId]
    PackageHandlers.sendServerHandler(context.obj1, "setMoney", { money = PlayerObj:getMoney() })
    if PlayerObj:getTakingMissionTutorial() then
        Trigger.CheckTriggers(this, "PALYER_CHECK_TUTORIAL_MISSION", { obj1 = context.obj1, model = PlayerObj })
    end
    PackageHandlers.sendServerHandler(context.obj1, "Player_enter", nil)
    PlayerObj:refreshHand()
    PlayerObj:checkAchievement()
    if PlayerObj:getLastRollUp7() == nil or compareDate(PlayerObj:getLastRollUp7(), os.time()) >= 1 then
        PackageHandlers.sendServerHandler(context.obj1, "RedDotDally", nil)
    end
    if PlayerObj:getLastRollUp28() == nil or compareDate(PlayerObj:getLastRollUp28(), os.time()) >= 1 then
        PackageHandlers.sendServerHandler(context.obj1, "RedDotDally", nil)
    end
    DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function(userId, jdata)
        local data = cjson.decode(jdata)
        for key, value in pairs(data) do
            if value.idPlayer == context.obj1.platformUserId and value.sold then
                local clsBlackMar = BlackMarket:new(value, key)
                clsBlackMar:receiveMoney()
            end
        end
    end)
    local mission = PlayerObj:getMission()
    if mission.lastCompleteMs == nil or
        compareDate(mission.lastCompleteMs, os.time()) >= 1 and PlayerObj:getTutorial() >= 6 then
        PackageHandlers.sendServerHandler(context.obj1, "Entity_mission",
            { objid = Lib.objMission, received = mission.msid ~= nil })
    end
    local RankMineData = Engine.DataService:GetRankDataStore("Mine")
    RankMineData:SetData(tostring(context.obj1.platformUserId), PlayerObj:getMine())
    local RankLvData = Engine.DataService:GetRankDataStore("Lv")
    RankLvData:SetData(tostring(context.obj1.platformUserId), PlayerObj:getLv())
    Trigger.CheckTriggers(context.obj1:cfg(), "PLAYER_CHECK_MISSION", { obj1 = context.obj1 })
    print("reprot")
    local gameReport = Game.GetService("GameReport")
    gameReport:reportGameData("player_init", "player init "..os.time(), context.obj1)
    local data = PlayerObj:toTable()
    local json = cjson.encode(data)
    gameReport:reportGameData("player_data", json, context.obj1)
    print(json)
    -- gi??? l???p ng?????i ch??i
    -- local idPlayer = ""
    -- local name = {
    --     "Nick n??y ??i m?????n",
    --     "Tao l?? m???nh nh???t",
    --     "nickname14kytu",
    --     "Tr??nh ra cho ta",
    --     "L??m bi???ng qu??",
    --     "??ang bu???n",
    --     "Em bu???n l???m",
    --     "Em l?? con g??i",
    --     "B???n Nam d???u t??n",
    --     "B???n n??? d???u t??n",
    --     "Sung A S?????ng",
    --     "??ep trai nh???t x??m",
    --     "H???c d???t nh???t l???p",
    --     "Thi??n Th???n Th?? Th??i",
    --     "Nh???t d????ng ch???",
    --     "H??nh nh?? em c?? ??i???u mu???n n??i",
    --     "Ngu qu?? n??n ???? r???i tr???n",
    --     "N???i c??m ??i???n",
    --     "Pikagon",
    --     "Dragonite",
    --     "Ch??? l?? t???i v??",
    -- }
    -- for i = 1, 1000, 1 do
    --     local PlayerProperty = {
    --         id = i,
    --         name = name[math.random(1, #name)],
    --         money = 0,
    --         balo = 6,
    --         idCard = 1,
    --         Lv = math.random(1, 1000),
    --         exp = 0,
    --         Mine = math.random(1, 500000),
    --         tutorial = 1,
    --         takingMissionTutorial = false,
    --         lastLogin = os.time(),
    --         lastRollUp7 = nil,
    --         lastRollUp28 = nil,
    --         countRollUp7 = 0,
    --         countRollUp28 = 0,
    --         Upgrate = 0,
    --         Crafting = 0,
    --         Equipment = {},
    --         Achievement = {
    --             done = {},
    --             proceed = {}
    --         },
    --         mission = {
    --             msid = nil,
    --             takMs = false,
    --             lastCompleteMs = nil
    --         }
    --     }
    --     DBHandler:setData(i, Gol.dataKey.Player, cjson.encode(PlayerProperty), false)
    --     local RankMineData = Engine.DataService:GetRankDataStore("Mine")
    --     RankMineData:SetData(tostring(i), PlayerProperty.Mine)
    --     local RankLvData = Engine.DataService:GetRankDataStore("Lv")
    --     RankLvData:SetData(tostring(i), PlayerProperty.Lv)

    --     idPlayer = idPlayer .. i .. ","
    --     print(i)
    -- end
    -- DBHandler:setData(Gol.subKey.AllPlayer, Gol.subKey.AllPlayer, "", true)
    -- DBHandler:setData(Gol.subKey.AllPlayer, Gol.dataKey.AllPlayer, idPlayer, true)
end)

Trigger.RegisterHandler(this, "NEW_PLAYER_INIT", function(context)
    local player = context.obj1
    DBHandler:getDataByUserId(Gol.subKey.AllPlayer, Gol.dataKey.AllPlayer, function(userId, jdata)
        jdata = jdata or ""
        jdata = jdata .. player.platformUserId .. ","
        DBHandler:setData(Gol.subKey.AllPlayer, Gol.dataKey.AllPlayer, jdata, true)
    end)
end)


Trigger.RegisterHandler(this, "ENTITY_LEAVE", function(context)
    Gol.Player[context.obj1.platformUserId]:save(true)
    Gol.Player[context.obj1.platformUserId] = nil
end)
-- l???y balo ng?????i ch??i
PackageHandlers.registerServerHandler("getBackPackPlayer", function(player, packet)
    local playerItem = Gol.Player[player.platformUserId]:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    playerItem = context_playerItem:where("position", positionItem.balo):getData()
    local context_item = Context:new("Item")
    local data = {}
    if playerItem ~= nil then
        for key, value in pairs(playerItem) do
            if type(key) == "number" then
                local data11 = context_item:where("id", value.idItem):firstData()
                data11.num = value.num
                data11.cellNum = value.cellNum
                data[#data + 1] = deepCopy(data11)
            end
        end
    end
    return data
end)
-- l???y c??c thu???c t??nh c???a ng?????i ch??i
PackageHandlers.registerServerHandler("getValuePlayer", function(player, packet)
    local plpro = Gol.Player[player.platformUserId]:toTable()
    return plpro
end)
-- th???c hi???n chuy???n v???t ph???m t??? balo xu???ng tay ng?????i ch??i
-- PackageHandlers.registerServerHandler("baloToHand", function(player, packet)
--     local objPlayer = Gol.Player[player.objID]
--     return objPlayer:baloToHand(packet.cellNum)
-- end)
-- th???c hi???n chuy???n v???t ph???m t??? tay l??n balo
-- PackageHandlers.registerServerHandler("handToBalo", function(player, packet)
--     local objPlayer = Gol.Player[player.objID]
--     objPlayer:handToBalo(packet.cellNum)
--     local playerItem = player:getValue("PlayerItem")
--     local context_playerItem = Context:new(playerItem)
--     local context_item = Context:new("Item")
--     local playerItem2 = context_playerItem:where("position",positionItem.balo):where("cellNum",packet.cellNum):firstData()
--     local res = context_item:where("id",playerItem2.idItem):firstData()
--     res.num = playerItem2.num
--     return res
-- end)
-- th???c hi???n ?????i ch??? c???a item
PackageHandlers.registerServerHandler("moveItem", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local rs = objPlayer:moveCellBalo(packet.oldCell, packet.newCell)
    if rs then
        local data = {
            rs = rs,
            oldCell = {},
            newCell = {},
        }
        local playerItem = objPlayer:getPlayerItem()
        local context_playerItem = Context:new(playerItem)
        -- playerItem = context_playerItem:where("position",positionItem.balo):getData()
        local context_item = Context:new("Item")
        local oldCellItem = context_playerItem:where("position", positionItem.balo):where("cellNum", packet.oldCell):
            firstData()
        if (oldCellItem == nil) then
            data.oldCell = nil
        else
            data.oldCell = deepCopy(context_item:where("id", oldCellItem.idItem):firstData())
            data.oldCell.num = oldCellItem.num
        end
        local newCellItem = context_playerItem:where("position", positionItem.balo):where("cellNum", packet.newCell):
            firstData()
        data.newCell = deepCopy(context_item:where("id", newCellItem.idItem):firstData())
        data.newCell.num = newCellItem.num
        return data
    end
    return { rs = false }
end)
-- m??? th??m ?? balo
PackageHandlers.registerServerHandler("OpenCellNum", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local rs = objPlayer:spendMoney(SlotBalo[objPlayer:getBalo() + 1].money)
    if rs then
        objPlayer:setBalo(objPlayer:getBalo() + 1)
        Trigger.CheckTriggers(player:cfg(), "PLAYER_UPGRATE_BALO", { cell = objPlayer:getBalo(), obj1 = player })
    end
    objPlayer:save(false)
    return rs
end)
-- c??i ?????t ng??n ng???
-- PackageHandlers.registerServerHandler("setLanguage", function(player, packet)
--     print("eeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwww")
--     player:setData("lang", packet.lang)
-- end)
-- ch??? t???o trang b???
PackageHandlers.registerServerHandler("crafting", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    if objPlayer:freeBalo() < 1 then
        messeger(player, { Text = { "messeger_FullBP" } })
        return { rs = false }
    end
    local context_recipe = Context:new("recipe")
    local recipe = context_recipe:where("id", packet.recId):firstData()
    local playerItem = objPlayer:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    local rs = true
    for key, value in pairs(recipe.Material) do
        local plNumItem = context_playerItem:where("idItem", value.id):sum("num")
        if value.num > plNumItem then
            rs = false
            break
        end
    end
    if rs then
        local context_equipment = Context:new("Equipment")
        local equipment = context_equipment:where("recipe", packet.recId):getData()
        local rd = math.random(1, 100)
        local winPrizes
        for key, value in pairs(equipment) do
            if type(key) == "number" then
                if rd < value.percentage then
                    winPrizes = value.id
                    break
                else
                    rd = rd - value.percentage
                end
            end
        end
        objPlayer:addItemInBalo(winPrizes, 1)
        Trigger.CheckTriggers(player:cfg(), "PLAYER_CRAFTING", { item = winPrizes, obj1 = player })
        for key, value in pairs(recipe.Material) do
            objPlayer:removeItemInBalo(value.id, value.num)
        end
        objPlayer:save(false)
        return { rs = true, item = winPrizes }
    else
        return { rs = false }
    end
end)
-- b??n h??ng ch??? tr???i
PackageHandlers.registerServerHandler("sellFleaMarket", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    if objPlayer:countItem(packet.id) >= packet.num then
        local context_flea = Context:new("FleaMarket")
        local flea = context_flea:where("idItem", packet.id):where("idNPC", packet.NPC):firstData()
        objPlayer:increaseMoney(flea.price * packet.num)
        objPlayer:removeItemInBalo(flea.idItem, packet.num)
        Trigger.CheckTriggers(player:cfg(), "PLAYER_BUY_ITEM", { obj1 = player, where = 1, item = flea.idItem })
        objPlayer:save(false)
    else
        messeger(player, { Text = { "messeger_NotEnoughItem", packet.name }, Color = { r = 255, g = 0, b = 0 } })
    end
end)
-- N??ng c???p trang b???
PackageHandlers.registerServerHandler("Upgrate", function(player, packet)
    local objPlsyer = Gol.Player[player.platformUserId]
    local playerItem = objPlsyer:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    local sumVor = context_playerItem:where("idItem", Vortex[1].id):sum("num")
    local context_equipment = Context:new("Equipment")
    local itemUpgrate = context_playerItem:where("idItem", "find", packet.cup):firstData()
    local oldItem = itemUpgrate.idItem
    local equipment = context_equipment:where("id", itemUpgrate.idItem):firstData()
    local money = Upgrate[equipment.level].money
    if objPlsyer:getMoney() < money then
        messeger(player, { Text = { "messeger_NotEnoughMoney", 1 }, Color = { r = 255, g = 0, b = 0 } })
        return false
    end
    if sumVor < 5 then
        local name = Context:new("Item"):where("id", Vortex[1].id):firstData().name
        messeger(player, { Text = { "messeger_NotEnoughItem", name }, Color = { r = 255, g = 0, b = 0 } })
        return false
    end

    if Upgrate[equipment.level] then
        local rd = math.random(1, 100)
        if rd < Upgrate[equipment.level].percentage then
            local lv = split(itemUpgrate.idItem, "_")
            lv[3] = math.ceil(lv[3] + 1)
            itemUpgrate.idItem = table.concat(lv, "_")
            messeger(player, { Text = { "messager_upgrate", lv[3] }, Color = { r = 0, b = 0, g = 0 } })
            -- player:sendTip(1,lang(player,{"messager_upgrate",lv[3]}))
        else
            local lv = split(itemUpgrate.idItem, "_")
            lv[3] = math.ceil(lv[3] - Upgrate[equipment.level].lowLv[math.random(1, 2)])
            itemUpgrate.idItem = table.concat(lv, "_")
            local cache = UserInfoCache.GetCache(player.platformUserId)
            messeger(player, { Text = { "messager_failUpgrate", lv[3] }, Color = { r = 0, b = 0, g = 0 } })
            -- player:sendTip(1,lang(player,{"messager_failUpgrate",lv[3]}))
        end
        objPlsyer:setPlayerItem(playerItem)
        objPlsyer:spendMoney(money)
        objPlsyer:removeItemInBalo(Vortex[1].id, 5)
    end
    if itemUpgrate.position == positionItem.hand then
        objPlsyer:refreshHand(itemUpgrate.cellNum)
        Trigger.CheckTriggers(player:cfg(), "PALYER_CHECK_TUTORIAL_MISSION", { obj1 = player, model = objPlsyer })
    end
    Trigger.CheckTriggers(player:cfg(), "PLAYER_UPGRATE", { item = itemUpgrate.idItem, oldItem = oldItem, obj1 = player })
    objPlsyer:save(false)
    return true, itemUpgrate
end)
-- ????ng b??n s???n ph???m l??n ch??? ??en
PackageHandlers.registerServerHandler("publishBlackMarket", function(player, packet)
    local PlayerModel = Gol.Player[player.platformUserId]
    local playerItem = PlayerModel:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    local count = context_playerItem:where("idItem", packet.idItem):sum("num")
    if count <= 0 or count < packet.quantily then
        messeger(player, { Text = { "messeger_NotEnoughItem", "" } })
        return false
    end
    packet.idPlayer = player.platformUserId
    packet.playerName = player.name
    local clsBlackMar = BlackMarket:new(packet)
    clsBlackMar:sell()
    PlayerModel:removeItemInBalo(packet.idItem, packet.quantily)
    messeger(player, { Text = { "messager_publishProduct" }, Color = { r = 0, b = 0, g = 0 } })
    Trigger.CheckTriggers(player:cfg(), "PLAYER_SELL_ITEM", { item = packet.idItem, obj1 = player, where = 2 })
    return true
end)
-- xem s???n ph???m ??? ch??? ??en
PackageHandlers.registerServerHandler("seenBlackMarket", function(player, packet)
    DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function(userId, jdata)
        if jdata == nil or jdata == "" then
            jdata = "[]"
        end
        local data = cjson.decode(jdata)
        local MarKets = {}
        for key, value in pairs(data) do
            if not value.sold then
                MarKets[key] = value
            end
        end
        PackageHandlers.sendServerHandler(player, "BlackMarket", MarKets)
    end)
end)
-- xem s???n ph???m c???a m??nh
PackageHandlers.registerServerHandler("seenMyMarket", function(player, packet)
    DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function(userId, jdata)
        if jdata == nil or jdata == "" then
            jdata = "[]"
        end
        local data = cjson.decode(jdata)
        local myMarket = {}
        for key, value in pairs(data) do
            if value.idPlayer == player.platformUserId and not value.sold then
                myMarket[key] = value
            end
        end
        PackageHandlers.sendServerHandler(player, "BlackMarket", myMarket)
    end)
end)
-- x??a s???n ph???m
PackageHandlers.registerServerHandler("deleteProduct", function(player, packet)
    local PlayerModel = Gol.Player[player.platformUserId]
    DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function(userId, jdata)
        if jdata == nil or jdata == "" then
            jdata = "[]"
        end
        local data = cjson.decode(jdata)
        local product = data[packet.key]
        PlayerModel:startTransaction()
        if not PlayerModel:addItemInBalo(product.idItem, product.quantily) then
            PlayerModel:rollbackTransaction()
        else
            Trigger.CheckTriggers(this, "PLAYER_REMOVE_BLACKMARKET", { obj1 = player, item = data[packet.key].idItem })
            data[packet.key] = nil
            DBHandler:setData(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, cjson.encode(data), true)
            PlayerModel:commitTransaction()
        end
    end)
end)
-- mua s???n ph???m ch??? ??en
PackageHandlers.registerServerHandler("sellBlackMarket", function(player, packet)
    DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function(userId, jdata)
        local data = cjson.decode(jdata)
        local MarKet = BlackMarket:new(data[packet.key], packet.key)
        MarKet:buy(Gol.Player[player.platformUserId])
    end)
end)

-- l???y c??p ????o ng?????i ch??i
PackageHandlers.registerServerHandler("getCup", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local playerItem = objPlayer:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    local getCup = context_playerItem:where("idItem", "find", packet.cup):firstData()
    local context_item = Context:new("Item")
    return context_item:where("id", getCup.idItem):firstData()
end)
-- l???y trang b???
PackageHandlers.registerServerHandler("getEquiment", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    return objPlayer:getEquiment()
end)

-- m???c trang b???
PackageHandlers.registerServerHandler("wearEquipment", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local playerItem = objPlayer:getPlayerItem()
    local context_playerItem = Context:new(playerItem)
    if context_playerItem:where("idItem", packet.id):sum("num") >= 1 then
        local context_equipment = Context:new("Equipment")
        local equipmentPlayer = objPlayer:getEquiment()
        for index, value in ipairs(equipmentPlayer) do
            local item = context_equipment:where("id", value):firstData()
            local item2 = context_equipment:where("id", packet.id):firstData()
            if item.typeEquipment == item2.typeEquipment then
                equipmentPlayer[index] = packet.id
                objPlayer:setEquiment(equipmentPlayer)
                objPlayer:removeItemInBalo(packet.id, 1)
                objPlayer:addItemInBalo(item.id, 1)
                objPlayer:save(false)
                return equipmentPlayer
            end
        end
        equipmentPlayer[#equipmentPlayer + 1] = packet.id
        objPlayer:setEquiment(equipmentPlayer)
        objPlayer:removeItemInBalo(packet.id, 1)
        objPlayer:save(false)
        return equipmentPlayer
    end
    return false
end)
--  g??? trang b???
PackageHandlers.registerServerHandler("unequip", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    objPlayer:startTransaction()
    local equipmentPlayer = objPlayer:getEquiment()
    for index, value in ipairs(equipmentPlayer) do
        if value == packet.id then
            table.remove(equipmentPlayer, index)
            break
        end
    end
    objPlayer:setEquiment(equipmentPlayer)
    local rs = objPlayer:addItemInBalo(packet.id, 1)
    if rs then
        objPlayer:commitTransaction()
        objPlayer:save(false)
    else
        objPlayer:rollbackTransaction()
        return false
    end
    return equipmentPlayer
end)
-- n??ng c???p id card
PackageHandlers.registerServerHandler("updateIdCard", function(player, packet)
    local Id_card = { 20000, 60000, 100000, 600000, 1000000, 2000000, 4000000, 6000000, 10000000 }
    local objPlayer = Gol.Player[player.platformUserId]
    if objPlayer:getMoney() >= Id_card[objPlayer:getIdCard()] then
        objPlayer:spendMoney(Id_card[objPlayer:getIdCard()])
        objPlayer:setIdCard(objPlayer:getIdCard() + 1)
        Trigger.CheckTriggers(player:cfg(), "PLAYER_UPDATE_IDCARD", { obj1 = player, idcard = objPlayer:getIdCard() })
        return objPlayer:getIdCard()
    else
        messeger(player, { Text = { "messeger_NotEnoughMoney" } })
        return false
    end
end)
-- nh???n nhi???m v??? tutorial
PackageHandlers.registerServerHandler("TakingMissionTutorial", function(player, packet)
    Gol.Player[player.platformUserId]:setTakingMissionTutorial(true)
    Trigger.CheckTriggers(this, "PALYER_CHECK_TUTORIAL_MISSION",
        { obj1 = player, model = Gol.Player[player.platformUserId] })
end)
-- ??i???m danh 7 ng??y v?? 28 ng??y
PackageHandlers.registerServerHandler("RollUp", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    objPlayer:startTransaction()
    local compareDate = require "script_common.lbr.compareDate"
    local valuePlayer = objPlayer:toTable()
    local lastRollUp = valuePlayer["lastRollUp" .. packet.rollUp] or (os.time() - 86400)
    if compareDate(lastRollUp, os.time()) >= 1 then
        local login = require "script_common.database.Login"
        local day7 = login["day" .. packet.rollUp][(valuePlayer["countRollUp" .. packet.rollUp] % packet.rollUp) + 1]
        objPlayer:increaseMoney(day7.coin)
        objPlayer:addExp(day7.exp)
        for key, value in pairs(day7.item) do
            if not objPlayer:addItemInBalo(key, value) then
                objPlayer:rollbackTransaction()
                return false
            end
        end
        if packet.rollUp == 7 then
            objPlayer:setLastRollUp7(os.time())
            objPlayer:setCountRollUp7(objPlayer:getCountRollUp7() + 1)
        else
            objPlayer:setLastRollUp28(os.time())
            objPlayer:setCountRollUp28(objPlayer:getCountRollUp28() + 1)
        end
        objPlayer:commitTransaction()
        objPlayer:save(false)
        return true
    end
    return false
end)

PackageHandlers.registerServerHandler("getAchievement", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    return objPlayer:getAchievement(), objPlayer:toTable()
end)

-- nh???n Achievement
PackageHandlers.registerServerHandler("ProccedAchievement", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    local playerAchi = objPlayer:getAchievement()
    local function locate(table, value)
        for i = 1, #table do
            if table[i] == value then return true end
        end
        return false
    end

    if locate(playerAchi.done, packet.achi) and not locate(playerAchi.proceed, packet.achi) then
        objPlayer:startTransaction()
        local Achievement = require "script_common.database.Acievement"[packet.achi]
        playerAchi.proceed[#playerAchi.proceed + 1] = packet.achi
        objPlayer:setAchievement(playerAchi)
        for key, value in pairs(Achievement.reward.item) do
            if not objPlayer:addItemInBalo(key, value) then
                objPlayer:rollbackTransaction()
                return false
            end
        end
        objPlayer:increaseMoney(Achievement.reward.coin)
        objPlayer:addExp(Achievement.reward.exp)
        objPlayer:commitTransaction()
        objPlayer:save(false)
        return true
    end
    return false
end)

PackageHandlers.registerServerHandler("GoHome", function(player, packet)
    player:serverRebirth()
    PackageHandlers.sendServerHandler(player, "PlayMP3Loppy")
end)

PackageHandlers.registerServerHandler("addBuff", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    return objPlayer:addBuff(packet.buff, packet.time)

end)
PackageHandlers.registerServerHandler("removeBuff", function(player, packet)
    local objPlayer = Gol.Player[player.platformUserId]
    objPlayer:removeBuff(packet.buff)
end)

Trigger.addHandler(this, "ENTITY_STATUS_CHANGE", function(context)
    PackageHandlers.sendServerHandler(context.obj1, "StopGoHome")
end)

PackageHandlers.registerServerHandler("PLAYER_BEGIN_MINE", function(player, packet)
    Gol.Player[player.platformUserId]:beginMine(Gol.Material[packet.objID])
end)

PackageHandlers.registerServerHandler("PLAYER_END_MINE", function(player, packet)
    Gol.Player[player.platformUserId]:endMine(packet.itemid, packet.objId)
    Gol.Player[player.platformUserId]:save(false)
end)

PackageHandlers.registerServerHandler("buyCoin", function(player, packet)
    local Gcube = {
        [1] = 1000,
        [5] = 5000,
        [10] = 10000,
        [25] = 28000,
        [50] = 60000,
        [100] = 130000,
        [200] = 300000,
        [300] = 480000
    }
    local PayHelper = Game.GetService("PayHelper")
    PayHelper:payMoney(player, "buyCoin" .. packet.Gcube, packet.Gcube, function(ret)
        if ret then
            Gol.Player[player.platformUserId]:increaseMoney(Gcube[packet.Gcube])
            Gol.Player[player.platformUserId]:save(false)
        end
    end)
end)

PackageHandlers.registerServerHandler("getRank", function(player, packet)
    local MyRank = {}
    local overrideRank = require "script_common.lbr.temporary"
    local RankMineData = Engine.DataService:GetRankDataStore("Mine")
    overrideRank(RankMineData)
    local valuePlayer = Gol.Player[player.platformUserId]
    RankMineData:RequestData(tostring(player.platformUserId), function(mine, rank)
        print("get my rank mine finish")
        PackageHandlers.sendServerHandler(player, "getRank", {
            name = "getMyRankMine",
            mine = mine,
            rank = rank
        })
        MyRank[#MyRank+1] = {
            name = "getMyRankMine",
            mine = mine,
            rank = rank
        }
        player:setValue("Rank",MyRank)
    end)
    RankMineData:RequestRangeData(1,50,function (DataMine)
        print("get rank mine finish")
        PackageHandlers.sendServerHandler(player, "getRank", {
            name = "getRankMine",
            data = DataMine
        })
        MyRank[#MyRank+1]= {
            name = "getRankMine",
            data = DataMine
        }
        player:setValue("Rank",MyRank)
    end)
    local RankLvData = Engine.DataService:GetRankDataStore("Lv")
    overrideRank(RankLvData)
    RankLvData:RequestData(tostring(player.platformUserId), function(lv, rank)
        print("get my rank lv finish")
        PackageHandlers.sendServerHandler(player, "getRank", {
            name = "getMyRankLv",
            lv = lv,
            rank = rank
        })
        MyRank[#MyRank+1]= {
            name = "getMyRankLv",
            lv = lv,
            rank = rank
        }
        player:setValue("Rank",MyRank)
    end)    
    RankLvData:RequestRangeData(1,50,function (Data)
        print("get rank lv finish")
        PackageHandlers.sendServerHandler(player, "getRank", {
            name = "getRankLv",
            data = Data
        })
        MyRank[#MyRank+1]= {
            name = "getRankLv",
            data = Data
        }
        player:setValue("Rank",MyRank)
    end)
end)