local Config = require("shared.config");
local Match = require("server.modules.match");

local Module = {};
Module.__index = Module;

---@param source number
---@param message string|nil
---@return void
function Module:Notify(source, message)
    if not message or source <= 0 then
        return;
    end;

    TriggerClientEvent("ox_lib:notify", source, {
        title = locale("title"),
        description = message,
        type = "error",
    });
end;

---@param args string[]
---@return string
function Module:GetMessage(args)
    return table.concat(args, " ");
end;

---@return void
function Module:Register()
    RegisterCommand(Config.Commands.Join, function(source)
        local success, error = Match:AddPlayer(source);

        if not success then
            self:Notify(source, error);
        end;
    end, false);

    RegisterCommand(Config.Commands.Leave, function(source)
        local success, error = Match:RemovePlayer(source);

        if not success then
            self:Notify(source, error);
        end;
    end, false);

    RegisterCommand(Config.Commands.Announce, function(source, args)
        local success, error = Match:Announce(self:GetMessage(args));

        if not success then
            self:Notify(source, error);
        end;
    end, true);

    RegisterCommand(Config.Commands.Finish, function(source, args)
        local message = self:GetMessage(args);

        if message == "" then
            message = locale("finish_announcement");
        end;

        local success, error = Match:Finish(message);

        if not success then
            self:Notify(source, error);
        end;
    end, true);
end;

return Module;
