local Gol = require "script_server.Golde_Valiable"
local this = Entity.GetCfg("myplugin/player1")
local PlayerModel = require "script_server.Model.Player"
local cupLv1 = "myplugin/P_cup-go_1"
local setIdPlayer = require "script_server.lbr.setIdPlayer"
local Context = require "script_common.lbr.Context"
local deepCopy = require "script_common.lbr.DeepCopyTable"
local positionItem = require "script_common.positionItem"
local SlotBalo = require "script_common.SlotBalo"
local messeger = require "script_server.Helper.SendMesseger"
local Language = require "script_common.language"
local split = require "script_common.lbr.split"
local Upgrate = require "script_common.database.Upgrate"
local Vortex = require "script_common.database.Vortex"

Trigger.RegisterHandler(this, "ENTITY_ENTER", function(context)
    local PlayerObj = PlayerModel:new(context.obj1.objID)
    Gol.Player[context.obj1.objID] = PlayerObj    
    -- context.obj1.addValueDef("new", false, false, false, true, false)
    local newPlayer = context.obj1:getValue("new") -- kiểm tra có phải là người mới hay không
    if(not newPlayer) then
        context.obj1:setValue("new", true)
        local proPlayer = context.obj1:getValue("Player")
        -- proPlayer.id = setIdPlayer()
        context.obj1:setValue("Player", proPlayer)
        context.obj1:addItem(cupLv1, 1)        
        --PackageHandlers.sendServerHandler(context.obj1, "UI", {UI = "Language"})
        PackageHandlers.sendServerHandler(context.obj1, "setMoney", { money = 1000})
    else
        PlayerObj:setLastLogin(os.time())
        context.obj1:setValue("Player", plpro)
    end
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
PackageHandlers.registerServerHandler("baloToHand", function(player, packet)
    local objPlayer = Gol.Player[player.objID]    
    return objPlayer:baloToHand(packet.cellNum)
end)
-- thực hiện chuyển vật phẩm từ tay lên balo
PackageHandlers.registerServerHandler("handToBalo", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    objPlayer:handToBalo(packet.cellNum)
    local playerItem = player:getValue("PlayerItem")
    local context_playerItem = Context:new(playerItem)
    local context_item = Context:new("Item")
    local playerItem2 = context_playerItem:where("position",positionItem.balo):where("cellNum",packet.cellNum):firstData()     
    local res = context_item:where("id",playerItem2.idItem):firstData()
    res.num = playerItem2.num     
    return res
end)
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
PackageHandlers.registerServerHandler("setLanguage", function(player, packet)
    Gol.Player[player.objID]:setLanguage(Language.language[packet.i].name)
end)
-- chế tạo trang bị
PackageHandlers.registerServerHandler("crafting", function(player, packet)
    local objPlayer = Gol.Player[player.objID]
    if objPlayer:freeBalo() < 1 then
        
        return {rs = false}
    end
    local context_recipe = Context:new("Recipe")
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
    if objPlayer:countItem(packet.id) >= 1 then
        local context_flea = Context:new("FleaMarket")
        local flea = context_flea:where("idItem",packet.id):where("idNPC",packet.NPC):firstData()    
        local moneyPlayer = objPlayer:getMoney()
        objPlayer:setMoney(moneyPlayer + flea.price)
        objPlayer:removeItemInBalo(flea.idItem,1)
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
    local context_playerItem = Context:new(playerItem)
    local itemUpgrate = context_playerItem:where("cellNum",packet.cellNum):firstData() 
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
            player:sendTip(1,"Nâng cấp thành công cấp"..lv[3])
        else
            local lv = split(itemUpgrate.idItem,"_") 
            lv[3] = math.ceil(lv[3] - Upgrate[equipment.level].lowLv[math.random(1,2)])
            itemUpgrate.idItem = table.concat(lv,"_")
            player:sendTip(1,"Nâng cấp thất bại đã giảm xuống cấp"..lv[3])
        end        
        print(Lib.pv(playerItem))
        player:setValue("PlayerItem", playerItem)
        objPlsyer:spendMoney(money)
        objPlsyer:removeItemInBalo(Vortex[1].id,5)
    end
    return true,itemUpgrate
end)