function self:onOpen(p)
    self.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
end