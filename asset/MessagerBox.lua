function self:onOpen(p)
    self.info.Text:setText(Lang:toText(p.Text or ""))
    if p and p.onOpen then
        p.onOpen(self)
    end
    self.info.TextBox:setVisible((p and (p.TextBox or false)) or false)
    self.info.btnYes.onMouseClick = function() 
        local rs = true
        if p and p.Yes ~= nil then
            rs = p.Yes(self)
            if rs == nil then
                rs = true
            end 
            
        end
        if rs then
            self:close()
        end
        
    end
    self.info.btnNo.onMouseClick = function() 
        local rs = true
        if p and p.No ~= nil then
            rs = p.No(self)
            if rs == nil then
                rs = true
            end 
            
        end
        if rs then
            self:close()
        end
    end
    self.info.btnClose.onMouseClick = function() 
        if p and p.Close ~= nil then
            p.Close(self)
        end
        self:close()
    end
end