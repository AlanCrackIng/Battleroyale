local Match = require("server.modules.match");
local ServerEvents = require("server.events");

ServerEvents.Join:Connect(function()
    local player = source;

    Match:AddPlayer(player);
end);

ServerEvents.Leave:Connect(function()
    local player = source;

    Match:RemovePlayer(player);
end);

AddEventHandler("playerDropped", function()
    local player = source;

    Match:RemovePlayer(player);
end);
