return function(obj, x, y, z, time, isThroughBlock, callBack)
    local function shortenedVector(x, y, z, speed)
        local v = {}
        v.x = x / (math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) / speed)
        v.y = y / (math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) / speed)
        v.z = z / (math.sqrt(x ^ 2 + y ^ 2 + z ^ 2) / speed)
        return Vector3.new(v.x, v.y, v.z)
    end
    local curvt = obj:curBlockPos()
    local speed = math.abs(math.sqrt((x) ^ 2 + (y) ^ 2 + (z) ^ 2)) / time
    local newvt = shortenedVector(x, y, z, speed)
    World.Timer(2, function()
        if (time <= 0) then
            callBack()
            return false
        end
        if (isThroughBlock) then
            local curvt = obj:curBlockPos()
            obj:setPos(curvt + newvt)
            time = time - 1
            return 1
        else
            local map = World.CurWorld:getMap("map001")
            local curvt = obj:curBlockPos()
            local toalVt = curvt + newvt
            local shVt = shortenedVector(toalVt.x,toalVt.y,toalVt.z,1)
            local data = map:getBlock(shVt)
            print(Lib.pv(data))
            if data.fullName == "/air" then                
                obj:setPos(curvt + newvt)
                time = time - 1
                return 1
            end
            return false
        end

    end)
end
