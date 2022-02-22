return function (thisDate,thatDate)
    local getThisDate = Lib.getDayStartTime(thisDate)
    local getThatDate = Lib.getDayStartTime(thatDate)
    return (getThatDate - getThisDate)/86400
end