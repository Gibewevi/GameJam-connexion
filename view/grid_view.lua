
local GridView = {}

function GridView.new(model)
    local view = {}
    view.grid = model

    function view:drawNumbers()
        for i = 1, #self.grid.numbers do
            self.grid.numbers[i].controller.view:draw()
        end
    end

    function view:draw()
        local cellSize = self.grid.cellSize

        for i = 1, #self.grid.cells do
            for j = 1, #self.grid.cells[i] do
                love.graphics.rectangle(
                    'line',
                    self.grid.x + (j - 1) * self.grid.cellSize,
                    self.grid.y + (i - 1) * self.grid.cellSize,
                    cellSize,
                    cellSize
                )
            end
        end
        self:drawNumbers()
    end

    return view
end

return GridView
