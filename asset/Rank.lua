local Context = require "script_common.lbr.Context"
local deepCopy = require "script_common.lbr.DeepCopyTable"

function self:onOpen(p)
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    local getRank = Me:getValue("Rank") 
    if #getRank >= 3 then
        for key, value in pairs(getRank) do
            Lib.emitEvent(value.name,value)
        end
    else
        PackageHandlers.sendClientHandler("getRank")
    end
end