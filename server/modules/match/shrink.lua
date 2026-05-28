local Config = require("shared.config");

local Module = {};
Module.__index = Module;

---@class BattleroyaleShrinkScheduler
---@field active boolean
---@field stage number
---@field timers table<number, table>

---@type BattleroyaleShrinkScheduler
Module.Data = {
    active = false,
    stage = 1,
    timers = {},
};

---@param broadcast fun(radius: number)
---@return void
function Module:Start(broadcast)
    if not Config.Shrink.Enabled then
        return;
    end;

    if #Config.Shrink.Stages <= 0 then
        return;
    end;

    self.Data.active = true;
    self.Data.stage = 1;
    self.Data.timers = {};

    self:ScheduleStage(1, broadcast);
end;

---@return void
function Module:Stop()
    self.Data.active = false;
    self.Data.stage = 1;

    for _, timer in pairs(self.Data.timers) do
        timer:forceEnd(false);
    end;

    self.Data.timers = {};
end;

---@param stage number
---@param broadcast fun(radius: number)
---@return void
function Module:ScheduleStage(stage, broadcast)
    if not self.Data.active then
        return;
    end;

    local stages = Config.Shrink.Stages;

    if stage > #stages then
        return;
    end;

    local config = stages[stage];

    self.Data.timers[stage] = lib.timer(config.delay, function()
        if not self.Data.active then
            return;
        end;

        if broadcast then
            broadcast(config.radius);
        end;

        self:ScheduleStage(stage + 1, broadcast);
    end);
end;

return Module;
