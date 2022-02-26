function self:onOpen(p)
    local conpareDate = require "script_common.lbr.compareDate"
    local dot = 0
    local function setDot(_dot)
        dot = _dot
        if dot == 0 then
            local win = UI:isOpenWindow("main")
            win.Option.Dally.dot:setVisible(false)
        end
    end
    if p.lastRollUp7 == nil or conpareDate(p.lastRollUp7,os.time()) >=1 then
        self.Image["gift"..(((p.countRollUp7)%7)+1)].dot:setVisible(true)
        setDot(dot + 1)
    end
    if p.lastRollUp28 == nil or conpareDate(p.lastRollUp28,os.time()) >=1 then
        self.Image.ScrollableView.VerticalLayout["login"..(((p.countRollUp28)%28)+1)].gitf.dot:setVisible(true)
        setDot(dot + 1)
    end
    self.Image.Image1.LoginBar:setStepSize(1/6)
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    -- điểm danh 7 ngày
    for i = 1,(p.countRollUp7%7),1 do
        self.Image["day"..i]:setProperty("Disabled", "true")
        self.Image["gift"..i].tick:setVisible(true)
        if i ~= 1 then
            self.Image.Image1.LoginBar:step()
        end
        
    end    
    self.Image["gift"..(((p.countRollUp7)%7)+1)].onMouseClick = function() 
        PackageHandlers.sendClientHandler("RollUp", {rollUp = 7}, function (rs)
            if rs then
                self.Image["day"..(((p.countRollUp7)%7)+1)]:setProperty("Disabled", "true")
                self.Image["gift"..(((p.countRollUp7)%7)+1)].tick:setVisible(true)
                if (((p.countRollUp7)%7)+1) ~= 1 then
                    self.Image.Image1.LoginBar:step()
                end
                self.Image["gift"..(((p.countRollUp7)%7)+1)].dot:setVisible(false)
                setDot(dot - 1)
            end            
        end)
    end
    -- điểm danh 28 ngày
    for i = 1,(p.countRollUp28%28),1 do
        self.Image.ScrollableView.VerticalLayout["login"..i].gitf.tick:setVisible(true)      
        self.Image.ScrollableView.VerticalLayout["login"..i].ProgressBar:setProgress(1)        
    end  
    self.Image.ScrollableView.VerticalLayout["login"..(((p.countRollUp28)%28)+1)].onMouseClick = function() 
        PackageHandlers.sendClientHandler("RollUp", {rollUp = 28}, function (rs)
            if rs then
                self.Image.ScrollableView.VerticalLayout["login"..(((p.countRollUp28)%28)+1)].gitf.tick:setVisible(true)               
                self.Image.ScrollableView.VerticalLayout["login"..(((p.countRollUp28)%28)+1)].ProgressBar:setProgress(1)  
                self.Image.ScrollableView.VerticalLayout["login"..(((p.countRollUp28)%28)+1)].gitf.dot:setVisible(false)
                setDot(dot - 1)      
            end            
        end)
    end
    self.Image.achievement.onMouseClick = function() 
        UI:openWindow("Achievement")
        self:close()
    end
end