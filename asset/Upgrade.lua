function self:onOpen(p)
    local Context = require "script_common.lbr.Context"
    local blockBtn = "gameres|asset/Texture/Gui/nutupgrade1(C).png"
    local unblockBtn = "gameres|asset/Texture/Gui/nutupgrade2(C).png"    
    self.Image.btnClose.onMouseClick = function() 
        self:close()
    end
    self.Image.info.onMouseClick = function() 
        self.InfoUpgrade:setVisible(true)
    end

    self.onMouseClick = function() 
        self.InfoUpgrade:setVisible(false)
    end    

    self.Image.Item:setImage("gameres|"..p.item.icon)
    local conut = 0
    PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (bp)
        local context_bp = Context:new(bp) 
        conut = context_bp:where("id","myplugin/V_Vortex"):sum("num")
        self.Image.amu:setText(conut.."/5")
        if conut >=5 then
            self.Image.Upgrate:setImage(unblockBtn)
        else
            self.Image.Upgrate:setImage(blockBtn)
        end
    end)

    self.Image.Upgrate.onMouseClick = function() 
        if conut >= 5 then
            PackageHandlers.sendClientHandler("Upgrate", {cellNum = p.item.cellNum}, function (rs,itemPlayer)
                if rs then
                    conut = conut - 5
                    self.Image.amu:setText(conut.."/5")
                    if conut >=5 then
                        self.Image.Upgrate:setImage(unblockBtn)
                    else
                        self.Image.Upgrate:setImage(blockBtn)
                    end
                    local context_item = Context:new("Item")
                    local item = context_item:where("id",itemPlayer.idItem):firstData()
                    p.item.id = item.id 
                    p.item.name = item.name 
                    p.item.icon = item.icon
                    self.Image.Item:setImage("gameres|"..p.item.icon)
                end
               
            end)
        end        
    end
end