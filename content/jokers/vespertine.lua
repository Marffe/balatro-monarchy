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
        return {vars = {card.ability.extra.mult, card.ability.extra.mult * (G.GAME.Monarchy and G.GAME.Monarchy.joker_values.vespertine_hand_count or 0)}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult * G.GAME.Monarchy.joker_values.vespertine_hand_count
            }
        end
    end,
})