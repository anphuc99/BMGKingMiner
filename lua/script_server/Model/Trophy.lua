local class = require "script_server.lbr.Class"
local Equipment = require "script_server.Model.Equipment"
local Trophy = class()
Trophy:create("Trophy",function ()
    -- properties
	local o = Equipment:extend()
	local mineSpeed
    -- method
    function o:getMineSpeed()
        return mineSpeed
    end
    function o:setMineSpeed(_mineSpeed)
        mineSpeed = _mineSpeed
    end
	return o    
end)

return Trophy