Monarchy.Joker({
    key = "wild_goose",
    pos = {x = 1, y = 5},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 2}},
    attributes = {'xmult'},
    remove_goose_target = function(self, card)
        for _, _card in ipairs(G.playing_cards) do
            if _card.ability.goosed then
                _card.ability.goosed = nil
                card.ability.extra.goosed = nil
                return
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.hand_drawn and not card.ability.extra.goosed then
            local goose_target = pseudorandom_element(G.hand.cards, 'monarchy_wild_goose')
            goose_target.ability.goosed = true
            card.ability.extra.goosed = true
        end
        if context.individual and context.cardarea == G.play and context.other_card.ability.goosed then
            self:remove_goose_target(card)
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.discard and context.other_card.ability.goosed then
            self:remove_goose_target(card)
        end
        if context.end_of_round and card.ability.extra.goosed then
            self:remove_goose_target(card)
        end
    end,
})

SMODS.Sound({
    key = 'goose',
    path = 'goose.ogg'
})