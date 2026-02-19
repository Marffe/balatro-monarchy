SMODS.Atlas({
    key = 'vouchers', path = 'vouchers.png',
    px = 71, py = 95
})

Monarchy.Voucher = SMODS.Voucher:extend({
    atlas = 'monarchy_vouchers',
    pos = {x = 0, y= 0},
    unlocked = true,
	discovered = true,
    inject = function(self)
        if self.requires then
            for i, key in ipairs(self.requires) do
                self.requires[i] = 'v_monarchy_'..key
            end
            print(self.requires)
        end
        SMODS.Voucher.inject(self)
    end,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions.Voucher, self.key,
            G.localization.descriptions.Voucher[self.key] or self.loc_txt or {
                name = {'{C:inactive}#1#','{C:red,s:0.6}Placeholder Voucher'}, text = {'{C:inactive}This Voucher has not got','{C:inactive}a localization entry'}
            })
    end,
    loc_vars = function(self, info, card)
        return {vars = {self.original_key}}
    end
})

Monarchy.Voucher({
    key = 'frequent_flier',
    pos = {x = 0, y= 0},
    config = {extra = {dollars = 8}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize('$')..card.ability.extra.dollars}}
    end,
})

Monarchy_Hook_skip_blind = G.FUNCS.skip_blind
G.FUNCS.skip_blind = function(e)
    Monarchy_Hook_skip_blind(e)
    local fliers = SMODS.find_card('v_monarchy_frequent_flier')
    for _, voucher in ipairs(fliers) do
        SMODS.calculate_effect({dollars = voucher.ability.extra.dollars}, voucher)
    end

end


Monarchy.Voucher({
    key = 'first_class',
    pos = {x = 1, y= 0},
    requires = {'frequent_flier'},
    config = {extra = {current = 0, target = 30}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize('$')..card.ability.extra.target}}
    end,
    calculate = function(self, card, context)
        if context.starting_shop then
            card.ability.extra.current = 0
            card.ability.extra.active = true
        end
        if (context.reroll_shop or context.buying_card) and card.ability.extra.active then
            card.ability.extra.current = card.ability.extra.current + (context.cost or 0)+ (context.card and context.card.cost or 0)
            if card.ability.extra.current >= card.ability.extra.target then
                card.ability.extra.active = false
                Monarchy.add_tag(nil, 'monarchy_first_class')
                return {
                    message = 'First Class!',
                    colour = G.C.BLUE
                }
            end
            return {
                message = card.ability.extra.current .. '/' .. card.ability.extra.target,
                colour = G.C.GOLD
            }
        end
    end
})

Monarchy.Voucher({
    key = 'viral',
    pos = {x = 2, y= 0},
    config = {extra = {odds = 4}},
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'monarchy_viral_spread')}}
    end,
    calculate = function(self, card, context)
        if context.before then
            local enhanced_index = {}
            for i, p_card in ipairs(context.scoring_hand) do
                if p_card.ability.set == 'Enhanced' then
                    table.insert(enhanced_index, i)
                end
            end
            for _, i in ipairs(enhanced_index) do
                local targets = {i-1, i+1}
                for _, target in ipairs(targets) do
                    if context.scoring_hand[target] and context.scoring_hand[target].ability.set ~= 'Enhanced' then
                        if SMODS.pseudorandom_probability(card, 'monarchy_viral_spread', 1, card.ability.extra.odds) then
                            context.scoring_hand[target]:set_ability(context.scoring_hand[i].config.center_key, nil, true)
                            juice_card(context.scoring_hand[target])
                            SMODS.calculate_effect({message = localize('monarchy_viral_spread'), juice_card = context.scoring_hand[i], message_card = context.scoring_hand[target]}, card)
                        end
                    end
                end
            end
        end
    end,
})

Monarchy.Voucher({
    key = 'biohazard',
    pos = {x = 3, y= 0},
    config = {extra = {odds = 4}},
    requires = {'viral'},
    loc_vars = function(self, info_queue, card)
        return {vars = {SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'monarchy_biohazard_spread')}}
    end,
    calculate = function(self, card, context)
        if context.before then
            local edition_index = {}
            local seal_index = {}
            for i, p_card in ipairs(context.scoring_hand) do
                if p_card.edition then
                    table.insert(edition_index, i)
                end
                if p_card.seal then
                    table.insert(seal_index, i)
                end
            end
            for i=1, math.max(#edition_index, #seal_index) do
                if edition_index[i] then
                    local targets = {edition_index[i]-1, edition_index[i]+1}
                    for _, target in ipairs(targets) do
                        if context.scoring_hand[target] and not context.scoring_hand[target].edition then
                            if SMODS.pseudorandom_probability(card, 'monarchy_biohazard_edition_spread', 1, card.ability.extra.odds) then
                                context.scoring_hand[target]:set_edition(context.scoring_hand[edition_index[i]].edition.key, nil, nil, true)
                                juice_card(context.scoring_hand[target])
                                SMODS.calculate_effect({message = localize('monarchy_viral_spread'), colour = G.C.DARK_EDITION, juice_card = context.scoring_hand[edition_index[i]], message_card = context.scoring_hand[target]}, card)
                            end
                        end
                    end
                end
                if seal_index[i] then
                    local targets = {seal_index[i]-1, seal_index[i]+1}
                    for _, target in ipairs(targets) do
                        if context.scoring_hand[target] and not context.scoring_hand[target].seal then
                            if SMODS.pseudorandom_probability(card, 'monarchy_biohazard_seal_spread', 1, card.ability.extra.odds) then
                                context.scoring_hand[target]:set_seal(context.scoring_hand[seal_index[i]].seal)
                                juice_card(context.scoring_hand[target])
                                SMODS.calculate_effect({message = localize('monarchy_viral_spread'), juice_card = context.scoring_hand[seal_index[i]], message_card = context.scoring_hand[target]}, card)
                            end
                        end
                    end
                end
            end
        end
    end,
})
