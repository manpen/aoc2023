dofile "..\\quiz01\\s9770652_commons.lua"

local lines = ReadAllLines()
local mods = {}
for _, line in ipairs(lines) do
    local names = line:totable "%a+"
    mods[names[1]] = {}
    local mod = mods[names[1]]
    if line:startswith "%" then
        mod.type = "flip"
        mod.on = false
    elseif line:startswith "&" then
        mod.type = "con"
    end
    mod.from = {}  -- saves the pulses received last
    mod.to = deepcopy(names); table.remove(mod.to, 1)
end
for from, conf in pairs(mods) do
    for _, to in ipairs(conf.to) do
        if not mods[to] then mods[to] = { from = {}, to = {} } end  -- Needed as some modules only receive but never send, so they have no own entry.
        mods[to].from[from] = 0  -- Initially, low pulses are stored.
    end
end

local pCount = {[0] = 0, [1] = 0}  -- 0: low pulse, 1: high pulse
local outgoing = nil; for k, _ in pairs(mods.rx.from) do outgoing = k end  -- There is exactly one (conjunction) module in front of 'rx'.
local cycleCache = {}  -- Saves the button presses at which any module in front of `outgoing` sends a high pulse.
for i = 1, 5000 do  -- All cycles have a length below 5000
    local pulses = {}
    -- Send out initial pulses.
    pCount[0] = pCount[0] + #mods.broadcaster.to + 1
    for _, to in ipairs(mods.broadcaster.to) do
        pulses[#pulses+1] = { "broadcaster", to, 0 }
    end
    -- Repeat until nothing is set out anymore.
    repeat
        local newpulses = {}
        for _, p in ipairs(pulses) do
            local mod = mods[p[2]]
            local pType = 0
            if mod.type == "flip" then  -- flip-flop module
                if p[3] == 1 then  -- Flip-flops do not send anything when receiving high pulses.
                    pType = -1
                else
                    pType = (mod.on and 0) or 1  -- low pulse if on before, else high pulse
                    mod.on = not mod.on
                end
            else  -- conjunction module
                mod.from[p[1]] = p[3]
                for _, rem in pairs(mod.from) do
                    if rem == 0 then  -- If even one low pulse is received, a high pulse is sent out.
                        pType = 1
                        break
                    end
                end
            end
            if pType >= 0 then  -- pType might be `-1` if a flip-flop received a high pulse.
                pCount[pType] = pCount[pType] + #mod.to
                for _, to in ipairs(mod.to) do
                    newpulses[#newpulses+1] = { p[2], to, pType }
                    if to == outgoing and pType == 1 then
                        cycleCache[p[2]] = cycleCache[p[2]] or {}
                        cycleCache[p[2]][i] = true
                    end
                end
            end
        end
        pulses = newpulses
    until #pulses == 0
    if i == 1000 then
        print(("Das Produkt der einzelnen Impulse betraegt %d."):format(pCount[0] * pCount[1]))  -- solution of first part
    end
end

-- `cycleCache` has saved all button presses at which the predecessors of `outgoing` had sent a high pulse.
-- At the least common multiple of all cycle lengths, `outgoing` will receive only high pulses
-- and, since `outgoing` is a conjunction, send a low pulse to the machine 'rx'.
local requiredPresses = 1
for _, cycles in pairs(cycleCache) do
    local firstCycle = math.huge
    for cycle, _ in pairs(cycles) do
        firstCycle = math.min(firstCycle, cycle)
    end
    requiredPresses = lcm(requiredPresses, firstCycle)  -- Theoretically, one could multiply these directly, for `firstCycle` is always prime in my input.
end
print(("Zum Anmachen der Maschine muss %d-mal der Schalter gedrueckt werden."):format(requiredPresses))  -- solution of second part