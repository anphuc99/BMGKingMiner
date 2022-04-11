function self:onOpen(p)
    self.Image1.onMouseClick = function() 
        self:close()
    end
    self.Image1.Image:setImage("gameres|asset/idCard/Note/ID_card"..p.idCard..".png")
    self.Image1.Image.Text:setText(Lang:toText({"messeger_NotEnoughIdCard"}))
end