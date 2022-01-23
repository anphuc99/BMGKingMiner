function self:onOpen(p)
  self.Text:setText(p.Text)
  self.Text:setTextColours(Color3.fromRGB(p.Color.r,p.Color.g,p.Color.b))
  World.Timer(80, function ()
        self:close()
        return false
  end)
end