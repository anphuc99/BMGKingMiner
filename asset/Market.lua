function self:onOpen(p)
    local BUS_Market = require "script_client.Bus.Market"
    local tableFeal = "gameres|asset/Texture/Gui/Bảng trống1(2000).png"
    local tableBlack = "gameres|asset/Texture/Gui/Bảng trống2(2000).png"
    local market = {}
    local function ProductClick(i)
        UI:openWindow("MessagerBox",nil,nil,{
            Text = {"notify_sell",market[i].name},
            Yes = function ()
                PackageHandlers.sendClientHandler("sellFleaMarket", market[i])
            end
        })        
    end
    local function createProduct(key)
        local product = UI:createStaticImage("Product"..key)
        product:setImage("gameres|asset/Texture/Gui/Khung item (1500).png")
        product:setProperty("Size", "{{0,278.76},{0,109.55}}")   
        local item = UI:createStaticImage("item")
        item:setProperty("Position", "{{0,13.05},{0,10.89}}")
        item:setProperty("Size", "{{0,87.15},{0,88.29}}")        
        item:setProperty("MousePassThroughEnabled", "true")        
        product:addChild(item)
        local name = UI:createStaticText("name")
        name:setProperty("Position", "{{0,120.64},{0,2.73}}")
        name:setProperty("Size", "{{0,139.17},{0,40.04}}")
        name:setProperty("VerticalAlignment", "2")
        name:setProperty("MousePassThroughEnabled", "true")
        name:setTextColours(Color3.new(0,0,0))        
        product:addChild(name)
        local conut = UI:createStaticText("count")
        conut:setProperty("Position", "{{0,216.57},{0,47.55}}")
        conut:setProperty("Size", "{{0,35.08},{0,20.12}}")
        conut:setProperty("MousePassThroughEnabled", "true")
        conut:setTextColours(Color3.new(0,0,0))
        product:addChild(conut)
        local num = UI:createStaticText("num")
        num:setProperty("Position", "{{0,155.67},{0,74.70}}")
        num:setProperty("Size", "{{0,103.73},{0,23.91}}")
        num:setProperty("MousePassThroughEnabled", "true")
        num:setTextColours(Color3.new(0,0,0))
        product:addChild(num)
        product.onMouseClick = function() ProductClick(key) end
        self.Image.ScrollableView.GridView:addChild(product)
    end
    local function setMarket(mk)
        if mk == 1 then
            market = BUS_Market:getFleaMaket(p.NPC)
        end
        for key, value in pairs(market) do
            createProduct(key)
            self.Image.ScrollableView.GridView["Product"..key]:setVisible(true)
            self.Image.ScrollableView.GridView["Product"..key].item:setImage("gameres|"..value.icon) 
            self.Image.ScrollableView.GridView["Product"..key].name:setText(value.name)
            self.Image.ScrollableView.GridView["Product"..key].num:setText(value.price)
            self.Image.ScrollableView.GridView["Product"..key].count:setText(value.count or 1)                   
            value.NPC = p.NPC                 
        end        
    end
    setMarket(1)
    -- for i = 1, 9, 1 do
    --     self.Image["Product"..i].onMouseClick = function() 
    --         ProductClick(i)
    --     end
    -- end
    self.Image.btnClose.onMouseClick = function() 
        self:close()
    end

    self.Image.Black.onMouseClick = function() 
        self.Image.Black:setVisible(false)
        self.Image.Feal:setVisible(true)
        self.Image:setImage(tableBlack)    
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product"..i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product"..i]) 
                i = i + 1
            else 
                break 
            end            
        end        
    end
    self.Image.Feal.onMouseClick = function() 
        self.Image.Black:setVisible(true)
        self.Image.Feal:setVisible(false)
        self.Image:setImage(tableFeal)   
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product"..i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product"..i]) 
                i = i + 1
            else 
                break 
            end            
        end  
        setMarket(1)     
    end
end