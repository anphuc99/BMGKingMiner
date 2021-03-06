local class = require "script_common.lbr.Class"
local deepCopy = require("script_common.lbr.DeepCopyTable")
local Context = class()

Context:create("Context", function()
    local o = {}
    local data
    local dataSelect
    function o:__constructor(table)
        if type(table) == "string" then
            local data2 = require("script_common.database." .. table)
            data = deepCopy(data2)
            local function checkExtents(dt)
                if dt.option.extents ~= nil then
                    local parent = deepCopy(require(
                                                "script_common.database." ..
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
            o:where(col, "==", operator)
        else
            local dt = {}
            dt.Index = {}
            local check
            if operator == "find" then
                check = function (val1,val2) local a = string.find( val1,val2,1,true ) return a~= nil end
            else
                check = load("return function (val1,val2) return val1 "..operator.." val2 end")()    
            end
            
            for key, value2 in ipairs(dataSelect) do
                if check(value2[col],value) then
                    dt[#dt + 1] = dataSelect[key]
                end
            end            
            dt.option = dataSelect.option            
            dataSelect = dt
        end
        return o
    end
    function o:sum(prop)
        local sum = 0
        for key, value in pairs(dataSelect) do
            if type(key) == "number" then
                sum = sum + value[prop]
            end            
        end
        dataSelect = data
        return sum
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

    function o:orderBy(prop)        
        local function quickSort(array, le, ri)
            if ri-le < 1 then 
                return array
            end
        
            local left = le
            local right =  ri
            local pivot = math.ceil((le+ri)/2)
        
            array[pivot], array[right] = array[right], array[pivot]
        
            for i = le, ri do
                if array[i][prop] < array[right][prop] then
                    array[left], array[i] = array[i], array[left]
        
                    left = left + 1
                end
            end
        
            array[left], array[right] = array[right], array[left]
        
            quickSort(array, 1, left-1)
            quickSort(array, left +1, ri)
        
            return array
        end
        quickSort(dataSelect,1,#dataSelect)
        return o
    end

    function o:orderByDesc(prop)        
        local function quickSort(array, le, ri)
            if ri-le < 1 then 
                return array
            end
        
            local left = le
            local right =  ri
            local pivot = math.ceil((le+ri)/2)
        
            array[pivot], array[right] = array[right], array[pivot]
        
            for i = le, ri do
                if array[i][prop] > array[right][prop] then
                    array[left], array[i] = array[i], array[left]
        
                    left = left + 1
                end
            end
        
            array[left], array[right] = array[right], array[left]
        
            quickSort(array, 1, left-1)
            quickSort(array, left +1, ri)
        
            return array
        end
        quickSort(dataSelect,1,#dataSelect)
        return o
    end

    -- t??m ki???m danh s??ch y??u c???u ph???i s???p x???p t??? tr?????c
    function o:findList(col,value)
        local left = 1
        local right = #data
        local mid
        while right >= left do
            mid = math.floor((left + right)/2)
            if value > data[mid][col] then
                left = mid + 1
            elseif value < data[mid][col] then
                right = mid - 1
            else
                return data[mid]
            end
        end

        return left
    end

    return o
end)

return Context
