function self:onOpen(p)
    local typeItem = require "script_common.typeItem"
    local Context = require "script_common.lbr.Context"
    -- local Option = true
    self.Option.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
    -- self.test:setText(Lang:toText(""))
    self.Option.Forge.onMouseClick = function() 
        UI:openWindow("crafting")
    end
    self.Option.Achievement.onMouseClick = function() 
        PackageHandlers.sendClientHandler("getValuePlayer", nil, function (packet)
            UI:openWindow("Login",nil,nil,packet)
        end)
        
    end
    PackageHandlers.registerClientHandler("setMoney", function(player, packet)
        self.Coin.Money:setText(packet.money)
    end)       
    PackageHandlers.registerClientHandler("setMission", function(player, packet)        
        self.Mission:cleanupChildren()
        if #packet == 0 then
            return
        end
        local text1 = UI:createStaticText("Mi")
        text1:setText(Lang:toText({"Mission"}))
        text1:setTextColours(Color3.new(1,1,1))
        text1:setHeight(UDim.new(0,20))
        self.Mission:addChild(text1)
        for ii, value in ipairs(packet) do
            local text = UI:createStaticText("M"..ii)
            local context_item = Context:new("Item")
            local item = context_item:where("id",value.item):firstData()
            text:setText(Lang:toText({item.name})..": "..value.num.."/"..value.count)
            text:setTextColours(Color3.new(1,1,1))
            text:setHeight(UDim.new(0,20))
            self.Mission:addChild(text)
        end        
    end)       
    self.Option.Upgrate.onMouseClick = function() 
        UI:openWindow("Upgrade")                
        -- UI:openWindow("BackPack",nil,nil,{
        --     onCellClick = function (bp,i,listItem)
        --         if listItem[i] == nil then
        --             UI:openWindow("messenger",nil,nil,{Text = "messenger_selectItem"})
        --             return
        --         end
        --         if listItem[i].typeItem ~= typeItem.Trophy then
        --             UI:openWindow("messenger",nil,nil,{Text = "messenger_selectItem"})
        --             return
        --         end
        --         bp:close()
        --     end
        -- })
    end
    -- self.openOption.onMouseClick = function() 
    --     local i = 0
    --     local up = 620/50
    --     World.Timer(1, function ()
    --         if i <= 0.5 then
    --             i = i + 0.01
    --             self.openOption:setProperty("Rotation","w:1 x:0 y:0 z:"..i)
    --             local size = self.openOption:getProperty("Size")
    --             print(size)
    --             -- self.Option.Upgrate:setProperty("Position","{{0,298.66},{0,1.90735e-06}}")
    --             return 0.5
    --         end
    --         return false
    --     end)

    --     -- self.Option.Upgrate:setProperty("Position","{{0,298.66},{0,1.90735e-06}}")

    -- end
    self.Option.Tutorial.onMouseClick = function() 
        PackageHandlers.sendClientHandler("getValuePlayer", nil, function (package)
            UI:openWindow("Tutorial",nil,nil,package)
        end)
    end
end