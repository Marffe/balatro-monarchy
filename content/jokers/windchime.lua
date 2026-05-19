Monarchy.Joker({
    key = "windchime",
    pos = {x = 0, y = 5},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    config = {extra = {xmult = 1, gain = 0.2, count = 3, current = 0}},
    attributes = {'xmult', 'scaling', 'enhancements'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.count, card.ability.extra.gain, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card.ability.set == 'Enhanced' and not context.other_card.repetition_trigger then
            card.ability.extra.current = card.ability.extra.current + 1
            G.E_MANAGER:add_event(Event({
                func = function()
                    card:juice_up()
                    play_sound('monarchy_chime', math.random() + 1, 0.7 + (math.random(-3, 3)/10))
                    return true
                end
            }))
            return {
                juice_card = context.other_card,
                func = function()
                    if card.ability.extra.current == card.ability.extra.count then
                        for i=1, 5 do
                            G.E_MANAGER:add_event(Event({
                                type = 'after', delay = 0.8,
                                func = function()
                                    play_sound('monarchy_chime', math.random() + 1, 0.7 + (math.random(-3, 3)/10))
                                    return true
                                end
                            }))
                        end
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = 'xmult',
                            scalar_value = 'gain',
                            message_colour = G.C.RED
                        })
                        card.ability.extra.current = 0
                    end
                end
            }
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
})

SMODS.Sound({
    key = 'chime',
    path = 'chime.ogg'
})