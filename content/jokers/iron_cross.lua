Monarchy.Joker({
    key = "iron_cross",
    pos = {x = 9, y = 0},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {gain = 0.1}},
    attributes = {'scaling', 'enhancements', 'modify_card'},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Enhanced', key = 'm_steel', type = 'name_text'}), card.ability.extra.gain}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            if SMODS.has_enhancement(context.other_card, 'm_steel') then
                juice_card(card)
                SMODS.scale_card(context.other_card, {
                    ref_table = context.other_card.ability,
                    ref_value = 'h_x_mult',
                    scalar_table = card.ability.extra,
                    scalar_value = 'gain',
                    -- message_key = 'a_xmult',
                    message_colour = G.C.RED
                })
            end
        end
        return nil, true
    end,
})