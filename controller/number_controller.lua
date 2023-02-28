local NumberController = {}
    function NumberController.new(model)
        local controller = {}
        controller.number = model
        controller.view = nil

        return controller
    end
return NumberController