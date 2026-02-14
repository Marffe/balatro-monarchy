SMODS.Atlas({
    key = 'vouchers', path = 'vouchers.png',
    px = 71, py = 95
})

Monarchy.Voucher = SMODS.Voucher:extend({
    atlas = 'monarchy_vouchers',
    pos = {x = 0, y= 0},
    unlocked = true,
	discovered = true,
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
    requires = {'v_monarchy_frequent_flier'},
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