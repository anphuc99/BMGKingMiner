local Gol = require "script_server.Golde_Valiable"
local this = Entity.GetCfg("myplugin/player1")
local PlayerModel = require "script_server.Model.Player"
local cupLv1 = "myplugin/P_cup_1"
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

Trigger.RegisterHandler(this, "ENTITY_ENTER", function(context)
    local PlayerObj = PlayerModel:new(context.obj1.objID)
    Gol.Player[context.obj1.objID] = PlayerObj    
    -- context.obj1.addValueDef("new", false, false, false, true, false)
    local newPlayer = context.obj1:getValue("new") -- kiểm tra có phải là người mới hay không
    if(not newPlayer) then
        context.obj1:setValue("new", true)
        local proPlayer = context.obj1:getValue("Player")
        print(proPlayer.id)
        context.obj1:setValue("Player", proPlayer)
        context.obj1:addItem(cupLv1, 1)        
        --PackageHandlers.sendServerHandler(context.obj1, "UI", {UI = "Language"})
        PackageHandlers.sendServerHandler(context.obj1, "setMoney", { money = PlayerObj:getMoney()})
    else
        PlayerObj:setLastLogin(os.time())        
        PackageHandlers.sendServerHandler(context.obj1, "setMoney", { money = PlayerObj:getMoney()})
        if PlayerObj:getTakingMissionTutorial() then
            Trigger.CheckTriggers(this, "PALYER_CHECK_TUTORIAL_MISSION", {obj1 = context.obj1, model = PlayerObj}) 
        end        
    end
    PackageHandlers.sendServerHandler(context.obj1, "Player_enter", nil)
    PlayerObj:refreshHand()    
    PlayerObj:checkAchievement()
    if PlayerObj:getLastRollUp7() == nil or compareDate(PlayerObj:getLastRollUp7(),os.time()) >=1 then        
        PackageHandlers.sendServerHandler(context.obj1, "RedDotDally", nil)
    end
    if PlayerObj:getLastRollUp28() == nil or compareDate(PlayerObj:getLastRollUp28(),os.time()) >=1 then
        PackageHandlers.sendServerHandler(context.obj1, "RedDotDally", nil)
    end
end)
Trigger.RegisterHandler(this, "ENTITY_LEAVE", function(context)
    Gol.Player[context.objID] = nil
end)
-- lấy balo người chơi
PackageHandlers.registerServerHandler("getBackPackPlayer", function(player, packet)
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    playerItem = context_playerItem:where("position",positionItem.balo):getData()
    local context_item = Context:new("Item")
    local data = {}
    if playerItem ~= nil then        
        for key, value in pairs(playerItem) do
            if type(key) == "number" then
                local data1 = context_item:where("id",value.idItem):firstData()
                data1.num = value.num
                data1.cellNum = value.cellNum            
                data[#data+1] = deepCopy(data1)
            end            
        end
    end
    return data
end)
-- lấy các thuộc tính của người chơi
PackageHandlers.registerServerHandler("getValuePlayer", function(player, packet)
    local plpro = player:getValue("Player")
    return plpro
end)
-- thực hiện chuyển vật phẩm từ balo xuống tay người chơi
-- PackageHandlers.registerServerHandler("baloToHand", function(player, packet)
--     local objPlayer = Gol.Player[player.objID]    
--     return objPlayer:baloToHand(packet.cellNum)
-- end)
-- thực hiện chuyển vật phẩm từ tay lên balo
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
-- thực hiện đổi chỗ của item
PackageHandlers.registerServerHandler("moveItem", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    local rs = objPlayer:moveCellBalo(packet.oldCell, packet.newCell)    
    if rs then
        local data = {
            rs = rs,
            oldCell = {},
            newCell = {},
        }
        local playerItem = player:getValue("PlayerItem")
        print(Lib.pv(playerItem))
        local context_playerItem = Context:new(playerItem)
        -- playerItem = context_playerItem:where("position",positionItem.balo):getData()
        local context_item = Context:new("Item")
        local oldCellItem = context_playerItem:where("position",positionItem.balo):where("cellNum",packet.oldCell):firstData()
        if (oldCellItem == nil) then
            data.oldCell = nil
        else            
            data.oldCell = deepCopy(context_item:where("id",oldCellItem.idItem):firstData())
            data.oldCell.num = oldCellItem.num
        end      
        local newCellItem = context_playerItem:where("position",positionItem.balo):where("cellNum",packet.newCell):firstData()     
        data.newCell = deepCopy(context_item:where("id",newCellItem.idItem):firstData())
        data.newCell.num = newCellItem.num 
        print(Lib.pv(data))
        return data
    end
    return {rs = false}
end)
-- mở thêm ô balo
PackageHandlers.registerServerHandler("OpenCellNum", function(player, packet)    
    local objPlayer = Gol.Player[player.objID]
    local rs = objPlayer:spendMoney(SlotBalo[objPlayer:getBalo()+1].money)
    if rs then
        objPlayer:setBalo(objPlayer:getBalo() + 1)
    end
    return rs
end)
-- cài đặt ngôn ngữ
-- PackageHandlers.registerServerHandler("setLanguage", function(player, packet)
--     print("eeeeeeeeeeewwwwwwwwwwwwwwwwwwwwwww")
--     player:setData("lang", packet.lang)
-- end)
-- chế tạo trang bị
PackageHandlers.registerServerHandler("crafting", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    if objPlayer:freeBalo() < 1 then
        messeger(player,{Text = {"messeger_FullBP"}})        
        return {rs = false}
    end
    local context_recipe = Context:new("recipe")
    local recipe = context_recipe:where("id",packet.recId):firstData()
    local playerItem = player:getValue("PlayerItem")    
    local context_playerItem = Context:new(playerItem)
    local rs = true
    for key, value in pairs(recipe.Material) do
        local plNumItem = context_playerItem:where("idItem",value.id):sum("num")
        if value.num > plNumItem then
            rs = false
            break
        end
    end
    if rs then
        local context_equipment = Context:new("Equipment")
        local equipment = context_equipment:where("recipe",packet.recId):getData()
        local rd = math.random(1,100)
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
        objPlayer:addItemInBalo(winPrizes,1)
        for key, value in pairs(recipe.Material) do
            objPlayer:removeItemInBalo(value.id,value.num)
        end
        return {rs = true, item = winPrizes}
    else
        return {rs = false}
    end
end)
-- bán hàng chợ trời
PackageHandlers.registerServerHandler("sellFleaMarket", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    if objPlayer:countItem(packet.id) >= packet.num then
        local context_flea = Context:new("FleaMarket")
        local flea = context_flea:where("idItem",packet.id):where("idNPC",packet.NPC):firstData()        
        objPlayer:increaseMoney(flea.price * packet.num)
        objPlayer:removeItemInBalo(flea.idItem,packet.num)
    else
        messeger(player, {Text = {"messeger_NotEnoughItem",packet.name}, Color = {r = 255, g = 0, b = 0}})
    end
    
end)
-- Nâng cấp trang bị
PackageHandlers.registerServerHandler("Upgrate", function(player, packet)
    local objPlsyer = Gol.Player[player.objID]
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    local sumVor = context_playerItem:where("idItem",Vortex[1].id):sum("num")
    local context_equipment = Context:new("Equipment")
    local itemUpgrate = context_playerItem:where("idItem","find",packet.cup):firstData() 
    local equipment = context_equipment:where("id",itemUpgrate.idItem):firstData()
    local money = Upgrate[equipment.level].money
    if objPlsyer:getMoney() < money then
        messeger(player,{Text = {"messeger_NotEnoughMoney",1}, Color = {r = 255, g = 0, b = 0}})
        return false
    end
    if sumVor < 5 then
        local name = Context:new("Item"):where("id",Vortex[1].id):firstData().name
        messeger(player,{Text = {"messeger_NotEnoughItem",name}, Color = {r = 255, g = 0, b = 0}})
        return false
    end 
    
    if Upgrate[equipment.level] then
        local rd = math.random(1,100)
        if rd < Upgrate[equipment.level].percentage then
            local lv = split(itemUpgrate.idItem,"_") 
            lv[3] = math.ceil(lv[3] + 1)
            itemUpgrate.idItem = table.concat(lv,"_")
            messeger(player,{Text = {"messager_upgrate",lv[3]}, Color = {r=0,b=0,g=0}})
            -- player:sendTip(1,lang(player,{"messager_upgrate",lv[3]}))
        else
            local lv = split(itemUpgrate.idItem,"_") 
            lv[3] = math.ceil(lv[3] - Upgrate[equipment.level].lowLv[math.random(1,2)])
            itemUpgrate.idItem = table.concat(lv,"_")
            local cache = UserInfoCache.GetCache(player.platformUserId)
            messeger(player,{Text = {"messager_failUpgrate",lv[3]}, Color = {r=0,b=0,g=0}})
            -- player:sendTip(1,lang(player,{"messager_failUpgrate",lv[3]}))
        end        
        print(Lib.pv(playerItem))
        player:setValue("PlayerItem", playerItem)
        objPlsyer:spendMoney(money)
        objPlsyer:removeItemInBalo(Vortex[1].id,5)
    end
    if itemUpgrate.position == positionItem.hand then
        objPlsyer:refreshHand(itemUpgrate.cellNum)
        Trigger.CheckTriggers(player:cfg(), "PALYER_CHECK_TUTORIAL_MISSION", {obj1 = player, model = objPlsyer})
    end
    return true,itemUpgrate
end)
-- đăng bán sản phẩm lên chợ đen
PackageHandlers.registerServerHandler("publishBlackMarket", function(player, packet)
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    local count = context_playerItem:where("idItem",packet.idItem):sum("num")
    if count <=0 or count < packet.count then
        messeger(player,{Text = {"messeger_NotEnoughItem",""}})
        return false
    end
    packet.playerId = player.platformUserId
    packet.created_at = os.time()
    local blackMarket = player:getValue("blackMarket")
    blackMarket[#blackMarket+1] = packet
    player:setValue("blackMarket", blackMarket)
    Gol.Player[player.objID]:removeItemInBalo(packet.idItem,packet.count)
    messeger(player,{Text = {"messager_publishProduct"}, Color = {r=0,b=0,g=0}})
    -- player:sendTip(1, lang(player,{"messager_publishProduct"}))
    return true
end)
-- xem sản phẩm ở chợ đen
PackageHandlers.registerServerHandler("seenBlackMarket", function(player, packet)
    local blackMarket = {}
    for key, value in pairs(Gol.Player) do
        pcall(function ()
            local Market = value:getMarket()
            for key2, value2 in pairs(Market) do                
                value2.playerName = value:getObj().name
                value2.objId = key
                blackMarket[#blackMarket+1] = value2       
            end      
        end)  
    end
    print(Lib.pv(blackMarket))
    local context_blackMarket = Context:new(blackMarket)    
    local data = context_blackMarket:orderByDesc("created_at"):getData()
    print(Lib.pv(data))
    return data
end)
-- xem sản phẩm của mình
PackageHandlers.registerServerHandler("seenMyMarket", function(player, packet)
    local blackMarket = player:getValue("blackMarket")
    local context_blackMarket = Context:new(blackMarket)    
    return context_blackMarket:orderByDesc("created_at"):getData()
end)
-- xóa sản phẩm
PackageHandlers.registerServerHandler("deleteProduct", function(player, packet)
    if Gol.Player[player.objID]:freeBalo() >= 1 then
        local blackMarket = player:getValue("blackMarket")
        local context_blackMarket = Context:new(blackMarket)   
        local item = context_blackMarket:where("created_at",packet.created_at):firstData()
        Gol.Player[player.objID]:addItemInBalo(item.idItem,item.count)        
        for key, value in pairs(blackMarket) do
            if type(key) == "number" then
                if value.created_at == packet.created_at then
                    table.remove( blackMarket, key )         
                    break
                end
            end
        end
        player:setValue("blackMarket", blackMarket)
    else
        messeger(player,{Text = {"messeger_FullBP"}})
    end    
end)
-- mua sản phẩm chợ đen
PackageHandlers.registerServerHandler("sellBlackMarket", function(player, packet)
    local rs,rer = pcall(function ()
        if Gol.Player[packet.objId] then
            local playerObj = Gol.Player[packet.objId]
            local blackMarket = playerObj:getMarket()
            local context_blackMarket = Context:new(blackMarket)
            local item = context_blackMarket:where("created_at",packet.created_at):firstData()
            if item == nil then
                messeger(player, {Text ={"messeger_productsSold"}})
                return false
            end
            local sellerObj = Gol.Player[player.objID]        
            if not sellerObj:spendMoney(item.price) then
                return false
            end
            if not sellerObj:addItemInBalo(item.idItem,item.count) then
                sellerObj:increaseMoney(item.price) 
                return false
            end
            playerObj:increaseMoney(math.floor(item.price*90/100))   
            for key, value in pairs(blackMarket) do
                if value.created_at == packet.created_at then
                    table.remove(blackMarket,key)
                    break
                end
            end     
            playerObj:getObj():setValue("blackMarket", blackMarket)
            return true
        else
            messeger(player, {Text ={"messeger_offlinePlayer"}})
            return false
        end
    end)
    if not rs then
        messeger(player, {Text ={"messeger_offlinePlayer"}})
        return false
    else
        return rer
    end
end)

-- lấy cúp đào người chơi
PackageHandlers.registerServerHandler("getCup", function(player, packet)
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    local getCup = context_playerItem:where("idItem","find",packet.cup):firstData()
    local context_item = Context:new("Item")
    return context_item:where("id",getCup.idItem):firstData()
end)
-- lấy trang bị
PackageHandlers.registerServerHandler("getEquiment", function(player, packet)
    return player:getValue("Equipment")
end)

-- mặc trang bị
PackageHandlers.registerServerHandler("wearEquipment", function(player, packet)
    local playerItem = player:getValue("PlayerItem")
    print(packet.id)
    local context_playerItem = Context:new(playerItem)
    if context_playerItem:where("idItem",packet.id):sum("num") >= 1 then
        local context_equipment = Context:new("Equipment")
        local equipmentPlayer = player:getValue("Equipment")
        for index, value in ipairs(equipmentPlayer) do
            local item = context_equipment:where("id",value):firstData()
            local item2 = context_equipment:where("id",packet.id):firstData()
            if item.typeEquipment == item2.typeEquipment then
                equipmentPlayer[index] = packet.id
                player:setValue("Equipment", equipmentPlayer)
                Gol.Player[player.objID]:removeItemInBalo(packet.id,1)
                Gol.Player[player.objID]:addItemInBalo(item.id,1)
                return equipmentPlayer
            end
        end
        equipmentPlayer[#equipmentPlayer+1] = packet.id
        player:setValue("Equipment", equipmentPlayer)
        Gol.Player[player.objID]:removeItemInBalo(packet.id,1)
        return equipmentPlayer
    end
    return false    
end)
--  gỡ trang bị
PackageHandlers.registerServerHandler("unequip", function(player, packet)
    local equipmentPlayer = player:getValue("Equipment")
    for index, value in ipairs(equipmentPlayer) do
        if value == packet.id then
            table.remove(equipmentPlayer,index)
            break
        end
    end
    player:setValue("Equipment", equipmentPlayer)
    Gol.Player[player.objID]:addItemInBalo(packet.id,1)
    return equipmentPlayer
end)
-- nâng cấp id card
PackageHandlers.registerServerHandler("updateIdCard", function(player, packet)
    local Id_card = {20000,60000,100000,200000,600000,1000000,2000000,4000000}
    local objPlayer = Gol.Player[player.objID]
    if objPlayer:getMoney() >= Id_card[objPlayer:getIdCard()] then
        objPlayer:spendMoney(Id_card[objPlayer:getIdCard()])
        objPlayer:setIdCard(objPlayer:getIdCard() + 1)
        return objPlayer:getIdCard()
    else
        messeger(player,{Text = {"messeger_NotEnoughMoney"}})
        return false
    end
end)
-- nhận nhiệm vụ tutorial
PackageHandlers.registerServerHandler("TakingMissionTutorial", function(player, packet)
    Gol.Player[player.objID]:setTakingMissionTutorial(true)
    Trigger.CheckTriggers(this, "PALYER_CHECK_TUTORIAL_MISSION", {obj1 = player, model = Gol.Player[player.objID]}) 
end)
-- điểm danh 7 ngày và 28 ngày
PackageHandlers.registerServerHandler("RollUp", function(player, packet)
    local rollbackPlayerItem = player:getValue("PlayerItem")
    local rollbackPlayer = player:getValue("Player")
    local compareDate = require "script_common.lbr.compareDate"
    local valuePlayer = player:getValue("Player")
    local objPlayer = Gol.Player[player.objID]
    local lastRollUp = valuePlayer["lastRollUp"..packet.rollUp] or (os.time() - 86400)    
    if compareDate(lastRollUp,os.time()) >= 1 then
        local login = require "script_common.database.Login"        
        local day7 = login["day"..packet.rollUp][(valuePlayer["countRollUp"..packet.rollUp]%packet.rollUp)+1]
        objPlayer:increaseMoney(day7.coin)
        objPlayer:addExp(day7.exp) 
        for key, value in pairs(day7.item) do
            if not objPlayer:addItemInBalo(key,value) then
                player:setValue("Player", rollbackPlayer)
                player:setValue("PlayerItem", rollbackPlayerItem)
                return false
            end
        end
        local valuePlayer = player:getValue("Player")
        valuePlayer["lastRollUp"..packet.rollUp] = os.time()
        valuePlayer["countRollUp"..packet.rollUp] = valuePlayer["countRollUp"..packet.rollUp] + 1
        player:setValue("Player",valuePlayer)
        return true
    end
    return false
end)

PackageHandlers.registerServerHandler("getAchievement", function(player, packet)
    return player:getValue("Achievement"), player:getValue("Player")
end)

-- nhận Achievement
PackageHandlers.registerServerHandler("ProccedAchievement", function(player, packet)
    local playerAchi = player:getValue("Achievement")
    local function locate( table, value )
        for i = 1, #table do
            if table[i] == value then return true end
        end
        return false
    end
    if locate(playerAchi.done,packet.achi) and not locate(playerAchi.proceed,packet.achi) then
        local rollbackPlayerItem = player:getValue("PlayerItem")
        local rollbackPlayer = player:getValue("Player")        
        local rollbackAchi = player:getValue("Achievement")        
        local Achievement = require "script_common.database.Acievement"[packet.achi]
        playerAchi.proceed[#playerAchi.proceed+1] = packet.achi
        player:setValue("Achievement",playerAchi)
        local objPlayer = Gol.Player[player.objID]
        for key, value in pairs(Achievement.reward.item) do
            if not objPlayer:addItemInBalo(key,value) then
                player:setValue("Player", rollbackPlayer)
                player:setValue("PlayerItem", rollbackPlayerItem)
                player:setValue("Achievement", rollbackAchi)
                return false
            end
        end
        objPlayer:increaseMoney(Achievement.reward.coin)
        objPlayer:addExp(Achievement.reward.exp) 
        
        return true
    end
    return false
end)

PackageHandlers.registerServerHandler("GoHome", function(player, packet)
    player:serverRebirth()
end)

PackageHandlers.registerServerHandler("addBuff", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    return objPlayer:addBuff(packet.buff)
    
end)
PackageHandlers.registerServerHandler("removeBuff", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    objPlayer:removeBuff(packet.buff)
end)

Trigger.addHandler(this, "ENTITY_STATUS_CHANGE", function(context)
    PackageHandlers.sendServerHandler(context.obj1, "StopGoHome")
end)