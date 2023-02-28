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
    grid.missions = {}

    function grid:init()
        self.cells = {}
        for i = 1, self.rows do
            self.cells[i] = {}
            for j = 1, self.cols do
                self.cells[i][j] = 0
                self:addNumber(j,i)
            end
        end
        self:generateMission()
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

    function grid:generateMission()
        local mission = missionModel.new(self.rows, self.cols)
        mission:init(self.numbers, self.missions)
        mission:addController(mission)
        table.insert(self.missions, mission)
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
