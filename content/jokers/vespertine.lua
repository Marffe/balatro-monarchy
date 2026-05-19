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
    config = {extra = {mult = 6}},
    attributes = {'mult', 'hands'},
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult}}
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and G.GAME.current_round.hands_left == 0 then
            card.ability.extra.juiced = false
            return {
                mult = card.ability.extra.mult
            }
        end
        if context.hand_drawn and G.GAME.current_round.hands_left == 1 and not card.ability.extra.juiced then
            if not context.blueprint then
                local eval = function() return G.GAME.current_round.hands_left == 1 end
                card.ability.extra.juiced = true
                juice_card_until(card, eval, true)
            end
        end
    end,
})