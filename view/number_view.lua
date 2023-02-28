local NumberView = {}
function NumberView.new(model)
    local view = {}
    view.number = model

    function view:drawNumbersOnMission()
        love.graphics.setFont(self.number.font)
        if self.number.onMission then
            love.graphics.setColor(220/255,72/255,49/255,1)
            love.graphics.print(self.number.value, self.number.x, self.number.y, 0, self.number.s, self.number.s)
            love.graphics.setColor(1,1,1,1)
        end
    end

    function view:drawNumbersIsAvailable()
        love.graphics.setFont(self.number.font)
        if self.number.isAvailable then
            love.graphics.setColor(107/255,235/255,72/255,1)
            love.graphics.print(self.number.value, self.number.x, self.number.y, 0, self.number.s, self.number.s)
            love.graphics.setColor(1,1,1,1)
        end
    end

    function view:draw()
        self:drawNumbersIsAvailable()
        self:drawNumbersOnMission()
    end
    
    return view
end
return NumberView