local Registry = {};
Registry.Events = {};

---@param name string
---@param event Event
---@return void
function Registry:RegisterEvent(name, event)
    self.Events[name] = event;
end;

---@param name string
---@return Event
function Registry:Get(name)
    return self.Events[name];
end;

return Registry;