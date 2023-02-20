local NumberModel = {}
function NumberModel.new(value, x, y)
    local number = {}
    number.value = value
    number.x = x
    number.y = y
    number.row = nil
    number.col = nil
    number.s = 1
    number.w = nil
    number.h = nil
    number.isHover = false

    function number:setColumn(column)
        self.col = column
    end

    function number:setRow(row)
        self.row = row
    end

    return number
end

return NumberModel
