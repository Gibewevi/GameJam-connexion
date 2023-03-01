local GridController = {}

function GridController.new(model)
    local controller = {}
    controller.model = model

    function controller:update(dt)
        self:updateIsHoverNumberStatus()
        self:updateNumbers(dt)
        self:validNumbers()
    end

    function controller:updateNumbers(dt)
        for i = 1, #self.model.numbers do
            self.model.numbers[i].controller:update(dt)
        end
    end

    function controller:validNumbers()
        if self:numberIsHover() then
            local number = self:getNumberHover()
            if self:isNumberAssignedToMission(number) then
                if self:isNumbersValidTableNotEmpty() then
                    if self:isInCurrentMission(number) then
                        if self:isNumberNotValid(number) then
                            self:setNumberIsValid(number)
                            self:addNumbersInNumbersValid(number)
                            return
                        end
                    else
                        self:invalidatedNumbers()
                        self:setNumberIsValid(number)
                        table.insert(self.model.numbersValid, number)
                        return
                    end
                else
                    self:setNumberIsValid(number)
                    table.insert(self.model.numbersValid, number)
                    return
                end
            else
                self:invalidatedNumbers()
            end
        end
    end

    function controller:invalidatedNumbers()
        local actualOrder = self:getActualMissionOrder()
            for i,j in ipairs(self.model.numbers) do
                if j.missionOrder == actualOrder then
                    j.isValid = false
                end
            end
        self.model.numbersValid = {}
    end

    function controller:setNumberIsValid(number)
        for i,j in ipairs(self.model.numbers) do
            if j.col == number.col and j.row == number.row then
                j.isValid = true
                print("value ",j.value," ",j.isValid)
            end
        end
    end

    function controller:addNumbersInNumbersValid(number)
        -- ajoute le numéro dans numbersValid
        table.insert(self.model.numbersValid, number)
        if self:isMissionComplete() then
            self:missionComplete()
        end
    end

    function controller:missionComplete()
        local orderMission = self:getActualMissionOrder()
        for i = #self.model.numbers, 1, -1 do
            local number = self.model.numbers[i]
            if number.missionOrder == orderMission then
                table.remove(self.model.numbers, i)
            end
        end
    end
    

    function controller:isMissionComplete()
        local orderActualMission = self:getActualMissionOrder()
        if self:getNumbersMaxByOrderMission(orderActualMission) == #self.model.numbersValid then
            return true
        end
        return false
    end

    function controller:getNumbersMaxByOrderMission(order)
        for i = 1, #self.model.missions do
            if self.model.missions[i].order == order then
                return #self.model.missions[i].numbers
            end
        end
    end

    function controller:isNumberNotValid(number)
        for i, j in ipairs(self.model.numbersValid) do
            if number.col == j.col and number.row == j.row then
                return false
            end
        end
        return true
    end

    function controller:isInCurrentMission(number)
        local order = self:getActualMissionOrder()
        if self:numberIsInActualMission(number, order) then
            return true
        end
        return false
    end

    function controller:numberIsInActualMission(number, order)
        for i = 1, #self.model.missions do
            if self.model.missions[i].order == order then
                for i, j in ipairs(self.model.missions[i].numbers) do
                    if j.col == number.col and j.row == number.row then
                        return true
                    end
                end
            end
        end
        return false
    end

    function controller:getActualMissionOrder()
        if #self.model.numbersValid ~= 0 then
            local order = self.model.numbersValid[1].missionOrder
            return order 
        end
    end

    function controller:isNumbersValidTableNotEmpty()
        if #self.model.numbersValid ~= 0 then
            return true
        end
        return false
    end

    function controller:getNumberHover()
        return self.model.numberHover
    end

    function controller:isNumberAssignedToMission(number)
        for i = 1, #self.model.missions do
            for j = 1, #self.model.missions[i].numbers do
                if number.col == self.model.missions[i].numbers[j].col and
                    number.row == self.model.missions[i].numbers[j].row then
                    return true
                end
            end
        end
    end

    function controller:numberIsHover()
        if self.model.numberHover ~= nil then
            return true
        end
        return false
    end

    function controller:setNumbersHover(number)
        self.model.numberHover = number
    end

    function controller:updateIsHoverNumberStatus()
        local mouseX, mouseY = love.mouse:getPosition()
        for i = 1, #self.model.numbers do
            local number = self.model.numbers[i]
            if mouseX > number.x - number.w and mouseX < number.x + number.w and
                mouseY > number.y - number.h and mouseY < number.y + number.h then
                number.isHover = true
                self:setNumbersHover(number)
            else
                number.isHover = false
            end
        end
    end

    return controller
end

return GridController
