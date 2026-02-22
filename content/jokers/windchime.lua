Monarchy.Joker({
    key = "windchime",
    pos = {x = 0, y = 5},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 1, gain = 0.2, count = 3, current = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.count, card.ability.extra.gain, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.before then
            for _, pcard in ipairs(context.scoring_hand) do
                if pcard.ability.set == 'Enhanced' then
                    card.ability.extra.current = card.ability.extra.current + 1
                    if card.ability.extra.current == card.ability.extra.count then
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                play_sound('monarchy_chime')
                                return true
                            end
                        }))
                        SMODS.scale_card(card, {
                            ref_table = card.ability.extra,
                            ref_value = 'xmult',
                            scalar_value = 'gain',
                            message_colour = G.C.RED
                        })
                        card.ability.extra.current = 0
                    end
                end
            end
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