local Context = require "script_common.lbr.Context"
local deepCopy = require "script_common.lbr.DeepCopyTable"

function self:onOpen(p)
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    PackageHandlers.sendClientHandler("getRank")
    PackageHandlers.registerClientHandler("getRank", function(player, data)
        Lib.pv(data,nil,"lonlonlonlon")
        local id = {}
        local UesrId = {}
        for i = 1, #data.DataMine, 1 do
            id[data.DataMine[i].key] = true
            id[data.DataLv[i].key] = true
        end

        for key, value in pairs(id) do
            UesrId[#UesrId+1] = math.floor(tonumber(key))
        end
        Lib.pv(UesrId)
        if data.Local then
            for i = 1,#data.DataMine, 1 do
                local user = data.Local[math.floor(tonumber(data.DataLv[i].key))]
                self.Image.Mine.VerticalLayout["User"..i].Rank:setText(i)
                self.Image.Mine.VerticalLayout["User"..i].Name:setText(user.name)
                self.Image.Mine.VerticalLayout["User"..i].num:setText(data.DataMine[i].value)
                local user = data.Local[math.floor(tonumber(data.DataLv[i].key))]
                self.Image.Lv.VerticalLayout["User"..i].Rank:setText(i)
                self.Image.Lv.VerticalLayout["User"..i].Name:setText(user.name)
                self.Image.Lv.VerticalLayout["User"..i].num:setText(data.DataLv[i].value)
            end
        else
            UserInfoCache.LoadCacheByUserIds(UesrId, function()
                print("open rank")
                for i = 1,#data.DataMine, 1 do
                    local user = UserInfoCache.GetCache(math.floor(tonumber(data.DataMine[i].key))) or {}
                    self.Image.Mine.VerticalLayout["User"..i].Rank:setText(i)
                    self.Image.Mine.VerticalLayout["User"..i].Name:setText(user.name)
                    self.Image.Mine.VerticalLayout["User"..i].num:setText(data.DataMine[i].value)
                    local user = UserInfoCache.GetCache(math.floor(tonumber(data.DataLv[i].key))) or {}
                    self.Image.Lv.VerticalLayout["User"..i].Rank:setText(i)
                    self.Image.Lv.VerticalLayout["User"..i].Name:setText(user.name)
                    self.Image.Lv.VerticalLayout["User"..i].num:setText(data.DataLv[i].value)
                end
            end)             
        end
        if data.MyRank.Mine <= 1000 then
            self.Image.RankMine:setText(data.MyRank.Mine)                     
        end
        if data.MyRank.Lv <= 1000 then
            self.Image.RankLv:setText(data.MyRank.Lv)                                                       
        end
        self.Image.numMine:setText(data.valuePlayer.Mine)                  
        self.Image.numLv:setText(data.valuePlayer.Lv)     
    end)
end