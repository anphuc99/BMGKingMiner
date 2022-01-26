function self:onOpen(p)
    self.Image.btnClose.onMouseClick = function() 
        self:close()
    end
    self.Image.info.onMouseClick = function() 
        self.InfoUpgrade:setVisible(true)
    end

    self.onMouseClick = function() 
        self.InfoUpgrade:setVisible(false)
    end
end