local class = require "script_server.lbr.Class"
local Item = require "script_server.Model.Item"
local Material = class()
Material:create("Material",function ()
    local o,super = Item:extend()
    -- properties
	local level
	local Time_retrieval
	local stiffness
	local entityId
    local objID

    function o:__constructor(data,_objID)
        -- constructor
		o:setId(data.id)
		o:setName(data.name)
		o:setIcon(data.icon)
		o:setTypeItem(data.typeItem)
		level = data.level
		Time_retrieval = data.Time_retrieval
		stiffness = data.stiffness
		entityId = data.entityId
        objID = _objID
        
    end
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

    function o:getEntityId()
        return entityId
    end
    function o:setEntityId(_entityId)
        entityId = _entityId
    end

    function o:getObjID()
        return objID
    end
    function o:setObjID(_objID)
        objID = _objID
    end

    function o:getObj()
        return World.CurWorld:getObject(objID)
    end

    return o
end)

return Material