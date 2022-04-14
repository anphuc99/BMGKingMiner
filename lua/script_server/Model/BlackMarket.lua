local class = require "script_common.lbr.Class"
local BlackMarket = class()
local DBHandler = require "dbhandler"
local Gol = require "script_server.Golde_Valiable"
local cjson = require "cjson"
BlackMarket:create("BlackMarket",function ()
    local o = {}
    -- properties
    local idItem
	local price
	local quantily
	local idPlayer
    local create_at
    local sold
    local key
    local playerName

    function o:__constructor(data,_key)
        -- constructor
		idItem = data.idItem
		price = data.price
		quantily = data.quantily
		idPlayer = data.idPlayer    
        create_at = data.create_at 
        playerName = data.playerName
        key = _key
    end
    -- method

    function o:getIdItem()
        return idItem
    end
    function o:setIdItem(_idItem)
        idItem = _idItem
    end

    function o:getPrice()
        return price
    end
    function o:setPrice(_price)
        price = _price
    end

    function o:getQuantily()
        return quantily
    end
    function o:setQuantily(_quantily)
        quantily = _quantily
    end

    function o:getIdPlayer()
        return idPlayer
    end
    function o:setIdPlayer(_idPlayer)
        idPlayer = _idPlayer
    end

    function o:toTable()
        return{
            idItem = idItem,
            price = price,
            quantily = quantily,
            idPlayer = idPlayer,
            create_at = create_at,
            sold = sold,
            playerName = playerName
        }
    end

    function o:sell()
        create_at = os.time()
        sold = false
        DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function (userid, jdata)
            if jdata == nil or jdata == "" then
                jdata = '[]'
            end
            local data = cjson.decode(jdata)
            local key = idPlayer.."_"..os.time()
            data[key] = o:toTable()
            print(Lib.pv(data[key]))
            DBHandler:setData(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, cjson.encode(data), true)
        end)
    end

    function o:buy(playerBuy)
        local function trade()
            playerBuy:startTransaction()
            if not playerBuy:spendMoney(price) then
                playerBuy:rollbackTransaction()
                return false
            end
            if not playerBuy:addItemInBalo(idItem, quantily) then
                playerBuy:rollbackTransaction()
                return false
            end
            playerBuy:commitTransaction()
            playerBuy:save(false)
            sold = true            
            return true
        end
        trade()
        DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function (userid,jdata)
            local data = cjson.decode(jdata)
            local player =  Gol.Player[idPlayer]
            if player ~= nil then
                player:increaseMoney(price)
                data[key] = nil    
            else
                data[key].sold = true
            end
            DBHandler:setData(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, cjson.encode(data), true)
        end)        
    end
    
    function o:receiveMoney()
        local player =  Gol.Player[idPlayer]
        player:increaseMoney(price)
        DBHandler:getDataByUserId(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, function (userid,jdata)
            local data = cjson.decode(jdata)
            data[key] = nil            
            DBHandler:setData(Gol.subKey.BlackMarket, Gol.dataKey.BlackMarket, cjson.encode(data), true)
        end)
    end

    return o
end)

return BlackMarket