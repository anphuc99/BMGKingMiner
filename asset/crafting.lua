function self:onOpen(p)
  local rs,msg = pcall(function ()
      local BUS_crafting = require "script_client.Bus.Crafting"
    local Context = require "script_common.lbr.Context"
    local recId = {}
    local Backpack
    local btnCrafEn = "gameres|asset/Texture/Gui/NutCraft2(C).png"
    local btnCrafdis = "gameres|asset/Texture/Gui/NutCraft1(C.png"
    local postion = 0
    local createItem
    local selectClick
    self.select.btnClose.onMouseClick = function ()
        self:close()
    end
    createItem = function (key)
      local item = UI:createStaticImage("item" .. key)
      item:setImage("gameres|asset/Texture/Gui/Bảng Item craft1.png")
      item:setSize(UDim2.new(0, 183.56, 0, 183.56))
      local name = UI:createStaticImage("name")
      name:setProperty("MousePassThroughEnabled", "true")
      name:setSize(UDim2.new(0, 170, 0, 30))
      name:setPosition(UDim2.new(0, 10, 0, 20))
      item:addChild(name)
      local icon = UI:createStaticImage("icon")
      icon:setPosition(UDim2.new(0, 48.95, 0, 57.39))
      icon:setProperty("MousePassThroughEnabled", "true")
      icon:setSize(UDim2.new(0, 86.01, 0, 86.01))    
      item:addChild(icon)
      local blur = UI:createStaticImage("blur")
      blur:setImage("gameres|asset/Texture/Gui/Làm mờ(C).png")
      blur:setPosition(UDim2.new(0, 45.91, 0, 53.48))
      blur:setSize(UDim2.new(0, 91.73, 0, 96.17))
      blur:setProperty("MousePassThroughEnabled", "true")
      item:addChild(blur)
      item.onMouseClick = function() selectClick(key) end
      self.select.ScrollableView.GridView:addChild(item)
    end
    self.crafting.btnClose.onMouseClick = function ()
        self.crafting.item1:setVisible(false)
        self.crafting.item2:setVisible(false)
        self.crafting.item3:setVisible(false)
        self.crafting.item4:setVisible(false)
        self.crafting.item5:setVisible(false)
        self.crafting.Text1:setVisible(false)
        self.crafting.Text2:setVisible(false)
        self.crafting.Text3:setVisible(false)
        self.crafting.Text4:setVisible(false)
        self.crafting.Text5:setVisible(false)
        self.crafting:setVisible(false)
        self.select:setVisible(true)
    end
    selectClick = function(i)
      
      self.select:setVisible(false)
      self.crafting:setVisible(true)
      local deCraf,item = BUS_crafting:getDetailCraft(recId[i].recId,Backpack)
      local img = self.select.ScrollableView.GridView["item"..i].icon:getProperty("Image")
      self.crafting.ItemCf:setImage(img)
      local btnEn = true
      for key, value in ipairs(deCraf) do
        self.crafting["item"..key]:setVisible(true)
        self.crafting["item"..key]:setImage(value.icon)
        local text = value.BPnum.."/"..value.recNum 
        self.crafting["Text"..key]:setText(text)
        self.crafting["Text"..key]:setVisible(true)
        if value.recNum > value.BPnum then
          btnEn = false
        end
      end
      local text = {}
      for index, value in ipairs(item) do      
        text[#text+1] = value.percentage.."% "..Lang:toText(value.name)
      end
      self.crafting.txtpercent:setText(table.concat(text,", "))
      if btnEn then
        self.crafting.btnCraft:setImage(btnCrafEn)
      else
        self.crafting.btnCraft:setImage(btnCrafdis)      
      end
      self.select.ScrollableView.GridView["item"..i].blur:setVisible(not btnEn)
      postion = i
    end
    self.crafting.btnCraft.onMouseClick = function() 
      if recId[postion] and recId[postion].show then
        UI:openWindow("MessagerBox",nil,nil,{
          Text = {"messager_crafting"},
          Yes = function ()
            PackageHandlers.sendClientHandler("crafting", {recId = recId[postion].recId}, function (res)
              if res.rs then
                local icon = Context:new("Item"):where("id",res.item):firstData()          
                PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (BP)            
                  Backpack = BP
                  selectClick(postion)
                  self.crafting.ItemCf:setImage("gameres|"..icon.icon)
                end)              
              end
            end)
          end
        })
        
      end
    end

    -- for i = 1, 6, 1 do
    --   self.select["item"..i]:setVisible(false)
    --   self.select["item"..i].onMouseClick = function() 
    --     selectClick(i)
    --   end
    --   self.select["blur"..i].onMouseClick = function() 
    --     selectClick(i)
    --   end
    -- end

    PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (BP)
      Backpack = BP
      local item = BUS_crafting:getItemCraft(BP)
      for key, value in pairs(item) do      
        if value.show then
          recId[key] = {}
          recId[key].recId = value.recipe
          recId[key].show = value.show      
          createItem(key)
          self.select.ScrollableView.GridView["item"..key].icon:setImage("gameres|"..value.icon)
          self.select.ScrollableView.GridView["item"..key].name:setImage("gameres|asset/Texture/Gui/name"..value.level..".png")
          self.select.ScrollableView.GridView["item"..key].blur:setVisible(not value.show)
        end
      end
      for key, value in pairs(item) do      
        if not value.show then
          recId[key] = {}
          recId[key].recId = value.recipe
          recId[key].show = value.show      
          createItem(key)
          self.select.ScrollableView.GridView["item"..key].icon:setImage("gameres|"..value.icon)
          self.select.ScrollableView.GridView["item"..key].name:setImage("gameres|asset/Texture/Gui/name"..value.level..".png")
          self.select.ScrollableView.GridView["item"..key].blur:setVisible(not value.show)
        end
      end
    end)
  end)
  if not rs then
    --UI:openWindow("messenger",nil,nil,{Text = {msg}})
    require "script_client.senTip".sendTip({Text = {msg}})
  end
end