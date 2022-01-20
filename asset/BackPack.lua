function self:onOpen(p) 
    self.BackPack.exit.onMouseClick = function() 
        self:close()
    end 
    
    local function cellClick(i)
        self.BackPack.CellBP["cell"..i].Item:setVisible(false)
        self.BackPack.CellBP["cell"..i].Image1:setVisible(false)
    end
    for i = 1, 30, 1 do
        self.BackPack.CellBP["cell"..i].onMouseClick = function ()
            cellClick(i)
        end
        self.BackPack.CellBP["cell"..i].Item.onMouseClick = function() 
            cellClick(i)
        end
        self.BackPack.CellBP["cell"..i].Image1.onMouseClick = function ()
            cellClick(i)
        end
        self.BackPack.CellBP["cell"..i].Image1.num.onMouseClick = function ()
            cellClick(i)
        end
    end
end
