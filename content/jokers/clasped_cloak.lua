Monarchy.Joker({
    key = "clasped_cloak",
    pos = {x = 6, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 0.3}},
    attributes = {'xmult', 'scaling', 'modify_card'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.after then
            for _, pcard in ipairs(G.hand.cards) do
                SMODS.scale_card(pcard, {
                    ref_table = pcard.ability,
                    ref_value = 'perma_x_mult',
                    scalar_table = card.ability.extra,
                    scalar_value = 'xmult',
                    no_message = true
                })
                pcard.ability.monarchy_clasped_cloak = pcard.ability.monarchy_clasped_cloak or 0
                SMODS.scale_card(pcard, {
                    ref_table = pcard.ability,
                    ref_value = 'monarchy_clasped_cloak',
                    scalar_table = card.ability.extra,
                    scalar_value = 'xmult',
                    no_message = true
                })
            end
            return {
                message = localize('monarchy_clasped_cloak'),
                colour = G.C.MULT
            }
        end
    end,
})