function self:onOpen(p)
    self.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
    self.test:setText(Lang:toText(""))
end