local Context = require "script_common.lbr.Context"
local positionItem = require "script_common.positionItem"
local typeEquipment = require "script_common.EquimentType"
local objHopLe = {}
World.Timer(2, function ()
    for key, value in pairs(Lib.MaterialObj) do
        pcall(function ()
            local entity = World.CurWorld:getObject(value.objid)
            if not entity:isDead() then
                local plaPos = Me:curBlockPos()
                local MaPos = entity:curBlockPos()
                local distance = math.abs(math.sqrt((plaPos.x - MaPos.x)^2+(plaPos.y - MaPos.y)^2+(plaPos.z - MaPos.z)^2))
                if distance > 2 then                    
                    for index, value2 in ipairs(objHopLe) do
                        if value2.objid == value.objid then
                            table.remove( objHopLe, index )
                        end
                    end
                    return
                end
                local sceneArgs = {
                    position = {x = 0, y = 2.5, z = 0},
                    rotation = {x = 0, y = 0, z = 0},
                    width = 0.5,
                    height = 0.5,
                    isCullBack = false,
                    objID = Me.objID,
                    flags = 4
                }
                objHopLe[#objHopLe+1] = value                

            else
                for index, value2 in ipairs(objHopLe) do
                    if value2.objid == value.objid then
                        table.remove( objHopLe, index )
                    end
                end
            end
        end) 
    end   
    if #objHopLe > 0 then
        local value = objHopLe[1]
        if not UI:isOpenWindow("GoHome") then
            local window = UI:openWindow("Piaxe", nil,nil, value)
            if value.type == "Mar" then
                window.Mine:setImage("gameres|asset/Texture/Gui/Nút khoáng.png")
            elseif value.type == "Tree" then
                window.Mine:setImage("gameres|asset/Texture/Gui/Nút gỗ.png")
            end
        else
            objHopLe = {}
        end
    else
        UI:closeWindow("Piaxe")
    end 
    return true 
end)