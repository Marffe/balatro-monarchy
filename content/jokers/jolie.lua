Monarchy.Joker({
    key = "jolie",
    pos = {x = 5, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {rank = 'Queen', xmult = 1.5}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.rank, 'ranks'), card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and  context.other_card.base.value == card.ability.extra.rank and not next(SMODS.get_enhancements(context.other_card)) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})