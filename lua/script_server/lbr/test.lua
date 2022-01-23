local a = {1,2,3,4,5,6}

for key, value in pairs(a) do
    if key == 3 then
        break
    end
    print(value)
end