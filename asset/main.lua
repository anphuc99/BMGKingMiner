function self:onOpen(p)
    print(Lib.pv(p))
    local typeItem = require "script_common.typeItem"
    -- local Option = true
    self.Option.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
    -- self.test:setText(Lang:toText(""))
    self.Option.Forge.onMouseClick = function() 
        UI:openWindow("crafting")
    end
    PackageHandlers.registerClientHandler("setMoney", function(player, packet)
        self.Coin.Money:setText(packet.money)
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
    self.Coin.Money:setText(p.money)

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
end