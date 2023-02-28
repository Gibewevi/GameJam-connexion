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
        local minFontSize = 1
        local maxFontSize = 1.5
        
        if not self.number.isHover then
            self.number.s = math.max(self.number.s - (factor * dt), minFontSize)
            if self.number.s > minFontSize then
                self:updateDimensionFont()
                self:updatePosXY()
            end
        else
            self.number.s = math.min(self.number.s + (factor * dt), maxFontSize)
            if self.number.s < maxFontSize then
                self:updateDimensionFont()
                self:updatePosXY()
            end
        end
    end
    

    function controller:updatePosXY()
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
