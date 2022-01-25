function self:onOpen(p)
  local BUS_crafting = require "script_client.Bus.Crafting"
  local Context = require "script_common.lbr.Context"
  local recId = {}
  local Backpack
  local btnCrafEn = "gameres|asset/Texture/Gui/NutCraft2(C).png"
  local btnCrafdis = "gameres|asset/Texture/Gui/NutCraft1(C.png"
  local postion = 0
  self.select.btnClose.onMouseClick = function ()
      self:close()
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
  end
  local function selectClick(i)
    self.crafting:setVisible(true)
    print(Lib.pv(recId))
    local deCraf = BUS_crafting:getDetailCraft(recId[i].recId,Backpack)
    local img = self.select["item"..i]:getProperty("Image")
    self.crafting.ItemCf:setImage(img)
    local btnEn = true
    for key, value in pairs(deCraf) do
      self.crafting["item"..key]:setVisible(true)
      self.crafting["item"..key]:setImage(value.icon)
      local text = value.BPnum.."/"..value.recNum 
      self.crafting["Text"..key]:setText(text)
      self.crafting["Text"..key]:setVisible(true)
      if value.recNum > value.BPnum then
        btnEn = false
      end
    end
    if btnEn then
      self.crafting.btnCraft:setImage(btnCrafEn)
    else
      self.crafting.btnCraft:setImage(btnCrafdis)      
    end
    self.select["blur"..i]:setVisible(not btnEn)
    postion = i
  end
  self.crafting.btnCraft.onMouseClick = function() 
    if recId[postion] and recId[postion].show then
      UI:openWindow("MessagerBox",nil,nil,{
        Text = "Are you ready crafting?",
        Yes = function ()
          PackageHandlers.sendClientHandler("crafting", {recId = recId[postion].recId}, function (res)
            if res.rs then
              local icon = Context:new("Item"):where("id",res.item):firstData()          
              PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (BP)            
                Backpack = BP
                print(Lib.pv(Backpack))
                selectClick(postion)
                self.crafting.ItemCf:setImage("gameres|"..icon.icon)
              end)              
            end
          end)
        end
      })
      
    end
  end

  for i = 1, 6, 1 do
    self.select["item"..i]:setVisible(false)
    self.select["item"..i].onMouseClick = function() 
      selectClick(i)
    end
    self.select["blur"..i].onMouseClick = function() 
      selectClick(i)
    end
  end

  PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (BP)
    Backpack = BP
    local item = BUS_crafting:getItemCraft(BP)
    for key, value in pairs(item) do      
      recId[key] = {}
      recId[key].recId = value.rarity
      recId[key].show = value.show
      self.select["item"..key]:setVisible(true)
      self.select["item"..key]:setImage("gameres|"..value.icon)
      self.select["blur"..key]:setVisible(not value.show)
    end
  end)
end