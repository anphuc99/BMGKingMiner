local function e()
    return false
end
local rs,msg = pcall(function ()
    local a = e()
    if a == nil then
        a = true
    end
    print(a)
    return "babababa"
end)
local a = 2/0
print(rs)
print(msg)