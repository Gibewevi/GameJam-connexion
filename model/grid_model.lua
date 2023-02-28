local numberModel = require('model.number_model')
local missionModel = require('model.mission_model')

local GridModel = {}

function GridModel.new(rows, cols, posX, posY)
    local grid = {}
    grid.__index = grid
    grid.rows = rows
    grid.cols = cols
    grid.x, grid.y = posX, posY
    grid.w = 0
    grid.h = 0
    grid.cellSize = (love.graphics.getWidth() / grid.cols)
    grid.cells = {}
    grid.numbers = {}
    grid.numberHover = {}
    grid.missions = {}
    grid.numbersValid = {}
    grid.numbersAvailable = {}
    grid.maxMission = math.random(3,6)

    function grid:init()
        self.cells = {}
        for i = 1, self.rows do
            self.cells[i] = {}
            for j = 1, self.cols do
                self.cells[i][j] = 0
                self:addNumber(j,i)
            end
        end
        self:generationAllMissions(self.maxMission)
        setmetatable(self.cells, self)
        return self.cells
    end

    function grid:addNumber(col, row)
        local number = numberModel.new(self:getCellPosX(col),self:getCellPosY(row), self.cellSize)
        number:initPosXY()
        number:addController()
        number:addView()
        number:setColumn(col)
        number:setRow(row)
        table.insert(self.numbers, number)
    end

    function grid:numbersIsAvailable()
        -- concatenates all missions
        local numbersMission = self:concatenatesMissionsTables()
        local numbersAvailable = self:availableNumbers(numbersMission)

    end


    function grid:setNumberMissionOrder(missionNumbers)
        for i = 1, #self.numbers do
            for j,k in ipairs(missionNumbers) do
                if k.col == self.numbers[i].col and k.row == self.numbers[i].row then
                    self.numbers[i].missionOrder = k.order
                end
            end
        end
    end

    function grid:generationAllMissions(nbMissions)
        for i = 1, nbMissions do
            local mission = missionModel.new(self.rows, self.cols, #self.missions+1)
            mission:init(self.numbers, self.missions)
            self:setNumberMissionOrder(mission.numbers)
            mission:addController(mission)
            table.insert(self.missions, mission)
        end
        self:modifyStatusNumbersOnMission()
    end

    function grid:concatenatesMissionsOnOne()
        local numbersMissions = {}
        for i = 1, #self.missions do
            for j = 1, #self.missions[i].numbers do
                 table.insert(numbersMissions, self.missions[i].numbers[j])
            end
        end
        return numbersMissions
    end

    function grid:modifyStatusNumbersOnMission()
            local numbersMission = self:concatenatesMissionsOnOne()
            local numberAvailable = {}
            for i = 1, #self.numbers do
                local found = false
                for j = 1, #numbersMission do
                    if self.numbers[i].row == numbersMission[j].row and self.numbers[i].col == numbersMission[j].col then
                        found = true
                        j = #numbersMission
                    end
                end
                if not found then
                    self.numbers[i].isAvailable = true
                    self.numbers[i].onMission = false
                    table.insert(numberAvailable, self.numbers[i])
                else
                    self.numbers[i].onMission = true
                    self.numbers[i].isAvailable = false
                end
            end
    end

    function grid:setCellSize(size)
        self.cellSize = size or (love.graphics.getWidth() / self.numCols)
    end

    function grid:updateDimension()
        self.w = self.x + (self.cols * self.cellSize)
        self.h = self.y + (self.rows * self.cellSize)
    end

    function grid:getCellPosX(col)
        local posX = self.x + ((col - 1) * self.cellSize)
        return posX
    end

    function grid:getCellPosY(row)
        local posY = self.y + ((row - 1) * self.cellSize)
        return posY
    end

    return grid
end

return GridModel
