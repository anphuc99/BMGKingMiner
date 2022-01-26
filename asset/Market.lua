function self:onOpen(p)
    local BUS_Market = require "script_client.Bus.Market"
    local market = {}
    local function setMarket(mk)
        if mk == 1 then
            market = BUS_Market:getFleaMaket(p.NPC)
        end
        for key, value in pairs(market) do
            self.Image["item"..key]:setVisible(true)
            self.Image["name"..key]:setVisible(true)
            self.Image["num"..key]:setVisible(true)
            self.Image["item"..key]:setImage("gameres|"..value.icon) 
            self.Image["name"..key]:setText(value.name)
            self.Image["num"..key]:setText(value.price)       
            value.NPC = p.NPC                 
        end
    end
    setMarket(1)
    local function ProductClick(i)
        UI:openWindow("MessagerBox",nil,nil,{
            Text = {"notify_sell",market[i].name},
            Yes = function ()
                PackageHandlers.sendClientHandler("sellFleaMarket", market[i])
            end
        })        
    end
    for i = 1, 4, 1 do
        self.Image["Product"..i].onMouseClick = function() 
            ProductClick(i)
        end
    end
    self.Image.btnClose.onMouseClick = function() 
        self:close()
    end
end