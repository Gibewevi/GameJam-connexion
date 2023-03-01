local NumberController = {}
function NumberController.new(model)
    local controller = {}
    controller.number = model
    controller.view = nil

    function controller:update(dt)
        self:hover(dt)
        self:valid(dt)
    end

    function controller:hover(dt)
        self:updateHover(dt)
    end


    function controller:valid(dt)
        if self.number.isValid then
            local factor = 1.5
            local maxFontSize = 1.5
            -- augmenter la taille jusqu'a 1.5
            if self.number.s < maxFontSize then
                self.number.s = math.min(self.number.s + (factor * dt), maxFontSize)
                self:updateDimensionFont()
                self:updatePosXY()
            end
        end
    end

    function controller:updateHover(dt)
        local factor = 1.2
        local minFontSize = 1
        local maxFontSize = 1.5
        
        if not self.number.isHover and not self.number.isValid then
            self.number.s = math.max(self.number.s - (factor * dt), minFontSize)
            if self.number.s > minFontSize then
                self:updateDimensionFont()
                self:updatePosXY()
            end
        elseif self.number.isHover and not self.number.isValid then
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
