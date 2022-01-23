local class = require "script_server.lbr.Class"
local deepCopy = require("script_server.lbr.DeepCopyTable")
local Context = class()

Context:create("Context", function()
    local o = {}
    local data
    local dataSelect
    function o:__constructor(table)
        if type(table) == "string" then
            local data2 = require("script_server.database." .. table)
            data = deepCopy(data2)
            local function checkExtents(dt)
                if dt.option.extents ~= nil then
                    local parent = deepCopy(require(
                                                "script_server.database." ..
                                                    dt.option.extents))
                    for key, value in pairs(data) do
                        if (key ~= "option") then
                            for key2, value2 in pairs(parent) do
                                if (key ~= "option") then
                                    if (value2[dt.option.primaryKey] ==
                                        value[dt.option.primaryKey]) then
                                        for key3, value3 in pairs(value2) do
                                            data[key][key3] = value3
                                        end
                                    end
                                end

                            end
                        end
                    end
                    checkExtents(parent)
                end
            end
            checkExtents(data)
        elseif type(table) == "table" then
            data = table
        end
        dataSelect = data
        return o
    end

    function o:where(col, operator, value)
        if value == nil then
            o:where(col, "=", operator)
        else
            local dt = {}
            dt.Index = {}
            if operator == "=" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) == "number" then
                        if value2[col] == value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            elseif operator == ">" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) > "number" then
                        if value2[col] > value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            elseif operator == "<" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) < "number" then
                        if value2[col] < value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            elseif operator == ">=" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) >= "number" then
                        if value2[col] >= value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            elseif operator == "<=" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) <= "number" then
                        if value2[col] <= value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            elseif operator == "~=" then
                for key, value2 in pairs(dataSelect) do
                    if type(key) ~= "number" then
                        if value2[col] ~= value then
                            dt[#dt + 1] = dataSelect[key]
                        end
                    end
                end
            end
            dt.option = dataSelect.option            
            dataSelect = dt
            print(Lib.pv(dataSelect))
        end
        return o
    end
    function o:getData() 
        local dt = dataSelect
        dataSelect = data
        return dt 
    end
    function o:firstData()
        local dt = dataSelect[1]
        dataSelect = data
        return dt
    end
    return o
end)

return Context
