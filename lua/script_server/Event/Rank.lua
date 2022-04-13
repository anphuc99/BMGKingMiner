local Gol = require "script_server.Golde_Valiable"
local cjson = require "cjson"
local function Rank (context,subKey,dataKey)
    DBHandler:getDataByUserId(subKey, dataKey, function (userId,jdata)
        if jdata == nil or jdata == "" then
            jdata = "[]"
        else
        end
        local data = cjson.decode(jdata)
        local check = false
        if #data <= 0 then
            data[#data+1] = {
                playerId = context.obj1.platformUserId,
                playerName = context.obj1.name,
                value = context.value
            }
            check = true
        else
            for index, value in ipairs(data) do
                if context.value > value then
                    table.insert( data, index, {
                        playerId = context.obj1.platformUserId,
                        playerName = context.obj1.name,
                        value = context.value
                    })
                    check = true
                    break
                end
            end
        end
        if not check then
            if #data > 1000 then
                table.remove( data, #data )
            end
            DBHandler:setData(subKey, dataKey, cjson.encode(data), true)
        end
    end)
end
Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "ADD_RANK_MINE", function(context)
    Rank(context,Gol.subKey.RankMine,Gol.dataKey.RankMine)
end)
Trigger.addHandler(Entity.GetCfg("myplugin/player1"), "ADD_RANK_LV", function(context)
    Rank(context,Gol.subKey.RankLV,Gol.dataKey.RankLV)
end)