local function binarySearch(data,value)
    local left = 1
    local right = #data
    local mid
    while right >= left do
        mid = math.floor((left + right)/2)
        if value > data[mid] then
            left = mid + 1
        elseif value < data[mid] then
            right = mid - 1
        else
            return mid
        end
    end

    return left
end

local a = {}

for i = 1, 100, 1 do
    local rd = math.random(1,100)
    local index = binarySearch(a,rd)
    table.insert( a, index, rd )
end

for index, value in ipairs(a) do
    print(value)
end