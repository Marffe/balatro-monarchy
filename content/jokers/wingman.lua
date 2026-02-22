Monarchy.Joker({
    key = "wingman",
    pos = {x = 0, y = 4},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {xmult = 1, gain = 0.75, hand = 'Pair', rank = 'Ace'}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.hand, 'poker_hands'), localize('k_aces'), card.ability.extra.gain, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.before and context.scoring_name == card.ability.extra.hand and Monarchy.Functions.hand_contains_rank(context.poker_hands[card.ability.extra.hand][1], card.ability.extra.rank) then
            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'xmult',
                scalar_value = 'gain',
                message_key = 'a_xmult',
                message_colour = G.C.RED
            })
            return nil, true
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.end_of_round and context.main_eval and context.beat_boss then
            card.ability.extra.xmult = 1
            return {
                message = localize('k_reset')
            }
        end
    end,
})