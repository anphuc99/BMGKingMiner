function self:onOpen(p)
    local SlotBalo = require "script_common.SlotBalo"
    local BlockImg = "gameres|asset/Texture/Gui/Slot Item-2 Nút.png"
    local unBlockImg = "gameres|asset/Texture/Gui/Slot Item-1 Nút.png"
    local selectBlockImg = "gameres|asset/Texture/Gui/Slot Item-3 Nút.png"
    local typeItem = require "script_common.typeItem"
    local Context = require "script_common.lbr.Context"
    local dbClick = {} -- biến đệm cho sự kiện dbClick
    local hasItem = {} -- lưu những ô có vật phẩm
    local lisItem = {} -- danh sách sản phẩm
    local dbEquiClick = {} -- biến đệm cho sự kiện dbClick của trang bị
    local curClick = nil
    local balo
    local player =Blockman.Instance().player
    -- phần balo
    self.BackPack.exit.onMouseClick = function() self:close() end
    local function setItem(v, cellNum)
        if v.num <=0 then
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Item:setVisible(false)
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Image1:setVisible(false)
            hasItem[cellNum] = false
            lisItem[cellNum] = nil
        else
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Item:setVisible(true)
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Image1:setVisible(true)
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Item:setImage("gameres|" ..v.icon)
            self.BackPack.ScrollableView.CellBP["cell" .. cellNum].Image1.num:setText(v.num)
            hasItem[cellNum] = true
            lisItem[cellNum] = v
        end
        
    end
    
        for i = 1, 30, 1 do
            self.BackPack.ScrollableView.CellBP["cell" .. i].Item:setVisible(false)
            self.BackPack.ScrollableView.CellBP["cell" .. i].Image1:setVisible(false)
            self.BackPack.ScrollableView.CellBP["cell" .. i]:setImage(BlockImg)
        end

        PackageHandlers.sendClientHandler("getValuePlayer", nil, function(data)
            balo = data.balo
            for i = 1, data.balo, 1 do
                self.BackPack.ScrollableView.CellBP["cell" .. i]:setImage(unBlockImg)
                self.BackPack.idCard:setImage("gameres|asset/idCard/idCard"..data.idCard..".png")
            end
        end)
    local function reloadBackPack()    
        -- tải balo lên
        hasItem = {}
        lisItem = {}
        PackageHandlers.sendClientHandler("getBackPackPlayer", nil,
        function(data)
            print(Lib.pv(data))
            for k, v in pairs(data) do
                setItem(v, v.cellNum)
            end
            for i = 1, balo, 1 do
                if not hasItem[i] then
                    self.BackPack.ScrollableView.CellBP["cell" .. i].Item:setVisible(false)
                    self.BackPack.ScrollableView.CellBP["cell" .. i].Image1:setVisible(false)
                end
            end
        end)
    end
    reloadBackPack()

    -- sự kiện dbClick
    local function cellDbClick(i)
        if p and p.onCellDbClick then
            p.onCellDbClick(self,i,lisItem)
        end        
        -- chuyển từ balo xuống tay
        if  i <= balo then
            -- if hasItem[i] then
            --     lisItem[i].cellNum = i
            --     PackageHandlers.sendClientHandler("baloToHand", lisItem[i],
            --     function(rs)
            --         print(rs)
            --         if rs then
            --             self.BackPack.ScrollableView.CellBP["cell" .. i].Item:setVisible(false)
            --             self.BackPack.ScrollableView.CellBP["cell" .. i].Image1:setVisible(false)
            --             hasItem[i] = nil
            --             lisItem[i] = nil
            --         end
            --     end)                
            -- else
            --     -- chuyển từ tay lên balo 
            --     if i <= balo then
            --         PackageHandlers.sendClientHandler("handToBalo", {cellNum = i},
            --         function(v)
            --             print(Lib.pv(v))
            --             setItem(v, i)
            --         end)
            --     end
            -- end
            if lisItem[curClick] then
                self.BackPack.Blur:setVisible(true)
                self.BackPack.InfoBox:setVisible(true)
                self.BackPack.InfoBox.name:setText(Lang:toText({lisItem[curClick].name}))
                self.BackPack.InfoBox.amount:setText(lisItem[curClick].num)
                self.BackPack.InfoBox.Icon:setImage("gameres|"..lisItem[curClick].icon)
                self.BackPack.InfoBox.description:setText(Lang:toText({lisItem[curClick].description}):gsub("%<p>","\n"))
                if lisItem[curClick].typeItem == typeItem.Equipment then
                    self.BackPack.InfoBox.type:setText(Lang:toText({"typeItem_Equi"})) 
                elseif lisItem[curClick].typeItem == typeItem.Material then
                    self.BackPack.InfoBox.type:setText(Lang:toText({"typeItem_Mar"})) 
                elseif lisItem[curClick].typeItem == typeItem.Trophy then
                    self.BackPack.InfoBox.type:setText(Lang:toText({"typeItem_Tro"})) 
                elseif lisItem[curClick].typeItem == typeItem.Vortex then
                    self.BackPack.InfoBox.type:setText(Lang:toText({"typeItem_Vor"})) 
                end              
                self.BackPack.ScrollableView.CellBP["cell" .. curClick]:setImage(unBlockImg)  
                curClick = nil
            else
                self.BackPack.Blur:setVisible(false)
                self.BackPack.InfoBox:setVisible(false)
                self.BackPack.ScrollableView.CellBP["cell" .. curClick]:setImage(unBlockImg)  
                curClick = nil
            end                    
        end        
    end
    -- 
    self.BackPack.onMouseClick = function() 
        self.BackPack.ScrollableView.CellBP["cell" .. curClick]:setImage(unBlockImg)  
        curClick = nil
    end
    -- sự kiện ô click
    local function cellClick(i)
        if p and p.onCellClick then
            p.onCellClick(self,i,lisItem)
        end        
        -- tạo sự kiện dbClick
        dbClick[i] = (dbClick[i] or 0) + 1
        World.Timer(10, function()
            dbClick[i] = 0
            return false
        end)
        if dbClick[i] == 2 then
            cellDbClick(i)
            if i <= balo then                
                self.BackPack.ScrollableView.CellBP["cell" .. i]:setImage(unBlockImg)  
            else
                self.BackPack.ScrollableView.CellBP["cell" .. i]:setImage(BlockImg)  
            end            
            curClick = nil
            return
        end
        for ii = 1, balo, 1 do
            self.BackPack.ScrollableView.CellBP["cell" .. ii]:setImage(unBlockImg)
        end
        if i <= balo then
            if curClick == nil or not hasItem[curClick] or curClick == i then
                self.BackPack.ScrollableView.CellBP["cell" .. i]:setImage(selectBlockImg)
                curClick = i
            else
                PackageHandlers.sendClientHandler("moveItem", {
                    newCell = i,
                    oldCell = curClick
                }, function(rep)
                    if rep.rs then
                        if rep.oldCell ~= nil then
                            setItem(rep.oldCell, curClick)
                        else
                            self.BackPack.ScrollableView.CellBP["cell" .. curClick].Item:setVisible(
                                false)
                            self.BackPack.ScrollableView.CellBP["cell" .. curClick].Image1:setVisible(
                                false)
                            hasItem[curClick] = nil
                            lisItem[curClick] = nil
                        end
                        setItem(rep.newCell, i)
                        curClick = nil
                    end                    
                end)
            end
        else
            if curClick ~= nil then
                self.BackPack.ScrollableView.CellBP["cell" .. curClick]:setImage(unBlockImg)  
                curClick = nil
            end
            -- mở thêm ô balo
            UI:openWindow("MessagerBox",nil,nil,{
                Text = {"notify_OpenBP",SlotBalo[i].money},
                Yes = function (e)
                    PackageHandlers.sendClientHandler("OpenCellNum", nil, function (rs)
                        if rs then
                            self.BackPack.ScrollableView.CellBP["cell" .. (balo + 1)]:setImage(unBlockImg)  
                            balo = balo + 1
                        end
                    end)
                end
            })
        end
    end
    for i = 1, 30, 1 do
        self.BackPack.ScrollableView.CellBP["cell" .. i].onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.ScrollableView.CellBP["cell" .. i].Item.onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.ScrollableView.CellBP["cell" .. i].Image1.onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.ScrollableView.CellBP["cell" .. i].Image1.num.onMouseClick = function()
            cellClick(i)
        end
    end
    self.BackPack.Blur.onMouseClick = function ()
        self.BackPack.InfoBox:setVisible(false)
        self.BackPack.Blur:setVisible(false)
    end
    -- phần trang bị    
    -- lấy thông tin
    self.BackPack.playerName:setText(player.name)
    PackageHandlers.sendClientHandler("getValuePlayer", nil, function (propPlayer)
        self.BackPack.Lv:setText(propPlayer.Lv)
        self.BackPack.Id_card:setText(Lang:toText({"ID_card"..propPlayer.idCard}))
        self.BackPack.Id_card2:setText(Lang:toText({"ID_card"..propPlayer.idCard}))
        self.BackPack.desc_Id_card:setText(Lang:toText({"desc_Id_card"..propPlayer.idCard}))
        self.BackPack.Exp:setText(propPlayer.exp)
    end)

    local function setUIEquiment(equiment)
        local context_equipment = Context:new("Equipment")
        for i = 2, 7, 1 do
            self.BackPack.Equiment["e"..i]:setVisible(false)
            self.BackPack.Equiment["e"..i].id = nil
        end
        for index, value in ipairs(equiment) do
            local item = context_equipment:where("id",value):firstData()
            print("eeeeeeeeessss")
            print(item.typeEquipment)
            self.BackPack.Equiment["e"..item.typeEquipment]:setVisible(true)
            self.BackPack.Equiment["e"..item.typeEquipment]:setImage("gameres|"..item.icon)
            self.BackPack.Equiment["e"..item.typeEquipment].id = item.id
        end
    end
    -- lấy trang bị
    PackageHandlers.sendClientHandler("getEquiment", nil, function (equiment)
        setUIEquiment(equiment)
    end)
    -- mặc trang bị
    local wearEquipmen = function ()
        if lisItem[curClick] then            
            local contextItem = Context:new("Item")
            local item = contextItem:where("id",lisItem[curClick].id):firstData()
            if item.typeItem == typeItem.Equipment then
                PackageHandlers.sendClientHandler("wearEquipment", {id = lisItem[curClick].id}, function (rs)
                    if rs then
                        setUIEquiment(rs)
                        reloadBackPack()
                        self.BackPack.ScrollableView.CellBP["cell" .. curClick]:setImage(unBlockImg)  
                        curClick = nil
                    end
                end)
            end
        end
    end

    self.BackPack.Equiment.onMouseClick = wearEquipmen
    self.BackPack.Equiment.ActorWindow.onMouseClick = wearEquipmen
    for i = 2, 7, 1 do
        self.BackPack.Equiment["e"..i].onMouseClick = function() 
            dbEquiClick[i] = (dbEquiClick[i] or 0) + 1
            World.Timer(10, function()
                dbEquiClick[i] = 0
                return false
            end)
            if dbEquiClick[i] == 2 then
                PackageHandlers.sendClientHandler("unequip", {id = self.BackPack.Equiment["e"..i].id}, function (rs)
                    if rs then
                        setUIEquiment(rs)
                        reloadBackPack()
                    end
                end)
            end
        end
    end
    -- nâng cấp id card
    self.BackPack.idCard.onMouseClick = function() 
        if self.BackPack.Id_card:getText() ~= Lang:toText({"ID_card3"}) then
            UI:openWindow("MessagerBox",nil,nil,{
                Text = {"messeger_updateIdCard"},
                Yes = function (s)
                    PackageHandlers.sendClientHandler("updateIdCard", nil, function (rs)
                        if rs then
                            self.BackPack.Id_card:setText(Lang:toText({"ID_card"..rs}))
                            self.BackPack.Id_card2:setText(Lang:toText({"ID_card"..rs}))
                            self.BackPack.desc_Id_card:setText(Lang:toText({"desc_Id_card"..rs}))
                            self.BackPack.idCard:setImage("gameres|asset/idCard/idCard"..rs..".png")
                        end
                    end)
                end
            })
        end
        
    end
end
