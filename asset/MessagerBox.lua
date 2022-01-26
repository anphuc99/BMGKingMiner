function self:onOpen(p)
    self.info.Text:setText(Lang:toText(p.Text))
    self.info.btnYes.onMouseClick = function() 
        if p.Yes ~= nil then
            p.Yes(self)
        end
        self:close()
    end
    self.info.btnNo.onMouseClick = function() 
        if p.No ~= nil then
            p.No(self)
        end
        self:close()
    end
    self.info.btnClose.onMouseClick = function() 
        if p.Close ~= nil then
            p.Close(self)
        end
        self:close()
    end
end