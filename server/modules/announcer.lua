local Config = require("shared.config");
local Registry = require("shared.events.registry");
local Events = require("shared.events.names");

local Module = {};
Module.__index = Module;

---@param message string
---@return boolean, string|nil
function Module:ValidateMessage(message)
    if type(message) ~= "string" or message == "" then
        return false, locale("announce_missing");
    end;

    if #message > Config.AnnouncementMaxLength then
        return false, locale("announce_too_long", Config.AnnouncementMaxLength);
    end;

    return true, nil;
end;

---@param target number
---@param message string
---@return void
function Module:SendToPlayer(target, message)
    Registry:Get(Events.Announce):FireClient(target, message);
end;

---@param players table<number, BattleroyalePlayer>
---@param message string
---@return boolean, string|nil
function Module:SendToPlayers(players, message)
    local valid, error = self:ValidateMessage(message);

    if not valid then
        return false, error;
    end;

    for source in pairs(players) do
        self:SendToPlayer(source, message);
    end;

    return true, nil;
end;

return Module;
