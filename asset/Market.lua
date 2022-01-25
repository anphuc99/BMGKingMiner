function self:onOpen(p)
    local function ProductClick(i)
        
    end
    for i = 1, 4, 1 do
        self.Image["Product"..i].onMouseClick = function() 
            ProductClick(i)
        end
    end
end