local dataSelect = {
    {a = 1,b ="a"},
    {a = 3,b ="b"},
    {a = 6,b ="c"},
    {a = 1,b ="a"},
    {a = 9,b ="d"},
}
local function orderBy(prop)        
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
end
orderBy("a")

for key, value in pairs(dataSelect) do
    print(value.a,value.b)
end