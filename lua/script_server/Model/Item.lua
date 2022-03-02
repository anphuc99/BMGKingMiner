local class = require "script_common.lbr.Class"
local Context = require "script_common.lbr.Context"
local positionItem = require "script_common.positionItem"
local TypeItem = require "script_common.typeItem"
local messenger = require "script_server.Helper.SendMesseger"
local Gol = require "script_server.Golde_Valiable"
-- local lang = require "script_server.lbr.lang"
local Item = class()
Item:create("Item", function()
    local o = {}
    -- properties
    local id
    local name
    local icon
    local typeItem

    function o:__constructor(data)
        -- constructor       
        id = data.id
        name = data.name
        icon = data.icon
        typeItem = data.typeItem
    end
    -- method

    function o:getId() return id end
    function o:setId(_id) id = _id end

    function o:getName() return name end
    function o:setName(_name) name = _name end

    function o:getIcon() return icon end
    function o:setIcon(_icon) icon = _icon end

    function o:getTypeItem() return typeItem end
    function o:setTypeItem(_typeItem) typeItem = _typeItem end

    function o:addToPlayer(Player,num)
        num = num or 1
        local lv = 0
        if typeItem == TypeItem.Equipment then
            lv = 1
        end
        local idPlayer = Player:getValue("Player")
        local playerItem = Player:getValue("PlayerItem")
        if playerItem == nil then
            Player.addValueDef("PlayerItem", {
                {idPlayer = idPlayer.id, idItem = id, num = num, cellNum = 1, position = positionItem.balo, lv = lv}
            }, true, true, true, false)
        else
            local context_player = Context:new(playerItem)
            local checkItem = context_player:where("position",positionItem.balo):where("idItem", id):firstData()
            if checkItem ~= nil then
                checkItem.num = checkItem.num + num
                Player:setValue("PlayerItem", playerItem)                
            else
                local rs = false
                for i = 1, idPlayer.balo, 1 do
                    local checkCellNum = context_player:where("position",positionItem.balo):where("cellNum", i):firstData()
                    if checkCellNum == nil then
                        playerItem[#playerItem + 1] = {
                            idPlayer = idPlayer.id,
                            idItem = id,
                            num = num,
                            cellNum = i,
                            position = positionItem.balo,
                            lv = lv
                        }
                        Player:setValue("PlayerItem", playerItem)
                        rs = true
                        break
                    end
                end
                if not rs then
                    --local language = Gol.Player[Player.objID]:getLanguage()
                    --print(language)
                    messenger(Player,{Text = {"messeger_FullBP",1}, Color = {r = 255, g = 0, b = 0}})                                    
                end
                return rs
            end
        end
        return true
    end
    return o
end)

return Item
