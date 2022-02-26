local cupLv1 = "myplugin/P_cup_1"
local riuLv1 = "myplugin/A_riu_1"
local positionItem = require "script_common.positionItem"
this.addValueDef("new", false, false, false, true, false)
local PlayerProperty = {
    id = this.platformUserId,
    money = 100000,
    balo = 6,
    idCard = 1,
    Lv = 1,
    exp = 0,
    Mine = 0,
    tutorial = 6,
    takingMissionTutorial = false,
    lastLogin = os.time(),
    lastRollUp7 = nil,
    lastRollUp28 = nil,
    countRollUp7 = 0,
    countRollUp28 = 0
}
this.addValueDef("PlayerItem", {
    {idPlayer = this.platformUserId, idItem = cupLv1,cellNum = 1, num = 1, position = positionItem.hand, lv = 1},
    {idPlayer = this.platformUserId, idItem = riuLv1,cellNum = 2, num = 1, position = positionItem.hand, lv = 1},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/V_Vortex",cellNum = 1, num = 10000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Tree1",cellNum = 2, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Tree2",cellNum = 3, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Tree3",cellNum = 4, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Iron",cellNum = 5, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Copper",cellNum = 6, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Gold",cellNum = 7, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Crystal",cellNum = 8, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Platium",cellNum = 9, num = 1000, position = positionItem.balo},
    -- {idPlayer = this.platformUserId, idItem = "myplugin/M_Titanium",cellNum = 10, num = 1000, position = positionItem.balo},    
}, false, false, true, false)
this.addValueDef("mission", {
    msid = nil,
    takMs = false,
    lastCompleteMs = nil
}, false, false, true, false)
this.addValueDef("Player", PlayerProperty, false, false, true, false)
this.addValueDef("blackMarket", {}, false, false, true, false)
this.addValueDef("Equipment", {}, false, false, true, false)
this.addValueDef("Achievement",{
    done = {},
    proceed = {}
},false, false, true, false)