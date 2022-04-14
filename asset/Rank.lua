local Context = require "script_common.lbr.Context"
local deepCopy = require "script_common.lbr.DeepCopyTable"
function self:onOpen(p)
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    PackageHandlers.sendClientHandler("getRank")
    PackageHandlers.registerClientHandler("getRank", function(player, data)
        local i = 1
        for ii = #data.sortDataMine,#data.sortDataMine - 1000,-1 do
            if i <= 50 then
                self.Image.Mine.VerticalLayout["User"..i].Rank:setText(i)
                self.Image.Mine.VerticalLayout["User"..i].Name:setText(data.sortDataMine[ii].name)
                self.Image.Mine.VerticalLayout["User"..i].num:setText(data.sortDataMine[ii].Mine)
                self.Image.Lv.VerticalLayout["User"..i].Rank:setText(i)
                self.Image.Lv.VerticalLayout["User"..i].Name:setText(data.sortDataLv[ii].name)
                self.Image.Lv.VerticalLayout["User"..i].num:setText(data.sortDataLv[ii].Lv)
            end
            if data.sortDataMine[ii].id == Me.platformUserId then
                self.Image.RankMine:setText(ii)         
            end
            if data.sortDataLv[ii].id == Me.platformUserId then
                self.Image.RankLv:setText(ii)                                           
            end
            i = i + 1
        end
        self.Image.numMine:setText(data.valuePlayer.Mine)                  
        self.Image.numLv:setText(data.valuePlayer.Lv)                  
    end)
end