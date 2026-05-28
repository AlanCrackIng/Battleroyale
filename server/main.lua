local Match = require("server.modules.match");
local Commands = require("server.modules.commands");
local ServerEvents = require("server.events");

Commands:Register();

ServerEvents.Leave:Connect(function()
    local player = source;

    Match:RemovePlayer(player);
end);

ServerEvents.Death:Connect(function(killer)
    local player = source;

    if killer and killer <= 0 then
        killer = nil;
    end;

    Match:EliminatePlayer(player, killer);
end);

ServerEvents.ZoneOut:Connect(function()
    local player = source;

    Match:EliminatePlayer(player, nil);
end);

AddEventHandler("playerDropped", function()
    local player = source;

    Match:RemovePlayer(player);
end);
