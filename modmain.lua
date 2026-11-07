local _G = GLOBAL
local Text = require "widgets/text"

local UPDATE_INTERVAL = 1
local SEARCH_RADIUS = 5000
local FONT_SIZE = 25

local function FindNearestEntity(player, prefab)
    if player == nil or player.Transform == nil then
        return nil
    end

    local px, py, pz = player.Transform:GetWorldPosition()
    local nearest = nil
    local nearest_distance_sq = nil

    for _, entity in pairs(_G.Ents) do
        if entity ~= nil
            and entity.prefab == prefab
            and entity.Transform ~= nil
            and (entity.IsValid == nil or entity:IsValid()) then

            local x, y, z = entity.Transform:GetWorldPosition()
            local dx = x - px
            local dz = z - pz
            local distance_sq = dx * dx + dz * dz

            if distance_sq <= SEARCH_RADIUS * SEARCH_RADIUS
                and (nearest_distance_sq == nil or distance_sq < nearest_distance_sq) then
                nearest = entity
                nearest_distance_sq = distance_sq
            end
        end
    end

    if nearest ~= nil then
        return nearest, math.sqrt(nearest_distance_sq), px, pz
    end

    return nil
end

local function GetDirectionArrow(dx, dz)
    local angle = math.atan2(dz, dx)
    local octant = math.floor(angle / (math.pi / 4) + 0.5) % 8
    local arrows = {
        [0] = "→", [1] = "↗", [2] = "↑", [3] = "↖",
        [4] = "←", [5] = "↙", [6] = "↓", [7] = "↘",
    }
    return arrows[octant]
end

local function GetTrackerLine(player, prefab, label, not_found)
    local entity, distance, px, pz = FindNearestEntity(player, prefab)
    if entity ~= nil then
        local x, y, z = entity.Transform:GetWorldPosition()
        return string.format("%s %s  |  %.0f", label, GetDirectionArrow(x - px, z - pz), distance)
    end
    return not_found
end

AddClassPostConstruct("widgets/controls", function(self)
    local player = self.owner
    if player == nil or self.klaus_event_tracker ~= nil then
        return
    end

    -- Mantém o indicador na posição já ajustada acima do inventário.
    local anchor = self.bottom_root or self
    local tracker = anchor:AddChild(Text(_G.CHATFONT, FONT_SIZE, "Loot Stash: procurando...\nDeer Antler: procurando..."))
    tracker:SetHAlign(_G.ANCHOR_MIDDLE)
    tracker:SetVAlign(_G.ANCHOR_MIDDLE)
    tracker:SetRegionSize(560, 76)
    tracker:SetPosition(0, 115, 0)
    tracker:Show()

    self.klaus_event_tracker = tracker

    player:DoPeriodicTask(UPDATE_INTERVAL, function()
        if self.klaus_event_tracker ~= tracker then
            return
        end

        if not player:IsValid() then
            tracker:Hide()
            return
        end

        local stash_line = GetTrackerLine(player, "klaus_sack", "Loot Stash", "Loot Stash: não detectada")
        local antler_line = GetTrackerLine(player, "deer_antler", "Deer Antler", "Deer Antler: não detectada")
        tracker:SetString(stash_line .. "\n" .. antler_line)
        tracker:Show()
    end)
end)
