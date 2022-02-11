local a = {1,2,3,4,5,6,6,8,9,0}
local i = 1
while i <=#a do
    print(load("return function(i) return i > 4 end")()(i))
    if load("return function(i) return i > 4 end")()(i) then
        table.remove( a, i )
    else        
        i = i + 1
    end
end
-- for key, value in pairs(a) do
--     if value == 4 then
--         table.remove( a, key )
--     end
-- end

for key, value in pairs(a) do
    print(key,value)
    print(_VERSION)
end

