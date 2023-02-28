local NumberController = {}
function NumberController.new(model)
    local controller = {}
    controller.number = model
    controller.view = nil

    function controller:update(dt)
        self:hover(dt)
    end

    function controller:hover(dt)
        self:updateHover(dt)
    end

    function controller:updateHover(dt)
        local factor = 1.2
        if not self.number.isHover then
            self.number.s = math.max(self.number.s - (factor*dt), 1)
        else
            self.number.s = math.min(self.number.s + (factor*dt), 1.5)
        end
    end

    function controller:updatePos()
        self.number.x = self.number.cellX + (self.number.cellSize / 2) - (self.number.w / 2)
        self.number.y = self.number.cellY + (self.number.cellSize / 2) - (self.number.h / 2)
    end

    function controller:updateDimensionFont()
        self.number.w = self.number.font:getWidth(self.number.value) * self.number.s
        self.number.h = self.number.font:getHeight(self.number.value) * self.number.s
    end

    return controller
end

return NumberController
