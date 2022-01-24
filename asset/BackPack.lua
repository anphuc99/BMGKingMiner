function self:onOpen(p)
    local language = require "script_common.language"
    local lg = require "script_client.languagePlayer"
    local SlotBalo = require "script_common.SlotBalo"
    local BlockImg = "gameres|asset/Texture/Gui/UI LOCK(C).png"
    local unBlockImg = "gameres|asset/Texture/Gui/Ô Item(C).png"
    local selectBlockImg = "gameres|asset/Texture/Gui/Khungneon3(C).png"
    local dbClick = {} -- biến đệm cho sự kiện dbClick
    local hasItem = {} -- lưu những ô có vật phẩm
    local lisItem = {} -- danh sách sản phẩm
    local curClick = nil
    local balo
    self.BackPack.exit.onMouseClick = function() self:close() end
    local function setItem(v, cellNum)
        self.BackPack.CellBP["cell" .. cellNum].Item:setVisible(true)
        self.BackPack.CellBP["cell" .. cellNum].Image1:setVisible(true)
        self.BackPack.CellBP["cell" .. cellNum].Item:setImage("gameres|" ..
                                                                  v.icon)
        self.BackPack.CellBP["cell" .. cellNum].Image1.num:setText(v.num)
        hasItem[cellNum] = true
        lisItem[cellNum] = v
    end
    local function reloadBackPack()
        for i = 1, 24, 1 do
            self.BackPack.CellBP["cell" .. i].Item:setVisible(false)
            self.BackPack.CellBP["cell" .. i].Image1:setVisible(false)
            self.BackPack.CellBP["cell" .. i]:setImage(BlockImg)
        end

        PackageHandlers.sendClientHandler("getValuePlayer", nil, function(data)
            balo = data.balo
            for i = 1, data.balo, 1 do
                self.BackPack.CellBP["cell" .. i]:setImage(unBlockImg)
            end
        end)
        -- tải balo lên
        hasItem = {}
        lisItem = {}
        PackageHandlers.sendClientHandler("getBackPackPlayer", nil,
        function(data)
            print(Lib.pv(data))
            for k, v in pairs(data) do
                print(v.cellNum)
                setItem(v, v.cellNum)
            end
        end)
    end
    reloadBackPack()

    -- sự kiện dbClick
    local function cellDbClick(i)
        -- chuyển từ balo xuống tay
        if  i <= balo then
            if hasItem[i] then
                lisItem[i].cellNum = i
                PackageHandlers.sendClientHandler("baloToHand", lisItem[i],
                                                function(rs)
                    print(rs)
                    if rs then
                        self.BackPack.CellBP["cell" .. i].Item:setVisible(false)
                        self.BackPack.CellBP["cell" .. i].Image1:setVisible(false)
                        hasItem[i] = nil
                        lisItem[i] = nil
                    end
                end)                
            else
                -- chuyển từ tay lên balo 
                if i <= balo then
                    PackageHandlers.sendClientHandler("handToBalo", {cellNum = i},
                    function(v)
                        print(Lib.pv(v))
                        setItem(v, i)
                    end)
                end
            end
        else
            -- mở thêm ô balo
            print("eeeeeee")
            UI:openWindow("MessagerBox",nil,nil,{
                Text = language.notify.OpenBP[lg[1]]:gsub("%{price}",SlotBalo[i].money),
                Yes = function (e)
                    PackageHandlers.sendClientHandler("OpenCellNum", nil, function (rs)
                        if rs then
                            self.BackPack.CellBP["cell" .. (balo + 1)]:setImage(unBlockImg)  
                            balo = balo + 1
                        end
                    end)
                end
            })
        end
        
    end
    -- sự kiện ô click
    local function cellClick(i)
        -- tạo sự kiện dbClick
        dbClick[i] = (dbClick[i] or 0) + 1
        World.Timer(10, function()
            dbClick[i] = 0
            return false
        end)
        if dbClick[i] == 2 then
            cellDbClick(i)
            if i <= balo then                
                self.BackPack.CellBP["cell" .. i]:setImage(unBlockImg)  
            else
                self.BackPack.CellBP["cell" .. i]:setImage(BlockImg)  
            end            
            curClick = nil
            return
        end
        for ii = 1, balo, 1 do
            self.BackPack.CellBP["cell" .. ii]:setImage(unBlockImg)
        end
        if i <= balo then
            if curClick == nil or not hasItem[curClick] then
                self.BackPack.CellBP["cell" .. i]:setImage(selectBlockImg)
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
                            self.BackPack.CellBP["cell" .. curClick].Item:setVisible(
                                false)
                            self.BackPack.CellBP["cell" .. curClick].Image1:setVisible(
                                false)
                            hasItem[i] = nil
                            lisItem[i] = nil
                        end
                        setItem(rep.newCell, i)
                    end
                    curClick = nil
                end)
            end
        end
    end
    for i = 1, 24, 1 do
        self.BackPack.CellBP["cell" .. i].onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.CellBP["cell" .. i].Item.onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.CellBP["cell" .. i].Image1.onMouseClick = function()
            cellClick(i)
        end
        self.BackPack.CellBP["cell" .. i].Image1.num.onMouseClick = function()
            cellClick(i)
        end
    end
end
