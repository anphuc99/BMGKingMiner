local Context = require "script_common.lbr.Context"
local Recipe = require "script_common.database.recipe"
local crafting = {}
-- lấy các vật phẩm hiển thị công thức
function crafting:getItemCraft(BP)
    local data = {}
    for key, value in pairs(Recipe) do
        if type(key) == "number" then
            local context_equipment = Context:new("Equipment")
            local equipment = context_equipment:where("recipe",value.id):where("rarity",1):firstData()
            local show = true
            for key2, value2 in pairs(value.Material) do                
                local context_BP = Context:new(BP)
                local cBP = context_BP:where("id",value2.id):sum("num")
                if cBP < value2.num then
                    show = false
                    break
                end
            end
            equipment.show = show     
            data[#data+1] = equipment       
        end
    end
    return data
end
-- lấy chi tiết công thức
function crafting:getDetailCraft(recipeId,BP)
    local data = {}
    local context_recipe = Context:new("recipe")
    local rec = context_recipe:where("id",recipeId):firstData()
    for key, value in pairs(rec.Material) do
        if type(key) == "number" then
            local context_BP = Context:new(BP)
            local cBP = context_BP:where("id",value.id):sum("num")
            local context_item = Context:new("Item")
            local item = context_item:where("id",value.id):firstData()           
            item.BPnum = cBP 
            item.recNum = value.num
            data[#data+1] = item
        end        
    end
    local context_equipment = Context:new("Equipment")
    local Equipment = context_equipment:where("recipe",recipeId):orderBy("rarity"):getData()
    return data,Equipment
end

return crafting