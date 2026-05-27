local Module = {};
Module.__index = Module;

---@param source number
---@param items BattleroyaleLoadoutItem[]
---@return void
function Module:GiveItems(source, items)
    for _, item in pairs(items) do
        exports.ox_inventory:AddItem(source, item.name, item.count, item.metadata);
    end;
end;

---@param source number
---@param items BattleroyaleLoadoutItem[]
---@return void
function Module:RemoveItems(source, items)
    for _, item in pairs(items) do
        exports.ox_inventory:RemoveItem(source, item.name, item.count, item.metadata);
    end;
end;

return Module;
