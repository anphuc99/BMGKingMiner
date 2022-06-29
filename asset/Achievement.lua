function self:onOpen(p)
    local Achievement = require "script_common.database.Acievement"
    local eleAchi = self.Image.ScrollableView.HorizontalLayout    
    local Context = require "script_common.lbr.Context"
    local dot = 0
    local function setDot(_dot)
        dot = _dot
        if dot == 0 then
            local win = UI:isOpenWindow("main")
            win.Option.Achievement.dot:setVisible(false)
        end
    end
    local function locate( table, value )
        for i = 1, #table do
            if table[i] == value then return true end
        end
        return false
    end
    self.Image.Close.onMouseClick = function() 
        self:close()
    end
    self.Image.Dally.onMouseClick = function() 
        PackageHandlers.sendClientHandler("getValuePlayer", nil, function (player)
            UI:openWindow("Login",nil,nil,player)
            self:close()
        end)
        
    end
    PackageHandlers.sendClientHandler("getAchievement", nil, function (achi,valuePlayer)
        local top = {}
        local middi = {}
        local buttom = {}
        for index, value in ipairs(achi.proceed) do
            buttom[#buttom+1] = value
        end

        for index, value in ipairs(achi.done) do
            if not locate(achi.proceed, value) then
                top[#top+1] = value
            end
        end

        for i = 1, #Achievement, 1 do
            if not locate(achi.done,i) then
                middi[#middi+1] = i
            end
        end
        local i = 1
        local function setAchi(v,dis)
            local str
            local cur
            local achi2
            for key, value in pairs(Achievement[v].condition) do
                cur = valuePlayer[key]
                achi2 = value
                str = cur.."/"..achi2
            end
            eleAchi["Achi"..i].Text:setText(str)
            eleAchi["Achi"..i].Text1:setText(Lang:toText({"Achi"..v}))
            eleAchi["Achi"..i].ProgressBar1:setProgress(cur/achi2)
            local item = {}
            for key, value in pairs(Achievement[v].reward.item) do
                item[#item+1] = key
            end
            if #item > 0 then
                pcall(function ()
                    local context_item = Context:new("Item")
                    local icon = context_item:where("id",item[1]):firstData().icon
                    eleAchi["Achi"..i].gift1:setImage("gameres|"..icon)
                    eleAchi["Achi"..i].gift1.num:setText(Achievement[v].reward.item[item[1]])
                    local icon = context_item:where("id",item[2]):firstData().icon
                    eleAchi["Achi"..i].gift2:setImage("gameres|"..icon) 
                    eleAchi["Achi"..i].gift2.num:setText(Achievement[v].reward.item[item[2]])
                end)    
            end            
            if Achievement[v].reward.exp > 0 then
                if eleAchi["Achi"..i].gift1:getProperty("Image") == "gameres|asset/Texture/Gui/button_notreceived2.png" then
                    eleAchi["Achi"..i].gift1:setImage("gameres|asset/Texture/Gui/exp_icon.png")
                    eleAchi["Achi"..i].gift1.num:setText(Achievement[v].reward.exp)
                else
                    eleAchi["Achi"..i].gift2:setImage("gameres|asset/Texture/Gui/EXP icon.png")
                    eleAchi["Achi"..i].gift2.num:setText(Achievement[v].reward.exp)                    
                end
            end
            if Achievement[v].reward.coin > 0 then
                if eleAchi["Achi"..i].gift1:getProperty("Image") == "gameres|asset/Texture/Gui/Nút chưa nhận2.png" then
                    eleAchi["Achi"..i].gift1:setImage("gameres|asset/Texture/Gui/coin.png")
                    eleAchi["Achi"..i].gift1.num:setText(Achievement[v].reward.coin)
                else
                    eleAchi["Achi"..i].gift2:setImage("gameres|asset/Texture/Gui/coin_.png")
                    eleAchi["Achi"..i].gift2.num:setText(Achievement[v].reward.coin)                    
                end
            end          
            eleAchi["Achi"..i].Proceed:setProperty("Disabled", dis)
            eleAchi["Achi"..i].icon:setImage("gameres|"..Achievement[v].icon)
            i = i + 1
        end
        for index, value in ipairs(top) do                  
            setAchi(value,"false")   
            setDot(dot + 1)
        end
        for index, value in ipairs(middi) do
            setAchi(value,"true")            
        end
        for index, value in ipairs(buttom) do
            eleAchi["Achi"..i].blru:setVisible(true)  
            setAchi(value,"true")          
        end
        for ii = 1, #top, 1 do
            eleAchi["Achi"..ii].Proceed.onMouseClick = function() 
                PackageHandlers.sendClientHandler("ProccedAchievement", {achi = top[ii]}, function (rs)
                    if rs then                        
                        eleAchi["Achi"..ii].blru:setVisible(true)
                        setDot(dot - 1)
                    end
                end)
            end   
        end
    end)
end