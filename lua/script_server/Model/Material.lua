local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Material = class()
Material:create("Material",function ()
    -- properties
	local o = Item:extend()
	local level
	local Time_retrieval
	local stiffness
	local blockId


    -- method

    function o:getLevel()
        return level
    end
    function o:setLevel(_level)
        level = _level
    end

    function o:getTime_retrieval()
        return Time_retrieval
    end
    function o:setTime_retrieval(_Time_retrieval)
        Time_retrieval = _Time_retrieval
    end

    function o:getStiffness()
        return stiffness
    end
    function o:setStiffness(_stiffness)
        stiffness = _stiffness
    end

    function o:getBlockId()
        return blockId
    end
    function o:setBlockId(_blockId)
        blockId = _blockId
    end
	return o    
end)

return Material