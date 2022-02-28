function self:onOpen(p)
    self.Tutorial.Close.onMouseClick = function() 
        self:close()
    end

    local Tutorial = {
        {
            ImgDescription = {
                "asset/Tutorial/Hướng dẫn1.png",
                "asset/Tutorial/Hướng dẫn2.png",
                "asset/Tutorial/Hướng dẫn3.png",
            },
            txtDescription = {
                "Tutorial_1",
                "Tutorial_2",
                "Tutorial_3"
            },
            Index = 3,
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
            },
            txtDescription = {
                "Tutorial_4",
                "Tutorial_5",
            },
            Index = 2,
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
            },
            txtDescription = {
                "Tutorial_6",
                "Tutorial_7",
            },
            Index = 2,
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
            },
            txtDescription = {
                "Tutorial_8",
                "Tutorial_9",
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
            },
            txtDescription = {
                "Tutorial_10",
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
                "asset/Tutorial/Hướng dẫn11.png",
                "asset/Tutorial/Hướng dẫn12.png",          
            },
            txtDescription = {
                "Tutorial_11",
                "Tutorial_12",
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