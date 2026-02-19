SMODS.Atlas({
    key = 'decks', path = 'decks.png',
    px = 71, py = 95
})

Monarchy.Back = SMODS.Back:extend({
    atlas = 'monarchy_decks',
    pos = {x = 0, y= 0},
    unlocked = true,
	discovered = true,
    process_loc_text = function(self)
        SMODS.process_loc_text(G.localization.descriptions.Back, self.key,
            G.localization.descriptions.Back[self.key] or self.loc_txt or {
                name = {'{C:inactive}#1#','{C:red,s:0.6}Placeholder Deck'}, text = {'{C:inactive}This #1# Deck has not got','{C:inactive}a localization entry'}
            })
    end,
    loc_vars = function(self, info, card)
        return {vars = {self.original_key}}
    end
})

Monarchy.Back({
    key = 'orbit',
    pos = {x=3, y=0},
    config = {extra = {tag = 'tag_orbital', amount = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.amount, localize({set = 'Tag', key = self.config.extra.tag, type = 'name_text'}), localize('b_planet_cards'), localize('k_celestial_pack')}}
    end,
    apply = function(self, card)
        G.GAME.planet_rate = 0
        for _, pack in ipairs(G.P_CENTER_POOLS['Booster']) do
            if pack.kind == 'Celestial' then
                G.GAME.banned_keys[pack.key] = true
            end
        end
        local to_ban = {'v_telescope', 'v_observatory', 'v_planet_merchant', 'v_planet_tycoon', 'j_constellation', 'j_satellite', 'j_astronomer', 'c_high_priestess', 'Blue'}
        for _, key in ipairs(to_ban) do
            G.GAME.banned_keys[key] = true
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval and context.beat_boss then
            card.effect.config.extra.trigger = true
        end
        if context.round_eval and card.effect.config.extra.trigger then
            card.effect.config.extra.trigger = nil
            add_round_eval_row({dollars = 0, name='custom', number = card.effect.config.extra.amount, number_colour = G.C.RED, text = localize({set = 'Tag', type='name_text', key = card.effect.config.extra.tag}), text_colour = G.C.BLUE, pitch = 4, card = G.deck})
            for i=1, card.effect.config.extra.amount do
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.4,
                    func = (function()
                        Monarchy.add_tag(card.effect.config.extra.tag)
                        return true
                    end)
                }))
            end
        end
    end
})

Monarchy.Back({
    key = 'jetsetter',
    pos = {x=0, y=0},
    config = {extra = {vouchers = {'v_monarchy_frequent_flier', 'v_monarchy_first_class'}, interest = 3}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Voucher', key = self.config.extra.vouchers[1], type = 'name_text'}), localize({set = 'Voucher', key = self.config.extra.vouchers[2], type = 'name_text'}), localize('$')..(self.config.extra.interest + 5)}}
    end,
    apply = function(self, card)
        for _, voucher in ipairs(card.effect.config.extra.vouchers) do
            Monarchy.add_voucher(voucher)
        end
        G.GAME.interest_cap = G.GAME.interest_cap + (card.effect.config.extra.interest * 5)
    end,
})


Monarchy.Back({
    key = 'sparkle',
    pos = {x=1, y=0},
    config = {extra = {vouchers = {'v_magic_trick', 'v_illusion'}, destroy = 2}},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize({set = 'Voucher', key = self.config.extra.vouchers[1], type = 'name_text'}), localize({set = 'Voucher', key = self.config.extra.vouchers[2], type = 'name_text'}), self.config.extra.destroy}}
    end,
    apply = function(self, card)
        for _, voucher in ipairs(card.effect.config.extra.vouchers) do
            Monarchy.add_voucher(voucher)
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            Monarchy.sparkle_deck_effect = true
        end
    end
})

local update_shopref = Game.update_shop
function Game.update_shop(self, dt)
    if not Monarchy.sparkle_deck_effect then update_shopref(self, dt) return end
    Monarchy.sparkle_deck_effect = nil
    G.STATE_COMPLETE = true
    for i=1, G.GAME.selected_back.effect.config.extra.destroy do
        draw_card(G.deck, G.play)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.7,
        func = function()
            SMODS.destroy_cards(G.play.cards)
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.7,
                func = function()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
        end
    }))
end


Monarchy.Back({
    key = 'abberant',
    pos = {x=2, y=0},
    config = {extra = {amount = 10}},
    loc_vars = function(self, info_queue, card)
        return {vars = {self.config.extra.amount}}
    end,
    apply = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'after', delay = 0.7,
            func = function()
                G.deck:shuffle()
                G.play.config.card_limit = 10
                for i = 1, card.effect.config.extra.amount do
                    draw_card(G.deck, G.play)
                end
                for i = 1, card.effect.config.extra.amount do
                    local key = SMODS.poll_enhancement({key = 'monarchy_abberant_start', guaranteed = true})
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 1,
                        func = function()
                            G.play.cards[i]:juice_up()
                            G.play.cards[i]:set_ability(key)
                            SMODS.calculate_effect({message = localize({set = 'Enhanced', key = key, type = 'name_text'}), instant = true}, G.play.cards[i])
                            return true
                        end
                    }))
                end
                delay(1)
                for i = 1, card.effect.config.extra.amount do
                    draw_card(G.play, G.deck)
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after', delay = 0.7,
                    func = function()
                        G.play.config.card_limit = 5
                        return true
                    end
                }))
                return true
            end
        }))
    end,
    calculate = function(self, card, context)
        if context.monarchy_abberant and context.cardarea == G.play and context.other_card.ability.set == 'Enhanced' then
            juice_card(context.other_card)
            for i = 1, 20 do
                context.other_card:set_ability(SMODS.poll_enhancement({key = 'monarchy_abberant_switch', guaranteed = true}), nil, true)
            end
            SMODS.calculate_effect({
                message = localize('monarchy_abberant_trigger'),
                message_card = context.other_card,
                juice_card = G.deck.cards[1] or G.deck
            }, context.other_card)
        end
    end,
})