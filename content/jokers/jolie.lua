Monarchy.Joker({
    key = "jolie",
    pos = {x = 5, y = 3},
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {rank = 'Queen'}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize(card.ability.extra.rank, 'ranks')}}
    end,
    calculate = function(self, card, context)
        if context.before then
            for _, _pcard in ipairs(context.scoring_hand) do
                if _pcard.base.value == card.ability.extra.rank and not next(SMODS.get_enhancements(_pcard)) then
                    _pcard.ability.jolie = true
                end
            end
        end
    end,
})