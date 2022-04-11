local cjson = require "cjson"
local function deepcopy(orig)
    local copy = {}
    for key, value in pairs(orig) do
        if tonumber(key) then
            key = math.floor(tonumber(key))
        end
        if type(value) == "table" then
            copy[key] = deepcopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

return deepcopy