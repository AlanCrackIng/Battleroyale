local Config = require("shared.config");
local Arena = require("client.modules.arena");
local Spectate = require("client.modules.spectate");
local ClientEvents = require("client.events");

ClientEvents.Start:Connect(function()
    Arena:Start();
end);

ClientEvents.Finish:Connect(function(message)
    Arena:Finish();
    Spectate:Stop();

    if message then
        lib.notify({
            title = locale("title"),
            description = message,
            type = "success",
            duration = Config.AnnouncementDuration,
        });
    end;
end);

ClientEvents.PlayerDied:Connect(function()
    lib.notify({
        title = locale("title"),
        description = locale("death_you_died"),
        type = "error",
        duration = Config.AnnouncementDuration,
    });
end);

ClientEvents.Spectate:Connect(function(target, duration)
    Spectate:Start(target, duration);
end);

ClientEvents.Shrink:Connect(function(radius)
    Arena:UpdateBoundary(radius);
end);

ClientEvents.Announce:Connect(function(message)
    lib.notify({
        title = locale("title"),
        description = message,
        type = "inform",
        duration = Config.AnnouncementDuration,
    });
end);
