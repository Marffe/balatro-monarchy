Monarchy.Joker({
    key = "vespertine",
    pos = {x = 3, y = 4},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {mult = 3, last_hand = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult * (card.ability.extra.last_hand or 0)}}
    end,
    calculate = function(self, card, context)
        if context.after then
            -- Vespertine Tracker
            card.ability.extra.last_hand = #context.scoring_hand
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * card.ability.extra.last_hand
            }
        end
    end,
})