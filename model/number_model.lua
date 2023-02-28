local numberController = require('controller.number_controller')
local numberView = require('view.number_view')

local NumberModel = {}
function NumberModel.new(x, y, cellSize)
    local number = {}
    number.value = tostring(math.random(0,9))
    number.font = love.graphics.newFont(22)
    number.s = 1
    number.w = number.font:getWidth(number.value)*number.s
    number.h = number.font:getHeight(number.value)*number.s
    number.cellX = x
    number.cellY = y
    number.x = x
    number.y = y
    number.row = nil
    number.col = nil
    number.missionOrder = nil
    number.cellSize = cellSize
    number.isHover = false
    number.isAvailable = false
    number.onMission = false
    number.controller = nil
    number.valid = nil

    function number:initPosXY()
        self:initPosX()
        self:initPosY()
    end

    function number:initPosX()
        self.x = self.x + (self.cellSize/2) - (self.w/2)
    end

    function number:initPosY()
        self.y = self.y + (self.cellSize/2) - (self.h/2)
    end

    function number:setColumn(column)
        self.col = column
    end

    function number:setRow(row)
        self.row = row
    end

    function number:addController()
        local controller = numberController.new(self)
        self.controller = controller
    end
    
    function number:addView()
        self.controller.view = numberView.new(self)
    end

    return number
end

return NumberModel
