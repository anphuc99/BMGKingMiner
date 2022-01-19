local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Material = class()
Material:create("Material",function ()
    local o,super = Item:extend()
    -- properties
	local level
	local Time_retrieval
	local stiffness
	local blockId

    function o:__constructor(data)
        -- constructor
		o:setId(data.id)
		o:setName(data.name)
		o:setIcon(data.icon)
		o:setTypeItem(data.typeItem)
		level = data.level
		Time_retrieval = data.Time_retrieval
		stiffness = data.stiffness
		blockId = data.blockId
        
    end
    -- method

    function o:getId()
        return id
    end
    function o:setId(_id)
        id = _id
    end

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