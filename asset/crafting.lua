function self:onOpen(p)
  self.select.btnClose.onMouseClick = function ()
      self:close()
  end
  self.crafting.btnClose.onMouseClick = function ()
      self.crafting:setVisible(false)
  end
  local function selectClick(i)
    self.crafting:setVisible(true)
  end

  for i = 1, 6, 1 do
    self.select["item"..i].onMouseClick = function() 
      selectClick(i)
    end
    self.select["blur"..i].onMouseClick = function() 
      selectClick(i)
    end
  end
end