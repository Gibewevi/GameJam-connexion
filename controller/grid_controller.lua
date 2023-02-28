
local GridController = {}

    function GridController.new(model)
        local controller = {}
        controller.model = model

        function controller:update(dt)
            self:updateIsHoverNumberStatus()
            self:updateNumbers(dt)
        end

        function controller:updateNumbers(dt)
            for i = 1, #self.model.numbers do
                self.model.numbers[i].controller:update(dt)
            end
        end

        function controller:updateIsHoverNumberStatus()
            local mouseX, mouseY = love.mouse:getPosition()
            for i = 1, #self.model.numbers do
                local number = self.model.numbers[i]
                if mouseX > number.x - number.cellSize/2 and mouseX < number.x + number.cellSize/2 and
                mouseY > number.y - number.cellSize/2 and mouseY < number.y + number.cellSize/2 then
                    number.isHover = true
                else 
                    number.isHover = false
                end
            end

        end
        
        return controller
    end

return GridController