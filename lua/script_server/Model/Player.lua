local class = require "script_server.lbr.Class"
local Context = require "script_server.lbr.Context"
local Gol = require "script_server.Golde_Valiable"
local PlayerClass = class()
PlayerClass:create("Player",function ()
    local o = {}
    local id
    local isMining = false
    local signal = 5
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
                        o:endMine(MaterialModel)
                        MaObj:kill(obj, "hit")
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
        
    end
    return o
end)

return PlayerClass