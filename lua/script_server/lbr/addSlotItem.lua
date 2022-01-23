return function (player,itemid,num,slot)
    local item = Item.new(itemid, num) --Create an instance of a item
    local filterTB = {
        Define.TRAY_TYPE.HAND_BAG
    }
    local entityTrays = player:tray()
    local trayTb = entityTrays:query_trays(filterTB)
    for tid, _tray in pairs(trayTb) do
        _tray.tray:settle_item(slot, item) -- Add item to your tray
    end
end