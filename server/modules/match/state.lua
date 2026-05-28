local Module = {};
Module.__index = Module;

---@class BattleroyaleMatchState
---@field active boolean
---@field queuing boolean
---@field timer table|nil

---@type BattleroyaleMatchState
Module.Data = {
    active = false,
    queuing = false,
    timer = nil,
};

---@return boolean
function Module:IsActive()
    return self.Data.active;
end;

---@return boolean
function Module:IsQueuing()
    return self.Data.queuing;
end;

---@param active boolean
---@return void
function Module:SetActive(active)
    self.Data.active = active;
end;

---@param queuing boolean
---@return void
function Module:SetQueuing(queuing)
    self.Data.queuing = queuing;
end;

---@param duration number
---@param callback function
---@return void
function Module:SetTimer(duration, callback)
    self:CancelTimer();

    self.Data.timer = lib.timer(duration, callback);
end;

---@return void
function Module:CancelTimer()
    if not self.Data.timer then
        return;
    end;

    self.Data.timer:forceEnd(false);
    self.Data.timer = nil;
end;

---@return void
function Module:Reset()
    self:CancelTimer();

    self.Data.active = false;
    self.Data.queuing = false;
end;

return Module;
