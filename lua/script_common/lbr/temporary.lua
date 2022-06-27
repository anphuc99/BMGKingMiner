local rankDataHelper = require "service.rank_helper"
return function(ins)
    function ins:RequestData(key, callback)
        rankDataHelper:getData(self._space, key, function(_, value, rank)
            if callback then
                callback(value, rank)
            end
        end)
    end
end