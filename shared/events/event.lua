local Registry = require("shared.events.registry")

local Module = {}
Module.__index = Module;

---@param name string
---@return Module
function Module.new(name)
    local self = setmetatable({}, Module);
    self.Callbacks = {};
    self.Name = name;

    return self;
end;

---@param cb function
---@return void 
function Module:Connect(cb)
    table.insert(self.Callbacks, cb);
end;

---@return Module
function Module:RegisterNetEvent()
    RegisterNetEvent(self.Name, function(...)
        for _, cb in pairs(self.Callbacks) do
            cb(...);
        end;
    end);
 
    Registry:RegisterEvent(self.Name, self);

    return self;
end;

return Module;