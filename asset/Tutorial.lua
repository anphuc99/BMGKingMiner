function self:onOpen(p)
    print(Lib.pv(p))
    local Tutorial = {
        {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn1.png",
                "asset/Tutorial/Hướng dẫn2.png",
                "asset/Tutorial/Hướng dẫn3.png",
                "asset/Tutorial/Hướng dẫn3.png",
            },
            txtDescription = {
                "Chào mừng bạn đến với King Miner",
                "Đây là công cụ cúp đào dùng để đào khoán sản, rìu để chặc gỗ ở khu thiên nhiên",
                "Ở khu thiên nhiên bạn có thể thu thập gỗ để chế tạo công cụ",
                "Bạn hãy đến khu thiên nhiên và chặc 5 gỗ cây nhỏ"
            },
            Index = 4,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()
                    Me:setGuideTarget(Lib.v3(74.46,51,33.57), 'asset/Texture/Gui/pngegg (1).png',0.1)                                        
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
                "asset/Tutorial/Hướng dẫn4.png",
                "asset/Tutorial/Hướng dẫn5.png",
                "asset/Tutorial/Hướng dẫn5.png",
            },
            txtDescription = {
                "Đây là khu vực đào mỏ",
                "Khu vực mỏ sẽ có các loại khoản sản tương ứng từng loại mở. Để vào được mở bạn phải đủ id card tương ứng",
                "Bạn hãy thu thập 10 khoán sắt tại đây nhé",
            },
            Index = 3,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()
                    Me:setGuideTarget(Lib.v3(21,53,0), 'asset/Texture/Gui/pngegg (1).png',0.1)                                        
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
                "asset/Tutorial/Hướng dẫn6.png",
                "asset/Tutorial/Hướng dẫn7.png",
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Đây là nút dùng để chế tạo",
                "Bạn có thể nhấp vào các trang bị để xem nguyên liệu cần chế tạo là gì",
                "Bạn hãy chế tạo một Shoes (Military) nhé",
            },
            Index = 3,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()                    
                    self:close()                    
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn8.png",
                "asset/Tutorial/Hướng dẫn9.png",
                "asset/Tutorial/Hướng dẫn9.png",
                "asset/Tutorial/Hướng dẫn9.png",
            },
            txtDescription = {
                "Đây là nút dùng nâng cấp",
                "Để có thể nâng cấp được trang bị bạn cần phải thu thập ít nhất 5 viên đá Vortex",
                "Mỗi lần bạn thu thập khoán sẽ có tỷ lệ rơi đá Vortex",
                "Bạn hãy thu thập 5 đá vortex để nâng cấp nhé",
            },
            Index = 4,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()                    
                    self:close()                    
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn10.png",
                "asset/Tutorial/Hướng dẫn10.png",
                "asset/Tutorial/Hướng dẫn10.png",
                "asset/Tutorial/Hướng dẫn10.png",
            },
            txtDescription = {
                "Sau khi thu thập đủ 5 viên đá bạn hãy nhấn vào nâng cấp",
                "Nhấp vào phần cúp sẽ nâng cấp cúp, nhấp vào phần rìu sẽ nâng cấp rìu",
                "Xem tỷ lệ thành công hãy nhấp vào dấu chấm thang màu cam bên gốc trái",
                "Bạn hãy nâng cấp cúp của mình lên lv 2 nhé",
            },
            Index = 4,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()                    
                    self:close()                    
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn10.png",
                "asset/Tutorial/Hướng dẫn10.png",
                "asset/Tutorial/Hướng dẫn10.png",                
            },
            txtDescription = {
                "Đây là cửa hàng",
                "Đây là túi",
                "...",
            },
            Index = 3,
            fun = function ()                                 
                self:close()                    
            end
        },
        M1 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Nhà ta hư hỏng nặng, ta cần một số vật liệu để xây lại nhà. Ngươi cho những vật liệu này không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M2 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Có một thương nhân muốn mua một cái Head (Military) thường. Ngươi có không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M3 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Dạo này nhà tôi bị dột nhiều, ngươi có gỗ bán cho ta không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M4 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Nhà ta hư hỏng nặng, ta cần một số vật liệu để xây lại nhà. Ngươi cho những vật liệu này không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M5 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Có một thương nhân muốn mua một cái Head (Military) thường. Ngươi có không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M6 = {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn7.png",
            },
            txtDescription = {
                "Dạo này nhà tôi bị dột nhiều, ngươi có gỗ bán cho ta không?",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
    }
    local page = 1
    local function setPage()
        self.Tutorial:setImage("gameres|"..Tutorial[p.tutorial].ImgDescription[page])
        self.Tutorial.txtDescription:setText(Lang:toText({Tutorial[p.tutorial].txtDescription[page]})) 
        if page == Tutorial[p.tutorial].Index then
            self.Tutorial.btnOk:setVisible(true)
            self.Tutorial.btnOk.onMouseClick = Tutorial[p.tutorial].fun
            self.Tutorial.right:setVisible(false)
        end  
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