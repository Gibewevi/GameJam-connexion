local MissionModel = {}
function MissionModel.new(rows, cols)
    local mission = {}
    mission.cols = cols
    mission.rows = rows
    mission.maxNumbers = 4
    mission.numbersAvailable = {}
    mission.numbers = {}
    mission.controller = nil

    function mission:init(gridNumbers, gridMissions)
        local missionNumbersAlreadyInUse = mission:concatenatesMissionsTableInFirst(gridMissions)
        self.numbersAvailable = self:availableNumbers(missionNumbersAlreadyInUse, gridNumbers)
        local numberMission = self:getRandomAvailableNumbers()
        table.insert(self.numbers, numberMission)
        self:chooseAvailableNeighbors(numberMission)
        -- print("mission ------------")
        -- for i = 1, #self.numbers do
        --     print("number ",self.numbers[i].value)
        -- end
        -- print("mission ------------")
    end

    function mission:concatenatesMissionsTableInFirst(gridMissions)
        local numbersMission = {}
        for i = 1, #gridMissions do
            for j = 1, #gridMissions[i].numbers do
                table.insert(numbersMission, gridMissions[i].numbers[j])
            end
        end
        return numbersMission
    end

    function mission:availableNumbers(missionNumbers, gridNumbers)
        local numbersAvailable = {}
        for i = 1, #gridNumbers do
            local found = false
            for j = 1, #missionNumbers do
                if gridNumbers[i].row == missionNumbers[j].row and gridNumbers[i].col == missionNumbers[j].col then
                    found = true
                    j = #missionNumbers
                end
            end
            if not found then
                table.insert(numbersAvailable, gridNumbers[i])
            end
        end
        return numbersAvailable
    end

    function mission:getRandomAvailableNumbers()
        local random = math.random(1, #self.numbersAvailable)
        local number = {}
        number.col = self.numbersAvailable[random].col
        number.row = self.numbersAvailable[random].row
        number.value = self.numbersAvailable[random].value
        self:removeAvailableNumberbyId(random)
        return number
    end

    function mission:getNumbersAvailableByColRow(col, row)
        for i, j in ipairs(self.numbersAvailable) do
            if j.col == col and j.row == row then
                return i
            end
        end
    end

    function mission:addController(model)
        self.controller = model
    end

    function mission:chooseAvailableNeighbors(number)
        local missionCol, missionRow = number.col, number.row
        local neighborsAvailable = self:neighborsAvailable(number)
        self:addNumbersNeighbors(neighborsAvailable)
    end

    function mission:addNumbersNeighbors(neighborsTable)
        local neighborsAvailable = neighborsTable

        for i = 1, self.maxNumbers do
            if #neighborsAvailable ~= 0 then
                local randomNeighbor = math.random(1, #neighborsAvailable)
                table.insert(self.numbers, neighborsAvailable[randomNeighbor])
                table.remove(neighborsAvailable, randomNeighbor)
            end
        end
    end

    function mission:neighborsAvailable(number)
        local neighborsAvailable = {}

        for row = -1, 1 do
            for col = -1, 1 do
                local indexRowNeighbor = number.row + row
                local indexColNeighbor = number.col + col
                if self:isAvailable(indexColNeighbor, indexRowNeighbor) then
                    local number = self:getNumberAvailableByColRow(indexColNeighbor, indexRowNeighbor)
                    table.insert(neighborsAvailable, number)
                end
            end
        end  
        return neighborsAvailable
    end


    function mission:removeAvailableNumberbyColRow(col, row)
        for i, j in ipairs(self.numbersAvailable) do
            if j.col == col and j.row == row then
                table.remove(self.numbersAvailable, i)
            end
        end
    end

    function mission:removeAvailableNumberbyId(id)
        table.remove(self.numbersAvailable, id)
    end

    function mission:isAvailable(col, row)
        for i, j in ipairs(self.numbersAvailable) do
            if j.col == col and j.row == row then
                return true
            end
        end
        return false
    end

    function mission:getNumberAvailableByColRow(col, row)
        for i, j in ipairs(self.numbersAvailable) do
            if j.col == col and j.row == row then
                return j
            end
        end
    end

    return mission
end

return MissionModel
