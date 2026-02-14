Monarchy.Joker({
    key = "defragment",
    pos = {x = 8, y = 3},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 1, gained = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.pre_discard then
            G.hand:change_size(card.ability.extra.gain)
            card.ability.extra.gained = card.ability.extra.gained + card.ability.extra.gain
            return {
                message = localize{type='variable',key='a_handsize',vars={card.ability.extra.gain}},
            }
        end
        if context.end_of_round and context.main_eval then
            G.hand:change_size(-card.ability.extra.gained)
            card.ability.extra.gained = 0
            return {
                message = localize('k_reset')
            }
        end
    end,
})