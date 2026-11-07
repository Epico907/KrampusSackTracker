local _G = GLOBAL
local Text = require "widgets/text"

local UPDATE_INTERVAL = 1
local SEARCH_RADIUS = 5000
local FONT_SIZE = 28

local function FindNearestLootStash(player)
    if player == nil or player.Transform == nil then
        return nil
    end

    local px, py, pz = player.Transform:GetWorldPosition()
    local nearest = nil
    local nearest_distance_sq = nil

    for _, entity in pairs(_G.Ents) do
        if entity ~= nil
            and entity.prefab == "klaus_sack"
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

AddClassPostConstruct("widgets/controls", function(self)
    local player = self.owner
    if player == nil or self.klaus_stash_tracker ~= nil then
        return
    end

    -- Mantém o indicador na mesma posição já ajustada acima do inventário.
    local anchor = self.bottom_root or self
    local tracker = anchor:AddChild(Text(_G.CHATFONT, FONT_SIZE, "Loot Stash: procurando..."))
    tracker:SetHAlign(_G.ANCHOR_MIDDLE)
    tracker:SetVAlign(_G.ANCHOR_MIDDLE)
    tracker:SetRegionSize(520, 50)
    tracker:SetPosition(0, 115, 0)
    tracker:Show()

    self.klaus_stash_tracker = tracker

    player:DoPeriodicTask(UPDATE_INTERVAL, function()
        if self.klaus_stash_tracker ~= tracker then
            return
        end

        if not player:IsValid() then
            tracker:Hide()
            return
        end

        local stash, distance, px, pz = FindNearestLootStash(player)
        if stash ~= nil then
            local sx, sy, sz = stash.Transform:GetWorldPosition()
            tracker:SetString(string.format("Loot Stash %s  |  %.0f", GetDirectionArrow(sx - px, sz - pz), distance))
        else
            tracker:SetString("Loot Stash: não detectada")
        end
        tracker:Show()
    end)
end)
