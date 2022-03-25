local class = require "script_common.lbr.Class"
local Context = require "script_common.lbr.Context"
local Gol = require "script_server.Golde_Valiable"
local positionItem = require "script_common.positionItem"
local Item = require "script_server.Model.Item"
local typeItem = require "script_common.typeItem"
local messenger = require "script_server.Helper.SendMesseger"
local addSlotItem = require "script_server.lbr.addSlotItem"
local removeSlotItem = require "script_server.lbr.removeSlotItem"
local TypeItem = require "script_common.typeItem"
local Vortex = require "script_common.database.Vortex"
local typeEquipment = require "script_common.EquimentType"
-- local lang = require "script_server.lbr.lang"
local PlayerClass = class()
PlayerClass:create("Player",function ()
    local o = {}
    local id
    local isMining = false
    local buff = {}

    -- function o:getLanguage()        
    --     return o:getObj():getValue("Player").language
    -- end
    -- function o:setLanguage(_language)
    --     local player = o:getObj()
    --     local proPlayer = player:getValue("Player")
    --     proPlayer.language = _language
    --     player:setValue("Player", proPlayer)
    -- end

    function o:getMoney()
        return o:getObj():getValue("Player").money
    end
    function o:setMoney(_Money)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.money = _Money
        player:setValue("Player", proPlayer)
        PackageHandlers.sendServerHandler(o:getObj(), "setMoney", {money = _Money})
        Trigger.CheckTriggers(o:getObj():cfg(), "PLAYER_SET_MONEY", {money = _Money, obj1 = o:getObj()})
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
        o:checkAchievement()
    end

    function o:getLv()
        return o:getObj():getValue("Player").Lv
    end
    function o:setLv(_Lv)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")             
        proPlayer.Lv = _Lv        
        player:setValue("Player", proPlayer)
        o:checkAchievement()        
    end
    
    function o:getMine()
        return o:getObj():getValue("Player").Mine
    end
    function o:setMine(_Mine)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")             
        proPlayer.Mine = _Mine        
        player:setValue("Player", proPlayer)
        o:checkAchievement()        
    end

    function o:getExp()
        return o:getObj():getValue("Player").exp
    end
    function o:setExp(_exp)
        local player = o:getObj()
        local Exp
        local Level = require("script_common.database.Level")
        for index, value in ipairs(Level) do
            if o:getLv() >= value.Lv[1] and o:getLv() <= value.Lv[2] then
                Exp = value.Exp
                break
            end
        end
        if _exp >= Exp then
            o:setLv(o:getLv() + 1)
            _exp = _exp - Exp
            o:setExp(_exp)
        else
            local proPlayer = player:getValue("Player")
            proPlayer.exp = _exp
            player:setValue("Player", proPlayer)
        end
        
    end

    function o:getTutorial()
        return o:getObj():getValue("Player").tutorial
    end
    function o:setTutorial(_tutorial)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.tutorial = _tutorial
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

    function o:getLastRollUp7()
        return o:getObj():getValue("Player").lastRollUp7
    end
    function o:setLastRollUp7(_lastRollUp7)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.lastRollUp7 = _lastRollUp7
        player:setValue("Player", proPlayer)
    end    

    function o:getlastRollUp28()
        return o:getObj():getValue("Player").lastRollUp28
    end
    function o:setlastRollUp28(_lastRollUp28)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.lastRollUp28 = _lastRollUp28
        player:setValue("Player", proPlayer)
    end    

    function o:getTakingMissionTutorial()
        return o:getObj():getValue("Player").takingMissionTutorial
    end
    function o:setTakingMissionTutorial(_takingMissionTutorial)
        local player = o:getObj()
        local proPlayer = player:getValue("Player")
        proPlayer.takingMissionTutorial = _takingMissionTutorial
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
    
    function o:addBuff(buffCfg,time)
        local buffId = 1
        while buff[buffId] ~= nil do
            buffId = buffId + 1
        end        
        buff[buffId] = o:getObj():addBuff(buffCfg,time)
        return buffId
    end

    function o:removeBuff(buffId)
        o:getObj():removeBuff(buff[buffId])
        buff[buffId] = nil
    end

    function o:beginMine(MaterialModel)        
        if not isMining then
            local obj = o:getObj()
            local MaObjID = MaterialModel:getObjID()
            local MaObj = MaterialModel:getObj()
            local context_trophy = Context:new("Trophy")
            local Item_hand = obj:getHandItem()  
            local Item_id = Item_hand:full_name()
            local trophy = context_trophy:where("id",Item_id):firstData()
            if (trophy.typeEquipment == typeEquipment.axe and MaterialModel:getTypeMar() == "Tree") or (trophy.typeEquipment == typeEquipment.pickaxe and MaterialModel:getTypeMar() == "Mar") then
                local mineSpeed = trophy.mineSpeed
                local playerEquiment = obj:getValue("Equipment")
                local context_equipment = Context:new("Equipment")
                for index, value in ipairs(playerEquiment) do
                    local item = context_equipment:where("id",value):firstData()
                    mineSpeed = mineSpeed + item.mineSpeed
                end
                local function toint(n)
                    local s = tostring(n)
                    local i, j = s:find('%.')
                    if i then
                        return tonumber(s:sub(1, i-1))
                    else
                        return n
                    end
                end
                local real_speed = toint(MaterialModel:getStiffness() * (30/ (mineSpeed + 30)))
                print("werwerwerwer")
                print(real_speed)
                if real_speed <= 0 then
                    real_speed = 1
                end
                isMining = true
                -- truyền đến UI          
                PackageHandlers.sendServerHandler(obj, "UI", {real_speed = real_speed, UI="thanh dao"})
                local buff = obj:addBuff("myplugin/Buff_DaoKhoan",real_speed)
                -- chạy thời gian thực
                World.Timer(2, function ()
                    if Gol.Material[MaObjID] == nil then
                        isMining = false
                        PackageHandlers.sendServerHandler(obj,"StopMine")
                        obj:removeBuff(buff)
                        return false
                    elseif not isMining then
                        PackageHandlers.sendServerHandler(obj,"StopMine")
                        obj:removeBuff(buff)
                        return false
                    else
                        local plaPos = obj:curBlockPos()
                        local MaPos = MaObj:curBlockPos()
                        local distance = math.abs(math.sqrt((plaPos.x - MaPos.x)^2+(plaPos.y - MaPos.y)^2+(plaPos.z - MaPos.z)^2))
                        if distance > 2 then
                            isMining = false
                            PackageHandlers.sendServerHandler(obj,"StopMine")
                            obj:removeBuff(buff)
                            return false
                        end
                        if real_speed <= 0 then
                            if o:endMine(MaterialModel:getId()) then
                                MaObj:kill(obj, "hit")
                                o:setExp(o:getExp() + MaterialModel:getExp())
                                PackageHandlers.sendServerHandler(obj, "shopArrow")
                                o:setMine(o:getMine() + 1)
                                Trigger.CheckTriggers(obj:cfg(), "PLAYER_END_MINE", {obj1 = obj, model = 0, item = MaterialModel:getId()})
                            end                         
                            PackageHandlers.sendServerHandler(obj,"StopMine")
                            isMining = false
                            return false
                        end
                        real_speed = real_speed -1 
                        return 1
                    end      
                end)  
            end
             
        else
            isMining = false 
        end        
    end
    function o:endMine(itemid)
        local rs = o:addItemInBalo(itemid,1)
        local rd = math.random(1,100) 
        for key, value in pairs(Vortex) do
            if type(key) == "number" then
                if o:getTutorial() == 4 then
                    if rd <= 50 then
                        o:addItemInBalo("myplugin/V_Vortex",1)
                        break
                    end  
                else
                    if rd <= value.percentage then
                        o:addItemInBalo(value.id,1)
                        break
                    else
                        rd = rd - value.percentage
                    end  
                end
                
            end
        end        
        return rs
    end
    function o:removeItemInBalo(itemId,num)
        num = num or 2^1023 
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        local i = 1
        while i <= #playerItem do
            local value = playerItem[i]
            if value.idItem == itemId and value.position == positionItem.balo then
                value.num = value.num - num
                if value.num <= 0 then
                    num = math.abs(value.num)
                    table.remove(playerItem,i)
                else
                    i = i + 1
                end   
            else
                i=i+1             
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
        num = num or 1
        local context_item = Context:new("Item")
        local itemData = context_item:where("id",itemId):firstData()
        local itemObj = Item:new(itemData)
        -- if itemData.typeItem == TypeItem.Equipment then
        --     if o:freeBalo() < num then
        --         messenger(o:getObj(), {Text = {"messeger_FullBP",num,itemData.name}})
        --         return false
        --     end
        --     for i = 1, num, 1 do
        --         if not itemObj:addToPlayer(o:getObj(),1) then
        --             return false
        --         end                
        --     end
        --     messenger(o:getObj(), {Text = {"messager_addItem",num,itemData.name}, Color = {r=0,g=0,b=0}})
        --     return true
        -- else

        -- end        
        if itemObj:addToPlayer(o:getObj(),num) then            
            messenger(o:getObj(), {Text = {"messager_addItem",num,itemData.name}, Color = {r=0,g=0,b=0}})
            Trigger.CheckTriggers(o:getObj():cfg(), "PLAYER_ADD_ITEM_IN_BALO", {obj1 = o:getObj(), itemid = itemId, num = num, model = o})
            return true
        end
        return false
    end
    function o:freeBalo()
        local playerItem = o:getObj():getValue("PlayerItem")
        local context_plaeyerItem = Context:new(playerItem)
        local count = context_plaeyerItem:where("position",positionItem.balo):getData()
        return o:getBalo() - #count
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
                -- local checkItem2 = context_item:where("id",playerOldCellItem.idItem):firstData()
                -- if checkItem2.typeItem == typeItem.Equipment then
                --     messenger(player,{Text = {"messeger_ItemNotMerge",1}, Color = {r = 255, g = 0, b = 0}})
                --     return false
                -- else

                -- end
                playerNewCellItem.num = playerNewCellItem.num + playerOldCellItem.num 
                player:setValue("PlayerItem", playerItem)
                o:removeCellNumItem(playerOldCellItem.cellNum)
            else
                playerOldCellItem.cellNum = NewCellNum
                playerNewCellItem.cellNum = oldCellNum 
                player:setValue("PlayerItem", playerItem)
            end            
        end
        
        return true
    end
    -- function o:baloToHand(cellNum)        
    --     local player = o:getObj()
    --     local playerItem = player:getValue("PlayerItem")
    --     local context_player = Context:new(playerItem)
    --     local playerItem2 = context_player:where("position",positionItem.balo):where("cellNum",cellNum):firstData()
        
    --     local context_player = Context:new(playerItem)
    --     local checkItem = context_player:where("position",positionItem.hand):where("idItem", playerItem2.idItem):firstData()
    --     local context_item = Context:new("Item")
    --     local typeItem = context_item:where("id",playerItem2.idItem):firstData()        
    --     if typeItem.typeItem ~= TypeItem.Equipment and checkItem ~= nil then            
    --         checkItem.num = checkItem.num + playerItem2.num            
    --         player:setValue("PlayerItem", playerItem)
    --         o:removeCellNumItem(cellNum,positionItem.balo)
    --         removeSlotItem(player,checkItem.cellNum)
    --         addSlotItem(player,checkItem.idItem,checkItem.num,checkItem.cellNum)
    --         return true
    --     else            
    --         local rs = false
    --         for i = 1, 9, 1 do
    --             local checkCellNum = context_player:where("position",positionItem.hand):where("cellNum", i):firstData()
    --             if checkCellNum == nil then
    --                 playerItem2.position = positionItem.hand
    --                 playerItem2.cellNum = i
    --                 player:setValue("PlayerItem", playerItem)
    --                 addSlotItem(player,playerItem2.idItem,playerItem2.num,playerItem2.cellNum)
    --                 rs = true
    --                 break
    --             end
    --         end
    --         if not rs then                
    --             messenger(player,{Text = {"messeger_FullBP",1}, Color = {r = 255, g = 0, b = 0}})
    --         end
    --         return rs
    --     end
    -- end

    -- function o:handToBalo(cellNum)
    --     local player = o:getObj()
    --     local playerItem = player:getValue("PlayerItem")
    --     local context_player = Context:new(playerItem)
    --     local slot = player:getHandItem():slot()        
    --     local playerItem2 = context_player:where("position",positionItem.hand):where("cellNum",slot):firstData()
    --     playerItem2.position = positionItem.balo
    --     playerItem2.cellNum = cellNum
    --     player:setValue("PlayerItem", playerItem)
    --     removeSlotItem(player,slot)
    --     return true
    -- end

    function o:spendMoney(money)
        local plMoney = o:getMoney()
        if plMoney < money then
            messenger(o:getObj(),{Text = {"messeger_NotEnoughMoney",1}, Color = {r = 255, g = 0, b = 0}})
            return false
        else
            o:setMoney(plMoney - money)
            return true
        end
    end

    function o:increaseMoney(money)
        local plMoney = o:getMoney()
        o:setMoney(plMoney + money)
    end

    function o:countItem(itemid)
        local playerItem = o:getObj():getValue("PlayerItem")
        local context_playerItem = Context:new(playerItem)
        return context_playerItem:where("idItem",itemid):where("position",positionItem.balo):sum("num")
    end

    function o:getMarket()
        return o:getObj():getValue("blackMarket")
    end

    function o:refreshHand(...)
        local slot = {...}
        local player = o:getObj()
        local playerItem = player:getValue("PlayerItem")
        local context_plaeyerItem = Context:new(playerItem)     
        
        if #slot == 0 then
            for i = 1, 9, 1 do
               pcall(function ()
                   removeSlotItem(player,i)
               end)
            end            
            local handItem = context_plaeyerItem:where("position",positionItem.hand):getData()
            for index, value in ipairs(handItem) do
                addSlotItem(player,value.idItem,value.num,value.cellNum)
            end
        else
            for key, value in pairs(slot) do
                pcall(function ()
                    removeSlotItem(player,value)
                end)
                print(Lib.pv(playerItem))
                local item = context_plaeyerItem:where("cellNum",value):where("position",positionItem.hand):firstData()                
                print(Lib.pv(item))
                addSlotItem(player,item.idItem,item.num,item.cellNum)
            end
        end
    end
    function o:addExp(exp)
        o:setExp(o:getExp() + exp)
    end

    function o:checkAchievement()
        local Achievement = require "script_common.database.Acievement"
        local obj = o:getObj()
        local function locate( table, value )
            for i = 1, #table do
                if table[i] == value then return true end
            end
            return false
        end
        local getAchievement = obj:getValue("Achievement")
        local valuePlayer = obj:getValue("Player")
        for index, value in ipairs(Achievement) do
            if not locate(getAchievement.done,index) then
                local check = true
                for key, value in pairs(value.condition) do                    
                    if valuePlayer[key] ~= value then
                        check = false
                        break
                    end
                end
                if check then
                    getAchievement.done[#getAchievement.done+1] = index
                    PackageHandlers.sendServerHandler(obj, "RedDotAchievement", nil)
                end
            end
        end
        obj:setValue("Achievement", getAchievement)
    end

    return o
end)

return PlayerClass