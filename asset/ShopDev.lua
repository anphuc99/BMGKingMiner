function self:onOpen(p)
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    local function onBtnClick(btn)
        local numGcube = math.floor(tonumber(btn:getText()))
        PackageHandlers.sendClientHandler("buyCoin", {Gcube = numGcube}, nil)
    end
    self.Image.ScrollableView.GridView.Image.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image.Button) end
    self.Image.ScrollableView.GridView.Image1.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image1.Button) end
    self.Image.ScrollableView.GridView.Image2.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image2.Button) end
    self.Image.ScrollableView.GridView.Image3.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image3.Button) end
    self.Image.ScrollableView.GridView.Image4.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image4.Button) end
    self.Image.ScrollableView.GridView.Image5.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image5.Button) end
    self.Image.ScrollableView.GridView.Image6.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image6.Button) end
    self.Image.ScrollableView.GridView.Image7.Button.onMouseClick = function() onBtnClick(self.Image.ScrollableView.GridView.Image7.Button) end
end