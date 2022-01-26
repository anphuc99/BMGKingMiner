function self:onOpen(p)
    local Option = true
    self.Option.OpenBP.onMouseClick = function() 
        UI:openWindow("BackPack")
    end
    -- self.test:setText(Lang:toText(""))
    self.Option.Forge.onMouseClick = function() 
        UI:openWindow("crafting")
    end
    PackageHandlers.registerClientHandler("setMoney", function(player, packet)
        self.Money:setText(packet.money)
    end)       
    self.Option.Upgrate.onMouseClick = function() 
        UI:openWindow("Upgrade")
    end
    self.openOption.onMouseClick = function() 
        local i = 0
        World.Timer(1, function ()
            if i <= 360 then
                i = i + 1
                self.openOption:setProperty("Rotation","w:1.0 x:0.0 y:0.0 z:"..i)
                return 0.5
            end
            return false
        end)

        self.Option.Upgrate:setProperty("Position","{{0,298.66},{0,1.90735e-06}}")
        print(Lib.pv(self.Option.Upgrate:getProperty("Position")))
    end
end