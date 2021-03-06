function self:onOpen(p)
    self.Tutorial.Close.onMouseClick = function() 
        self:close()
    end

    local Tutorial = {
        {
            ImgDescription = {
                "asset/Tutorial/Tutorial1.png",
                "asset/Tutorial/Tutorial2.png",
                "asset/Tutorial/Tutorial3.png",
            },
            txtDescription = {
                "Tutorial_1",
                "Tutorial_2",
                "Tutorial_3"
            },
            Index = 3,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()
                    Me:setGuideTarget(Lib.v3(74.46,51,33.57), 'asset/Texture/Gui/pngegg_1.png',0.1)                                        
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
                "asset/Tutorial/Tutorial4.png",
                "asset/Tutorial/Tutorial5.png",
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
                "asset/Tutorial/Tutorial6.png",
                "asset/Tutorial/Tutorial7.png",
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
                "asset/Tutorial/Tutorial8.png",
                "asset/Tutorial/Tutorial9.png",
            },
            txtDescription = {
                "Tutorial_8",
                "Tutorial_9",
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
                "asset/Tutorial/Tutorial10.png",
            },
            txtDescription = {
                "Tutorial_10",
            },
            Index = 1,
            fun = function ()                
                PackageHandlers.sendClientHandler("TakingMissionTutorial", nil, function ()                    
                    self:close()                    
                end)
            end
        },
        {
            ImgDescription = {
                "asset/Tutorial/Tutorial11.png",
                "asset/Tutorial/Tutorial12.png",          
            },
            txtDescription = {
                "Tutorial_11",
                "Tutorial_12",
            },
            Index = 2,
            fun = function ()                                 
                self:close()                    
            end
        },
        M1 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M1",
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
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M2",
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
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M3",
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
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M4",
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
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M5",
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
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M6",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M7 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M7",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M8 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M8",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M9 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M9",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M10 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M1",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M11 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M2",
            },
            Index = 1,
            fun = function ()
                PackageHandlers.sendClientHandler("takingMission", nil, function ()
                    self:close()
                end)
            end
        },
        M12 = {
            ImgDescription = {
                "asset/Tutorial/daily_mission.png",
            },
            txtDescription = {
                "mission_M3",
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