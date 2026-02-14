Monarchy.Joker({
    key = "meteor_shower",
    pos = {x = 1, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {odds = 3, key = 'm_stone'}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Enhanced', key = card.ability.extra.key, type = 'name_text'}), localize('k_celestial_pack'), SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'monarchy_meteor_shower')}}
    end,
    create_card = function(self, card)
        if SMODS.pseudorandom_probability(card, 'monarchy_meteor_shower', 1, card.ability.extra.odds) then
            juice_card(card)
            return SMODS.create_card({set = 'Enhanced', key = card.ability.extra.key, edition = SMODS.poll_edition({guaranteed = true, key = 'monarchy_meteor_shower_edition'})})
        end
    end
})

