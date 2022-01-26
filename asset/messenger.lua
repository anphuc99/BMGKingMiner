function self:onOpen(p)
  self.Text:setText(Lang:toText(p.Text))
  self.Text:setTextColours(Color3.fromRGB(p.Color.r,p.Color.g,p.Color.b))
  World.Timer(p.time or 80, function ()
        self:close()
        return false
  end)
end