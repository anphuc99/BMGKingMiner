local class = require "script_server.lbr.Class"
local Context = require "script_server.lbr.Context"
local Gol = require "script_server.Golde_Valiable"
local positionItem = require "script_common.positionItem"
local Item = require "script_server.Model.Item"
local typeItem = require "script_common.typeItem"
local messenger = require "script_server.Helper.SendMesseger"
local Language = require "script_common.language"
local addSlotItem = require "script_server.lbr.addSlotItem"
local removeSlotItem = require "script_server.lbr.removeSlotItem"
local TypeItem = require "script_common.typeItem"
local lg = require "script_common.language"
local PlayerClass = class()
PlayerClass:create("Player",function ()
    local o = {}
    local id
    local isMining = false

    function o:getLanguage()        
        return o:getObj():getValue("Player").language
    end
    function o:setLanguage(_language)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.language = _language
        player:setValue("Player", proPlayer)
    end

    function o:getMoney()
        return o:getObj():getValue("Player").money
    end
    function o:setMoney(_Money)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.money = _Money
        player:setValue("Player", proPlayer)
    end

    function o:getBalo()
        return o:getObj():getValue("Player").balo
    end
    function o:setBalo(_balo)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.balo = _balo
        player:setValue("Player", proPlayer)
    end

    function o:getIdCard()
        return o:getObj():getValue("Player").idCard
    end
    function o:setIdCard(_idCard)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.idCard = _idCard
        player:setValue("Player", proPlayer)
    end

    function o:getLv()
        return o:getObj():getValue("Player").Lv
    end
    function o:setLv(_Lv)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.Lv = _Lv
        player:setValue("Player", proPlayer)
    end

    function o:getExp()
        return o:getObj():getValue("Player").exp
    end
    function o:setExp(_Money)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.exp = _Money
        player:setValue("Player", proPlayer)
    end

    function o:getLastLogin()
        return o:getObj():getValue("Player").lastLogin
    end
    function o:setLastLogin(_lastLogin)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.lastLogin = _lastLogin
        player:setValue("Player", proPlayer)
    end    

    function o:__constructor(_id)
        id = _id
    end
    function o:getID()
        return id
    end
    function o:setID(_id)
        id = _id
    end
    function o:getObj() 
        return World.CurWorld:getObject(id)
    end
    function o:beginMine(MaterialModel)        
        if not isMining then
            local obj = o:getObj()
            local MaObjID = MaterialModel:getObjID()
            local MaObj = MaterialModel:getObj()
            local context_trophy = Context:new("Trophy")
            local Item_hand = obj:getHandItem()  
            local Item_id = Item_hand:full_name()
            local trophy = context_trophy:where("id",Item_id):getData()[1]
            local real_speed = MaterialModel:getStiffness() - trophy.mineSpeed
            if real_speed <= 0 then
                real_speed = 1
            end
            isMining = true
            -- truyền đến UI          
            PackageHandlers.sendServerHandler(obj, "UI", {real_speed = real_speed, UI="thanh dao"})
            -- chạy thời gian thực
            World.Timer(2, function ()
                if Gol.Material[MaObjID] == nil then
                    isMining = false
                    PackageHandlers.sendServerHandler(obj,"StopMine")
                    return false
                elseif not isMining then
                    PackageHandlers.sendServerHandler(obj,"StopMine")
                    return false
                else
                    local plaPos = obj:curBlockPos()
                    local MaPos = MaObj:curBlockPos()
                    local distance = math.abs(math.sqrt((plaPos.x - MaPos.x)^2+(plaPos.y - MaPos.y)^2+(plaPos.z - MaPos.z)^2))
                    if distance > 2 then
                        isMining = false
                        PackageHandlers.sendServerHandler(obj,"StopMine")
                        return false
                    end
                    if real_speed <= 0 then
                        if o:endMine(MaterialModel) then
                            MaObj:kill(obj, "hit")
                        end                         
                        PackageHandlers.sendServerHandler(obj,"StopMine")
                        isMining = false
                        return false
                    end
                    real_speed = real_speed -1 
                    return 1
                end      
            end)   
        else
            isMining = false 
        end        
    end
    function o:endMine(MaterialModel)
        return MaterialModel:addToPlayer(o:getObj())
    end
    function o:removeItemInBalo(itemId,num)
        num = num or 2^1023 
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        for key, value in pairs(playerItem) do
            if value.idItem == itemId then
                value.num = value.num - num
                if value.num <= 0 then
                    table.remove(playerItem,key)
                end
                break
            end
        end
        player:setValue("PlayerItem", playerItem)
    end
    function o:removeCellNumItem(cellNum, position ,num)
        num = num or 2^1023
        position = position or positionItem.balo
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        for key, value in pairs(playerItem) do
            if value.cellNum == cellNum and value.position == position then
                value.num = value.num - num
                if value.num <=0 then
                    table.remove(playerItem,key)
                end
                break
            end
        end
        player:setValue("PlayerItem", playerItem)
    end
    function o:addItemInBalo(itemId, num)
        local context_item = Context:new("Item")
        local itemData = context_item:where("id",itemId):getData()
        local itemObj = Item:new(itemData)
        itemObj:addToPlayer(o:getObj(),num)
    end
    function o:moveCellBalo(oldCellNum,NewCellNum)
        if oldCellNum == NewCellNum then
            return false
        end
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        local context_player = Context:new(playerItem)
        local playerOldCellItem = context_player:where("position",positionItem.balo):where("cellNum",oldCellNum):firstData()
        local playerNewCellItem = context_player:where("position",positionItem.balo):where("cellNum",NewCellNum):firstData()
        if playerNewCellItem == nil then
            playerOldCellItem.cellNum = NewCellNum
            player:setValue("PlayerItem", playerItem)
        else
            if playerOldCellItem.idItem == playerNewCellItem.idItem then
                local context_item = Context:new("Item")             
                local checkItem2 = context_item:where("id",playerOldCellItem.idItem):firstData()
                if checkItem2.typeItem == typeItem.Equipment then
                    messenger(player,{Text = Language.messeger.ItemNotMerge[o:getLanguage()], Color = {r = 255, g = 0, b = 0}})
                    return false
                else
                    playerNewCellItem.num = playerNewCellItem.num + playerOldCellItem.num 
                    player:setValue("PlayerItem", playerItem)
                    o:removeCellNumItem(playerOldCellItem.cellNum)
                end
            else
                playerOldCellItem.cellNum = NewCellNum
                playerNewCellItem.cellNum = oldCellNum 
                player:setValue("PlayerItem", playerItem)
            end            
        end
        
        return true
    end
    function o:baloToHand(cellNum)        
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        local context_player = Context:new(playerItem)
        local playerItem2 = context_player:where("position",positionItem.balo):where("cellNum",cellNum):firstData()
        
        local context_player = Context:new(playerItem)
        local checkItem = context_player:where("position",positionItem.hand):where("idItem", playerItem2.idItem):firstData()
        local context_item = Context:new("Item")
        local typeItem = context_item:where("id",playerItem2.idItem):firstData()        
        if typeItem.typeItem ~= TypeItem.Equipment and checkItem ~= nil then            
            checkItem.num = checkItem.num + playerItem2.num            
            player:setValue("PlayerItem", playerItem)
            o:removeCellNumItem(cellNum,positionItem.balo)
            removeSlotItem(player,checkItem.cellNum)
            addSlotItem(player,checkItem.idItem,checkItem.num,checkItem.cellNum)
            return true
        else            
            local rs = false
            for i = 1, 9, 1 do
                local checkCellNum = context_player:where("position",positionItem.hand):where("cellNum", i):firstData()
                if checkCellNum == nil then
                    playerItem2.position = positionItem.hand
                    playerItem2.cellNum = i
                    player:setValue("PlayerItem", playerItem)
                    addSlotItem(player,playerItem2.idItem,playerItem2.num,playerItem2.cellNum)
                    rs = true
                    break
                end
            end
            if not rs then                
                messenger(player,{Text = lg.messeger.FullBP[o:getLanguage()], Color = {r = 255, g = 0, b = 0}})
            end
            return rs
        end
    end

    function o:handToBalo(cellNum)
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        local context_player = Context:new(playerItem)
        local slot = player:getHandItem():slot()        
        local playerItem2 = context_player:where("position",positionItem.hand):where("cellNum",slot):firstData()
        playerItem2.position = positionItem.balo
        playerItem2.cellNum = cellNum
        player:setValue("PlayerItem", playerItem)
        removeSlotItem(player,slot)
        return true
    end

    function o:spendMoney(money)
        local plMoney = o:getMoney()
        if plMoney < money then
            messenger(o:getObj(),{Text = lg.messeger.NotEnoughMoney[o:getLanguage()], Color = {r = 255, g = 0, b = 0}})
            return false
        else
            o:setMoney(plMoney - money)
            return true
        end
    end
    return o
end)

return PlayerClass