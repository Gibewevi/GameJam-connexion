local MissionModel = {}
function MissionModel.new(rows, cols)
    local mission = {}
    mission.cols = cols
    mission.rows = rows
    mission.maxNumbers = math.random(1,4)
    mission.numberAvailable = {}
    mission.numbers = {}
    mission.controller = nil

    function mission:init(gridNumbers, gridMissions)
        -- concaténer toutes les valeurs de gridMissions dans un autre tableau
        local missionNumbersAlreadyInUse = mission:concatenatesMissionsTableInFirst(gridMissions)
        -- récuperer toutes les nombres disponibles
        self.numberAvailable = self:availableNumbers(missionNumbersAlreadyInUse,gridNumbers)
        -- selectionné le nombre épicentre de la mission
        local numberMission = self:chooseRandomAvailableNumbers()
        self:chooseAvailableNeighbors(numberMission)
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
        local numberAvailable = {}
            for i = 1, #gridNumbers do
                local found = false
                for j = 1, #missionNumbers do
                    if gridNumbers[i].row == missionNumbers[j].row and gridNumbers[i].col == missionNumbers[j].col then
                        found = true
                        j = #missionNumbers
                    end
                end
                if not found then
                    table.insert(numberAvailable, gridNumbers[i])
                end
            end
        for i = 1, #numberAvailable do
            print("available value ",numberAvailable[i].value)
        end
        return numberAvailable
    end

    function mission:chooseRandomAvailableNumbers()
        local random = math.random(1,#self.numberAvailable)
        local number = {}
        number.col = self.numberAvailable[random].col
        number.row = self.numberAvailable[random].row
        number.value = self.numberAvailable[random].value
        self:removeAvailableNumberbyId(random)
        return number
    end

    function mission:getNumbersAvailableByColRow(col, row)
        for i,j in ipairs(self.numberAvailable) do
            if j.col == col and j.row == row then
                return i
            end
        end
    end

    function mission:addController(model)
        self.controller = model
    end

    function mission:chooseAvailableNeighbors(numberMission)
        local neighborCol, neighborRow
        local missionCol, missionRow = numberMission.col, numberMission.row
        -- mettre à jour pendant la boucle

        for i = 1, self.maxNumbers-1 do
            repeat
                local foundNeighbor = false
                neighborCol = math.random(-1, 1)
                neighborRow = math.random(-1, 1)
                local indexNeighborCol = missionCol + neighborCol
                local indexNeighborRow = missionRow + neighborRow
                -- parcourir liste nombreAvailable jusqu'au nombre séléctionné
                if self:isAvailable(indexNeighborCol, indexNeighborRow) then
                    local numberId = self:getNumbersAvailableByColRow(indexNeighborCol, indexNeighborRow)
                    table.insert(self.numbers, self.numberAvailable[numberId])
                    self:removeAvailableNumberbyColRow(indexNeighborCol, indexNeighborRow)
                    foundNeighbor = true
                end
            until neighborCol ~= 0 and neighborRow ~= 0 and foundNeighbor ~= false
            return nil 
        end
    end

    function mission:removeAvailableNumberbyColRow(col, row)
        for i,j in ipairs(self.numberAvailable) do
            if j.col == col and j.row == row then
                table.remove(self.numberAvailable,i)
            end
        end
    end

    function mission:removeAvailableNumberbyId(id)
        table.remove(self.numberAvailable,id)
    end

    function mission:isAvailable(col, row)
        for i,j in ipairs(self.numberAvailable) do
            if j.col == col and j.row == row then
                return true
            end
        end
        return false
    end

    return mission
end
return MissionModel