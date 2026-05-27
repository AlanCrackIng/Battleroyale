local Config = require("shared.config");
local Arena = require("client.modules.arena");
local ClientEvents = require("client.events");

ClientEvents.Start:Connect(function()
    Arena:Start();
end);

ClientEvents.Finish:Connect(function(message)
    Arena:Finish();

    if message then
        lib.notify({
            title = "Battle Royale",
            description = message,
            type = "success",
            duration = Config.AnnouncementDuration,
        });
    end;
end);

ClientEvents.Announce:Connect(function(message)
    lib.notify({
        title = "Battle Royale",
        description = message,
        type = "inform",
        duration = Config.AnnouncementDuration,
    });
end);
