local Module = {};
Module.__index = Module;

---@class SpectateData
---@field active boolean
---@field target number|nil
---@field timer table|nil

---@type SpectateData
Module.Data = {
    active = false,
    target = nil,
    timer = nil,
};

---@param target number
---@param duration number
---@return void
function Module:Start(target, duration)
    self:Stop();

    self.Data.active = true;
    self.Data.target = target;

    local targetPed = GetPlayerPed(GetPlayerFromServerId(target));

    NetworkSetInSpectatorMode(true, targetPed);

    if duration and duration > 0 then
        self.Data.timer = lib.timer(duration * 1000, function()
            self:Stop();
        end);
    end;
end;

---@return void
function Module:Stop()
    if self.Data.timer then
        self.Data.timer:forceEnd(false);
        self.Data.timer = nil;
    end;

    NetworkSetInSpectatorMode(false, 0);
    self.Data.active = false;
    self.Data.target = nil;
end;

---@return boolean
function Module:IsActive()
    return self.Data.active;
end;

return Module;
