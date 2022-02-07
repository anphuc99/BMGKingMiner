function self:onOpen(p)
  self.Text:setText(Lang:toText(p.Text))
  if p.Color ~= nil then
    self.Text:setTextColours(Color3.fromRGB(p.Color.r,p.Color.g,p.Color.b))
  end  
  World.Timer(p.time or 80, function ()
        self:close()
        return false
  end)
end