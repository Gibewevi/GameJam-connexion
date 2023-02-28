io.stdout:setvbuf("no")

local gridModel = require("model.grid_model")
local gridController = require("controller.grid_controller")
local gridView = require("view.grid_view")

function love.load()
    -- models
    Grid = gridModel.new(10, 10, 0, 0)
    Grid:init()
    GridController = gridController.new(Grid)
    GridView = gridView.new(Grid)
end

function love.update(dt)
    GridController:update(dt)
end

function love.draw()
    -- views
    GridView:draw()
end
