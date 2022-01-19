local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Votex = class()
Votex:create("Votex",function ()
    -- properties
	local o = Item:extend()
	local percentage


    -- method

    function o:getPercentage()
        return percentage
    end
    function o:setPercentage(_percentage)
        percentage = _percentage
    end
	return o    
end)

return Votex