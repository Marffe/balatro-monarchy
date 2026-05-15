Monarchy.Joker({
    key = "suspicious_tile",
    pos = {x = 3, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    display_size = {w = 71 * 0.55, h = 95 * 0.55},
    enhancement_gate = 'm_wild',
    config = {extra = {enhancement = 'm_wild'}},
    attributes = {'enhancements'},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Enhanced', key = card.ability.extra.enhancement, type = 'name_text'})}}
    end,
})

function Monarchy.joker_functions.suspicious_tile(hand, results)
    local function get_X(num, hand)
        local vals = {}
        for i = 1, SMODS.Rank.max_id.value do
            vals[i] = {}
        end
        for i=#hand, 1, -1 do
            local curr = {}
            table.insert(curr, hand[i])
            for j=1, #hand do
                if (hand[i]:get_id() == hand[j]:get_id() or SMODS.has_enhancement(hand[j], 'm_wild')) and i ~= j then
                    table.insert(curr, hand[j])
                end
            end
            if (#curr >= num) or (#curr == num) then
                vals[curr[1]:get_id()] = curr
            end
        end
        local ret = {}
        for i=#vals, 1, -1 do
            if next(vals[i]) then table.insert(ret, vals[i]) end
        end
        return ret
    end

    if next(SMODS.find_card('j_monarchy_suspicious_tile')) and Monarchy.Functions.hand_contains_enhancement(hand, 'm_wild') then
        local parts = {
            _5 = get_X(5, hand),
            _4 = get_X(4, hand),
            _3 = get_X(3, hand),
            _flush = get_flush(hand)
        }
        if next(parts._5) and next(parts._flush) then
            results["Flush Five"] = parts._5
            if not results.top then results.top = results["Flush Five"] end
        end
        if next(parts._5) then
            results["Five of a Kind"] = parts._5
            if not results.top then results.top = results["Five of a Kind"] end
        end
        if next(parts._4) then
            results["Four of a Kind"] = parts._4
            if not results.top then results.top = results["Four of a Kind"] end
        end
        if next(parts._3) then
            results["Three of a Kind"] = parts._3
            if not results.top then results.top = results["Three of a Kind"] end
        end
    end

    return results
end