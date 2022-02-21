function self:onOpen(p)
    local Context = require "script_common.lbr.Context"
    local blockBtn = "gameres|asset/Texture/Gui/nutupgrade1(C).png"
    local unblockBtn = "gameres|asset/Texture/Gui/nutupgrade2(C).png"    
    local split = require "script_common.lbr.split"
    local Type = "myplugin/P_cup"
    local lv = 0
    self.Image.btnClose.onMouseClick = function() 
        self:close()
    end
    self.Image.info.onMouseClick = function() 
        self.Info:setVisible(true)
        self.Blur:setVisible(true)
    end

    self.Blur.onMouseClick = function() 
        self.Info:setVisible(false)
        self.Blur:setVisible(false)
    end    

    local conut = 0
    -- lấy cúp
    local function getCup ()
        PackageHandlers.sendClientHandler("getCup", {cup = Type}, function (cup)
            self.Image.Item:setImage("gameres|"..cup.icon)
            print(Lib.pv(cup))
            lv = tonumber(split(cup.id,"_")[3])        
        end)
         -- lấy vortex        
        PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (bp)       
            local context_bp = Context:new(bp) 
            conut = context_bp:where("id","myplugin/V_Vortex"):sum("num")
            self.Image.amu:setText(conut.."/5")
            if conut >=5 and lv <10 then
                self.Image.Upgrate:setImage(unblockBtn)
            else
                self.Image.Upgrate:setImage(blockBtn)
            end
        end)
    end
    getCup()
    self.Image.Cup.onMouseClick = function ()
        Type = "myplugin/P_cup"
        getCup()
        self.Image.Cup:setProperty("Disabled", "true")
        self.Image.Riu:setProperty("Disabled", "false")
    end
    self.Image.Riu.onMouseClick = function() 
        Type = "myplugin/A_riu"
        getCup()       
        self.Image.Cup:setProperty("Disabled", "false")
        self.Image.Riu:setProperty("Disabled", "true") 
    end   

    self.Image.Upgrate.onMouseClick = function() 
        if conut >= 5 then
            PackageHandlers.sendClientHandler("Upgrate", {cup = Type}, function (rs,itemPlayer)
                if rs then
                    conut = conut - 5
                    self.Image.amu:setText(conut.."/5")
                    lv = tonumber(split(itemPlayer.idItem,"_")[3])
                    if conut >=5 and lv < 10 then
                        self.Image.Upgrate:setImage(unblockBtn)
                    else
                        self.Image.Upgrate:setImage(blockBtn)
                    end
                    local context_item = Context:new("Item")
                    local item = context_item:where("id",itemPlayer.idItem):firstData()
                    self.Image.Item:setImage("gameres|"..item.icon)
                end
               
            end)
        end        
    end    
end