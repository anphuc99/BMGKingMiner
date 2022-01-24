local Gol = require "script_server.Golde_Valiable"
local this = Entity.GetCfg("myplugin/player1")
local PlayerModel = require "script_server.Model.Player"
local cupLv1 = "myplugin/bc498465-8619-4188-bc57-ff9a717a3787"
local setIdPlayer = require "script_server.lbr.setIdPlayer"
local Context = require "script_server.lbr.Context"
local deepCopy = require "script_server.lbr.DeepCopyTable"
local positionItem = require "script_common.positionItem"
local SlotBalo = require "script_common.SlotBalo"
local messeger = require "script_server.Helper.SendMesseger"
local Language = require "script_common.language"

Trigger.RegisterHandler(this, "ENTITY_ENTER", function(context)
    local PlayerObj = PlayerModel:new(context.obj1.objID)
    Gol.Player[context.obj1.objID] = PlayerObj
    local newPlayer = context.obj1:getValue("new") -- kiểm tra có phải là người mới hay không
    if(newPlayer == nil) then
        context.obj1.addValueDef("new", true, true, true, true, true)
        context.obj1:addItem(cupLv1, 1)
        local idPlayer = setIdPlayer()
        local PlayerProperty = {
            id = idPlayer,
            money = 1000,
            balo = 6,
            idCard = 1,
            Lv = 1,
            exp = 0,
            language = "English",
            lastLogin = os.time()            
        }
        context.obj1.addValueDef("PlayerItem", {
            {idPlayer = idPlayer, idItem = cupLv1,cellNum = 1, num = 1, position = positionItem.hand, lv = 1},            
        }, true, true, true, true)
        context.obj1.addValueDef("Player", PlayerProperty, true, true, true, true)
        PackageHandlers.sendServerHandler(context.obj1, "UI", {UI = "Language"})
        context.obj1:sendTip(1, "Welcome", 60)
    else
        PlayerObj:setLastLogin(os.time())
        context.obj1:setValue("Player", plpro)
        print("hoho")
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