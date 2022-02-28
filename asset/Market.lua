function self:onOpen(p)
    -- local AdHelper = Game.GetService("AdHelper")
    -- print("Eeeeeeeeeeeewwwwwwww")
    -- AdHelper:defineAdPlace('place1')
    -- AdHelper:reportAdPlace('place1')
    -- print(Lib.pv(AdHelper))
    -- local cancelfunc = AdHelper:videoAd('place1',9,function(videoAdResult,place,index)
    --     if videoAdResult == AdHelper.VideoAdResult.FINISHED then --Watched successfully
    --         print('Watch out')
    --     elseif videoAdResult == AdHelper.VideoAdResult.FAILED then --Watch failed
    --         print('Watch the failure')
    --     elseif videoAdResult == AdHelper.VideoAdResult.CLOSE then -- Exit without reading
    --         print('Exit while watching')
    --     end
    -- end)
    local BUS_Market = require "script_client.Bus.Market"
    local tableFeal = "gameres|asset/Texture/Gui/Bảng trống1(2000).png"
    local tableBlack = "gameres|asset/Texture/Gui/Bảng trống2(2000).png"
    local tableTrade = "gameres|asset/Texture/Gui/Bảng trống4(2000).png"
    local Context = require "script_common.lbr.Context"
    local market = {}
    local typeMk = 1
    local setMarket
    if p.BlackMarket then
        self.Image.Black:setVisible(true)
    end
    local function ProductClick(i)
    -- chợ trời
        if typeMk == 1 then
            PackageHandlers.sendClientHandler("getBackPackPlayer", nil, function (bp)
                local context_bp = Context:new(bp)
                UI:openWindow("MessagerBox", nil, nil, {            
                    Text = {"notify_sellfeal", context_bp:where("id",market[i].id):sum("num")},
                    TextBox = true,
                    Yes = function(s)                
                        local amu = tonumber(s.info.TextBox:getText())
                        if amu == nil then                    
                            --UI:openWindow("messenger",nil,nil,{Text = {"messeger_InputAmount"}})
                            require "script_client.senTip".sendTip({Text = {"messeger_InputAmount"}})
                            return false
                        end         
                        market[i].num = amu       
                        PackageHandlers.sendClientHandler("sellFleaMarket", market[i],function ()
                            PackageHandlers.sendClientHandler("getBackPackPlayer", nil,function (BP)
                                local context_BP = Context:new(BP)
                                local countitem = context_BP:where("id", market[i].id)
                                :sum("num")
                                self.Image.ScrollableView.GridView["Product" .. i].count:setText(countitem)
                                self.Image.ScrollableView.GridView["Product" .. i].block:setVisible(countitem < 1)                                             
                            end)
                        end)
                    end
                })
            end)  
        -- chợ đen
        elseif typeMk == 2 then
            UI:openWindow("MessagerBox",nil,nil,{
                Text = {"notify_buy",market[i].name},
                Yes = function (s)
                    PackageHandlers.sendClientHandler("sellBlackMarket", market[i],function ()
                        local i = 1
                        while true do
                            if self.Image.ScrollableView.GridView["Product" .. i] then
                                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                                i = i + 1
                            else
                                break
                            end
                        end
                        setMarket(2)
                    end)
                end
            })
        -- kiểm tra gian hàng chợ đen
        elseif typeMk == 3 then
            UI:openWindow("MessagerBox",nil,nil,{
                Text = {"notify_deleteProduct"},
                Yes = function (s)
                    PackageHandlers.sendClientHandler("deleteProduct", market[i], function ()
                        local i = 1
                        while true do
                            if self.Image.ScrollableView.GridView["Product" .. i] then
                                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                                i = i + 1
                            else
                                break
                            end
                        end
                        setMarket(3)
                    end)
                end
            })
        -- đăng bán hàng chợ đen
        elseif typeMk == 4 then
            UI:openWindow("formSale",nil,nil,{
                onOpen = function (s)
                    s.info.Icon:setImage("gameres|"..market[i].icon)
                    s.info.name:setText(Lang:toText({market[i].name}))                    
                end,
                Yes = function (s)
                    local amount = tonumber(s.info.Amount:getText())
                    local money = tonumber(s.info.Money:getText())
                    if amount == nil then
                        --UI:openWindow("messenger",nil,nil,{Text = {"messeger_InputAmount"}})
                        require "script_client.senTip".sendTip({Text = {"messeger_InputAmount"}})
                        return false
                    end
                    if money == nil then
                        --UI:openWindow("messenger",nil,nil,{Text = {"messeger_InputMoney"}})
                        require "script_client.senTip".sendTip({Text = {"messeger_InputMoney"}})
                        return false
                    end
                    PackageHandlers.sendClientHandler("publishBlackMarket", {
                        idItem = market[i].id,
                        count = amount,
                        price = money
                    }, function (rs)
                        if rs then
                            PackageHandlers.sendClientHandler("getBackPackPlayer", nil,function (BP)
                                local context_BP = Context:new(BP)
                                local countitem = context_BP:where("id", market[i].id)
                                :sum("num")
                                self.Image.ScrollableView.GridView["Product" .. i].count:setText(countitem)
                                self.Image.ScrollableView.GridView["Product" .. i].block:setVisible(countitem < 1)                                             
                            end)
                            s:close()
                        end
                    end)
                end
            })
        end
              
    end
    local function createProduct(key)
        local product = UI:createStaticImage("Product" .. key)
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
        name:setTextColours(Color3.new(0, 0, 0))
        product:addChild(name)
        local conut = UI:createStaticText("count")
        conut:setProperty("Position", "{{0,216.57},{0,47.55}}")
        conut:setProperty("Size", "{{0,35.08},{0,20.12}}")
        conut:setProperty("MousePassThroughEnabled", "true")
        conut:setTextColours(Color3.new(0, 0, 0))
        product:addChild(conut)
        local num = UI:createStaticText("num")
        num:setProperty("Position", "{{0,155.67},{0,74.70}}")
        num:setProperty("Size", "{{0,103.73},{0,23.91}}")
        num:setProperty("MousePassThroughEnabled", "true")
        num:setTextColours(Color3.new(0, 0, 0))
        product:addChild(num)
        local block = UI:createStaticImage("block")
        block:setImage("gameres|asset/Texture/Gui/Khung Item Mờ(1500).png")
        block:setProperty("Size", "{{120,0},{120,0}}")
        product:addChild(block)
        product.onMouseClick = function() ProductClick(key) end
        self.Image.ScrollableView.GridView:addChild(product)
    end
    setMarket = function(mk)
        local mar
        typeMk = mk
        market = {}
        self.Image.NoProduct:setVisible(false)
        if mk == 1 then
            mar = BUS_Market:getFleaMaket(p.NPC)
        elseif mk == 4 then
            mar = BUS_Market:getSaleMarket()
        elseif mk == 2 or mk == 3 then
            local requet
            if mk == 2 then
                requet = "seenBlackMarket"
            else
                requet = "seenMyMarket"
            end
            PackageHandlers.sendClientHandler(requet, nil, function (bMk)
                if #bMk == 0 then
                    self.Image.NoProduct:setVisible(true)
                    if mk == 2 then
                        self.Image.NoProduct:setText(Lang:toText({"NoProductBlack"}))
                    else
                        self.Image.NoProduct:setText(Lang:toText({"NoProduct"}))
                    end
                    return
                end
                PackageHandlers.sendClientHandler("getValuePlayer", nil, function (player)                    
                    mar = BUS_Market:getBlackMarket(bMk)
                    print(Lib.pv(player))  
                    for key, value in pairs(mar) do
                        createProduct(key)
                        self.Image.ScrollableView.GridView["Product" .. key]:setVisible(true)
                        self.Image.ScrollableView.GridView["Product" .. key].item:setImage("gameres|" .. value.icon)
                        self.Image.ScrollableView.GridView["Product" .. key].name:setText(Lang:toText(value.name))
                        self.Image.ScrollableView.GridView["Product" .. key].num:setText(value.price)
                        self.Image.ScrollableView.GridView["Product" .. key].count:setText(value.count)
                        self.Image.ScrollableView.GridView["Product" .. key].block:setVisible(false)
                        print(Lib.pv(player))
                        self.Image.ScrollableView.GridView["Product" .. key].block:setVisible(mk ~= 3 and player.money < value.price)
                        value.NPC = p.NPC
                        market[#market + 1] = value                                                                      
                    end
                end)
            end)
        end        
        if mk == 1 or mk == 4 then          
            PackageHandlers.sendClientHandler("getBackPackPlayer", nil,
            function(BP)
                if mk ~= 1 and mk ~= 4 then
                    return
                end
                local context_BP = Context:new(BP)
                local hide = {}
                local show = {}
                for key, value in pairs(mar) do
                    local countitem = context_BP:where("id", value.id):sum("num")
                    if countitem >= 1 then
                        value.count = countitem
                        show[#show+1] = value
                    else
                        hide[#hide+1] = value
                    end
                end
                for key, value in pairs(show) do
                    createProduct(key)
                    self.Image.ScrollableView.GridView["Product" .. key]:setVisible(true)
                    self.Image.ScrollableView.GridView["Product" .. key].item:setImage("gameres|" .. value.icon)
                    self.Image.ScrollableView.GridView["Product" .. key].name:setText(Lang:toText(value.name))
                    self.Image.ScrollableView.GridView["Product" .. key].num:setText(value.price)
                    self.Image.ScrollableView.GridView["Product" .. key].count:setText(value.count)
                    self.Image.ScrollableView.GridView["Product" .. key].block:setVisible(false)
                    value.NPC = p.NPC
                    market[#market + 1] = value
                end
                for key, value in pairs(hide) do
                    createProduct(key+#show)
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)]:setVisible(true)
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)].item:setImage("gameres|" .. value.icon)
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)].name:setText(Lang:toText(value.name))
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)].num:setText(value.price)
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)].count:setText(0)
                    self.Image.ScrollableView.GridView["Product" ..(key + #show)].block:setVisible(true)
                    value.NPC = p.NPC
                    market[#market + 1] = value
                end
            end)
        end

    end
    setMarket(1)
    -- for i = 1, 9, 1 do
    --     self.Image["Product"..i].onMouseClick = function() 
    --         ProductClick(i)
    --     end
    -- end
    self.Image.btnClose.onMouseClick = function() self:close() end

    self.Image.Black.onMouseClick = function()
        self.Image.Black:setVisible(false)
        self.Image.Feal:setVisible(true)
        self.Image:setImage(tableBlack)
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product" .. i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                i = i + 1
            else
                break
            end
        end
        self.Image.addProduct:setVisible(true)
        self.Image.myProduct:setVisible(true)
        setMarket(2)
    end
    self.Image.Feal.onMouseClick = function()
        self.Image.Black:setVisible(true)
        self.Image.Feal:setVisible(false)
        self.Image:setImage(tableFeal)
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product" .. i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                i = i + 1
            else
                break
            end
        end
        setMarket(1)
        self.Image.addProduct:setVisible(false)
        self.Image.myProduct:setVisible(false)
    end
    self.Image.addProduct.onMouseClick = function() 
        self.Image.Black:setVisible(true)
        self.Image.Feal:setVisible(true)
        self.Image:setImage(tableTrade)
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product" .. i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                i = i + 1
            else
                break
            end
        end
        setMarket(4)
        self.Image.addProduct:setVisible(false)
        self.Image.myProduct:setVisible(true)
    end
    self.Image.myProduct.onMouseClick = function() 
        self.Image.Black:setVisible(true)
        self.Image.Feal:setVisible(true)
        self.Image:setImage(tableBlack)
        local i = 1
        while true do
            if self.Image.ScrollableView.GridView["Product" .. i] then
                self.Image.ScrollableView.GridView:removeChild(self.Image.ScrollableView.GridView["Product" ..i])
                i = i + 1
            else
                break
            end
        end
        setMarket(3)
        self.Image.addProduct:setVisible(true)
        self.Image.myProduct:setVisible(false)
    end
end