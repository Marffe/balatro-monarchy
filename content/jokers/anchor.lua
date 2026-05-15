Monarchy.Joker({
    key = "anchor",
    pos = {x = 4, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {mult = 8}},
    attributes = {'mult'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for i = math.ceil(#G.deck.cards/2), 1, -1 do
                                G.deck.cards[i].ability.monarchy_anchor = true
                            end
                            return true
                        end
                    }))
                    return true
                end
            }))
            card.ability.extra.primed = true
            return {
                message = localize('monarchy_anchor_primed'),
                colour = G.C.PERISHABLE
            }
        end
        if context.hand_drawn and #G.deck.cards < #G.playing_cards/2 and card.ability.extra.primed then
            card.ability.extra.primed = nil
            return {
                message = localize('monarchy_anchor_active'),
                colour = G.C.PERISHABLE
            }
        end
        if context.individual and context.cardarea == G.play and context.other_card.ability.monarchy_anchor then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
})