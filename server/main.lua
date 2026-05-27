local Match = require("server.modules.match");
local Commands = require("server.modules.commands");
local ServerEvents = require("server.events");

Commands:Register();

ServerEvents.Leave:Connect(function()
    local player = source;

    Match:RemovePlayer(player);
end);

AddEventHandler("playerDropped", function()
    local player = source;

    Match:RemovePlayer(player);
end);
