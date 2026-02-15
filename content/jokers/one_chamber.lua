Monarchy.Joker({
    key = "one_chamber",
    pos = {x = 9, y = 3},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 5, hands = 0}},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmult, card.ability.extra.hands}}
    end,
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            juice_card_until(card, function() return G.GAME.current_round.hands_played == 0 end, true)
        end
        if context.joker_main and G.GAME.current_round.hands_played == 0 then
            return {
                xmult = card.ability.extra.xmult,
            }
        end
    end,
})

SMODS.Sound({
    key = 'gunshot',
    path = 'gun.ogg'
})