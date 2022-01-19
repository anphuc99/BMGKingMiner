local class = require "script_server.lbr.Class"
local Player = class()
Player:create("Player",function ()
    local o = {}
    local id
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
        return World:getObject(id)
    end
    function o:beginMine()
        -- truyen den ui
        -- chay thoi gian dao
        local itemHand = o:getObj():getHandItem()
        
    end
    return o
end)