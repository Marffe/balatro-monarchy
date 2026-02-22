-- Function to automatically apply mod prefix and item prefix to items in loc table
function Monarchy.Functions.prefix_loc_table(input, output)
    local mod_prefix = Monarchy.mod.prefix
    for type, data in pairs(input) do
        local pref = mod_prefix .. '_'
        if SMODS[type].class_prefix then
            pref = SMODS[type].class_prefix .. '_' .. pref
        end
        output.descriptions[type] = output.descriptions[type] or {}
        for key, t in pairs(data) do
            output.descriptions[type][pref..key] = t
        end
    end
    return output
end

function Monarchy.Functions.hand_contains_enhancement(hand, enhancement)
    if not next(hand) then return false end
    for _, card in ipairs(hand) do
        if SMODS.has_enhancement(card, enhancement) then return true end
    end
end

function Monarchy.Functions.hand_contains_rank(hand, rank)
    for _, card in ipairs(hand) do
        if card.base.value == rank then return true end
    end
end

function Monarchy.Functions.rank_from_deck(seed, face_cull)
	local ranks = {}
	local seed = seed or 'monarchy_random_rank_from_deck'
	for _, card in pairs(G.playing_cards) do
		ranks[card.base.value] = card.base.value
	end
    if face_cull then
        for rank, _ in pairs(ranks) do
            if SMODS.Ranks[rank].face then ranks[rank] = nil end
        end
    end
	return pseudorandom_element(ranks, seed)
end

function Monarchy.Functions.set_globals()
    G.STATES.MONARCHY_EVENT = 'monarchy'
end

function Monarchy.Functions.add_tag(tag_key, seed)
    if not tag_key then
        seed = seed or 'monarchy_tag_spawn'
        local tag_pool = get_current_pool('Tag')
        tag_key = pseudorandom_element(tag_pool, seed)
        local it = 0
        while tag_key == 'UNAVAILABLE' do
            it = it + 1
            tag_key = pseudorandom_element(tag_pool, seed..it)
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.4,
        func = (function()
            add_tag(Tag(tag_key))
            play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
            play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
            return true
        end)
    }))
end

function Monarchy.Functions.add_voucher(voucher_key, seed)
    if not voucher_key then
        seed = seed or 'monarchy_voucher_spawn'
        local voucher_pool = get_current_pool('Voucher')
        voucher_key = pseudorandom_element(voucher_pool, seed)
        local it = 0
        while voucher_key == 'UNAVAILABLE' do
            it = it + 1
            voucher_key = pseudorandom_element(voucher_pool, seed..it)
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'after', delay = 0.5,
        func = function()
            local voucher_card = SMODS.create_card({area = G.play, key = voucher_key})
            voucher_card:add_to_deck()
            voucher_card:start_materialize()
            voucher_card.cost = 0
            G.play:emplace(voucher_card)

            voucher_card:redeem()
            
            G.E_MANAGER:add_event(Event({
                func = function()
                    voucher_card:start_dissolve()                
                    return true
                end
            }))

            delay(1)

            return true
        end
    }))
end