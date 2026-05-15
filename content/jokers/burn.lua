Monarchy.Joker({
    key = "burn",
    pos = {x = 1, y = 1},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {dollars = 2}},
    attributes = {'economy', 'destroy_card'},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize('$')..card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            for i=1, #G.deck.cards do
                if not G.deck.cards[i].getting_sliced then
                    local destroy_card = G.deck.cards[i]
                    draw_card(G.deck, G.play, nil, nil, nil, destroy_card)
                    delay(1)
                    SMODS.destroy_cards(destroy_card)
                    juice_card(card)
                    return {
                        dollars = card.ability.extra.dollars
                    }
                end
            end
        end
    end,
})