local NumberView = {}
function NumberView.new(model)
    local view = {}
    view.number = model

    function view:draw()
        love.graphics.setFont(love.graphics.newFont(32))
        love.graphics.print(self.number.value, self.number.x, self.number.y)
    end
    
    return view
end
return NumberView