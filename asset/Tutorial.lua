function self:onOpen(p)
    local Tutorial = {
        {
            ImgDescription = {
                "asset/Tutorial/T1.png",
                "asset/Tutorial/T2.png",
                "asset/Tutorial/T3.png",
                "asset/Tutorial/T4.png",
                "asset/Tutorial/T4.png",
            },
            txtDescription = {
                "Chào mừng bạn đến với King Miner",
                "Đây là công cụ cúp đào dùng để đào khoán sản",
                "Đây là công cụ rìu dùng để chặc gỗ ở khu thiên nhiên",
                "Ở khu thiên nhiên bạn có thể thu thập gỗ để chế tạo công cụ",
                "Bạn hãy đến khu thiên nhiên và chặc 5 gỗ cây nhỏ"
            },
            Index = 5,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()
                    Me:setGuideTarget(Lib.v3(74.46,51,33.57), 'arrow.png',0.1)                                        
                    self.Tutorial:setVisible(false)
                    PackageHandlers.registerClientHandler("shopArrow", function (pa)
                        Me:delGuideTarget()
                        self:close()
                    end)
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/T5.png",
                "asset/Tutorial/T6.png",
            },
            txtDescription = {
                "Đây là khu vực đào mỏ",
                "Bạn hãy thu thập 5 khoán sắt tại đây nhé",
            },
            Index = 2,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()
                    Me:setGuideTarget(Lib.v3(21,53,0), 'arrow.png',0.1)                                        
                    self.Tutorial:setVisible(false)
                    PackageHandlers.registerClientHandler("shopArrow", function (pa)
                        Me:delGuideTarget()
                        self:close()
                    end)
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/T5.png",
                "asset/Tutorial/T6.png",
            },
            txtDescription = {
                "Đây là nút dùng để chế tạo",
                "Bạn hãy chế tạo một Head (Military) nhé",
            },
            Index = 2,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()                    
                    self:close()                    
                end)
            end
        }
    }
    local page = 1
    local function setPage()
        self.Tutorial.ImgDescription:setImage("gameres|"..Tutorial[p.tutorial].ImgDescription[page])
        self.Tutorial.txtDescription:setText(Lang:toText({Tutorial[p.tutorial].txtDescription[page]})) 
    end 
    setPage()
    if page == Tutorial[p.tutorial].Index then
        self.Tutorial.right:setVisible(false)
    end  
    if page == 1 then
        self.Tutorial.left:setVisible(false)
    end  
    self.Tutorial.right.onMouseClick = function() 
        if page < Tutorial[p.tutorial].Index then
            page = page + 1
            setPage()
            self.Tutorial.left:setVisible(true)
            if page == Tutorial[p.tutorial].Index then
                self.Tutorial.btnOk:setVisible(true)
                self.Tutorial.btnOk.onMouseClick = Tutorial[p.tutorial].fun
                self.Tutorial.right:setVisible(false)
            end        
        end        
    end
    self.Tutorial.left.onMouseClick = function() 
        if page > 1 then
            page = page - 1
            setPage()
            self.Tutorial.right:setVisible(true)
            if page == 1 then
                self.Tutorial.left:setVisible(false)
            end        
        end        
    end
end