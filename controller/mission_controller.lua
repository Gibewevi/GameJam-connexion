local MissionController = {}
    function MissionController.new(model)
        local controller = {}
        controller.mission = model
        controller.view = nil
    end
return MissionController