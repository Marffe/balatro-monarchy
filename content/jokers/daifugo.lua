Monarchy.Joker({
    key = "daifugo",
    pos = {x = 8, y = 0},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    config = {extra = {dollars = 1}},
    attributes = {'economy', 'hands', 'rank'},
    loc_vars = function(self, info_queue, card)
        return {vars = {localize('$')..card.ability.extra.dollars}}
    end,
    calculate = function(self, card, context)
        if context.before and #G.hand.cards > 0 then
            local rank = 100
            local target = nil
            for i=#G.hand.cards, 1, -1 do
                if rank >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i]) then rank = G.hand.cards[i].base.id; target = G.hand.cards[i] end
            end
            target.monarchy_daifugo = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4,
                func = function()
                    target:highlight(true)
                    return true
                end
            }))
            return {
                dollars = card.ability.extra.dollars,
                message_card = target,
                juice_card = card,
                func = function()
                    local vals_after_level
                        vals_after_level = copy_table(G.GAME.current_round.current_hand)
                        local text,disp_text,_,_,_ = G.FUNCS.get_poker_hand_info(G.play.cards)
                        vals_after_level.handname = disp_text or ''
                        vals_after_level.level = (G.GAME.hands[text] or {}).level or ''
                        for name, p in pairs(SMODS.Scoring_Parameters) do
                            vals_after_level[name] = p.current
                        end
                    SMODS.calculate_effect({message = 'Discarded!', colour = G.C.RED, message_card = target, juice_card = card}, target)
                    G.hand.highlighted = {target}
                    G.FUNCS.discard_cards_from_highlighted(nil, true)
                    update_hand_text({immediate = true, nopulse = true, delay = 0}, vals_after_level)
                    -- draw_card(G.hand, G.discard, nil, 'down', false, target, 0.6)
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after', delay = 0.4,
                        func = function()
                            target.monarchy_daifugo = nil                
                            return true
                        end
                    }))
                end
            }
        end
    end,
})

local Monarchy_Hook_carc_can_calculate = Card.can_calculate
function Card:can_calculate(ignore_debuff, ignore_sliced)
    if self.monarchy_daifugo then
        return ignore_debuff
    else return Monarchy_Hook_carc_can_calculate(self, ignore_debuff, ignore_sliced) end
end
