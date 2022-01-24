function self:onOpen(p)
    self.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
    -- self.test:setText(Lang:toText(""))
    self.Forge.onMouseClick = function() 
        UI:openWindow("crafting")
    end
end