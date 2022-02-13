local cupLv1 = "myplugin/P_cup_1"
local positionItem = require "script_common.positionItem"
this.addValueDef("new", false, false, false, true, false)
local PlayerProperty = {
    id = this.platformUserId,
    money = 1000000,
    balo = 6,
    idCard = 1,
    Lv = 1,
    exp = 0,
    lastLogin = os.time()            
}
this.addValueDef("PlayerItem", {
    {idPlayer = this.platformUserId, idItem = cupLv1,cellNum = 1, num = 1, position = positionItem.hand, lv = 1},
    {idPlayer = this.platformUserId, idItem = "myplugin/V_Vortex",cellNum = 1, num = 10000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/P_cup-sat_1",cellNum = 1, num = 1, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/P_cup-sat_2",cellNum = 2, num = 1, position = positionItem.balo},
}, false, false, true, false)
this.addValueDef("Player", PlayerProperty, false, false, true, false)
this.addValueDef("blackMarket", {}, false, false, true, false)