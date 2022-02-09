function self:onOpen(p)    
    if p and p.onOpen then
        p.onOpen(self)
    end
    self.info.btnYes.onMouseClick = function() 
        if p and p.Yes ~= nil then
            p.Yes(self)
        end        
    end
    self.info.btnNo.onMouseClick = function() 
        if p and p.No ~= nil then
            p.No(self)            
        end
    end
    self.info.btnClose.onMouseClick = function() 
        if p and p.Close ~= nil then
            p.Close(self)
        end
        self:close()
    end
end