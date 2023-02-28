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
            -- SI le numéro est dans une mission
            if self:isNumberAssignedToMission(number) then
                -- SI la table numbersValid contient déjà quelque chose
                if self:isNumbersValidTableNotEmpty() then
                    -- SI le numéro fait bien partie de la même mission
                    if self:isInCurrentMission(number) then
                        table.insert(self.model.numbersValid, number)
                        for i,j in ipairs(self.model.numbersValid) do
                            print('i', i, ' ', j.value)
                        end
                        -- ajoute le numéro dans numbersValid
                            -- SI si la série est complète
                            -- valider la mission et supprimer les nombres
                            -- supprimer la table numbersValid pour une nouvelle série
                            -- SINON
                            -- ajoute le numéro dans numbersValid
                    else
                        -- SINON // Supprimer la table numbersValid et rajouté le numéro
                    end
                else
                    -- Ajoute le numéro
                    table.insert(self.model.numbersValid, number)
                    for i,j in ipairs(self.model.numbersValid) do
                        print('i', i, ' ', j.value)
                    end
                end
            else
                -- SINON supprimer la table numbersValid
            end
        end

        -- SI le numéro est dans une mission
        -- SI la table numbersValid contient déjà quelque chose
        -- SI le numéro fait bien partie de la même mission

        -- SI si la série est complète
        -- valider la mission et supprimer les nombres
        -- supprimer la table numbersValid pour une nouvelle série
        -- SINON
        -- ajoute le numéro dans numbersValid
        -- SINON // Supprimer la table numbersValid et rajouté le numéro
        -- SINON supprimer la table numbersValid
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
        print("#self.model.numbersValid", #self.model.numbersValid)
        -- local order = self.model.numbersValid[0].missionOrder
        -- return order
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
            if mouseX > number.x - number.cellSize / 2 and mouseX < number.x + number.cellSize / 2 and
                mouseY > number.y - number.cellSize / 2 and mouseY < number.y + number.cellSize / 2 then
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
