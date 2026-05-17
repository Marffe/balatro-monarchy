SMODS.Atlas({
    key = 'modicon', path = 'ModIcon.png',
    px = 32, py = 32
})

SMODS.Atlas({
    key = 'balatro',
    prefix_config = {key = false},
    path = 'balatro.png',
    px = 333, py = 216
})

local Monarchy_Hook_main_menu = Game.main_menu
function Game:main_menu(change_context)
    Monarchy_Hook_main_menu(self, change_context)

    
    local splash_args = {mid_flash = change_context == 'splash' and 1.6 or 0.}
    ease_value(splash_args, 'mid_flash', -(change_context == 'splash' and 1.6 or 0), nil, nil, nil, 4)

    G.SPLASH_BACK:define_draw_steps({{
        shader = 'splash',
        send = {
            {name = 'time', ref_table = G.TIMERS, ref_value = 'REAL_SHADER'},
            {name = 'vort_speed', val = 0.4},
            {name = 'colour_1', ref_table = G.C, ref_value = 'BLUE'},
            {name = 'colour_2', ref_table = G.C, ref_value = 'WHITE'},
            {name = 'mid_flash', ref_table = splash_args, ref_value = 'mid_flash'},
            {name = 'vort_offset', val = 0},
        }
    }})
end

Monarchy.mod.menu_cards = function()
	return {
		{key = 'j_monarchy_daifugo'},
	}
end

SMODS.Atlas {
	key = "deck_skin",
	path = "monarchdeck.png",
	px = 71,
	py = 95
}

SMODS.Atlas {
	key = "deck_skin_HC",
	path = "monarchdeck_HC.png",
	px = 71,
	py = 95
}

SMODS.DeckSkin {
    key = 'spades',
    suit = 'Spades',
    loc_txt = 'Monarchy',
    palettes = {
        {
            key = 'monarchy_spades_lc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin'
        },
        {
            key = 'monarchy_spades_hc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin_HC',
            hc_default = true
        }
    }
}

SMODS.DeckSkin {
    key = 'clubs',
    suit = 'Clubs',
    loc_txt = 'Monarchy',
    palettes = {
        {
            key = 'monarchy_clubs_lc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin'
        },
        {
            key = 'monarchy_clubs_hc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin_HC',
            hc_default = true
        }
    }
}

SMODS.DeckSkin {
    key = 'hearts',
    suit = 'Hearts',
    loc_txt = 'Monarchy',
    palettes = {
        {
            key = 'monarchy_hearts_lc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin'
        },
        {
            key = 'monarchy_hearts_hc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin_HC',
            hc_default = true
        }
    }
}

SMODS.DeckSkin {
    key = 'diamonds',
    suit = 'Diamonds',
    loc_txt = 'Monarchy',
    palettes = {
        {
            key = 'monarchy_diamonds_lc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin'
        },
        {
            key = 'monarchy_diamonds_hc',
            ranks = {'Jack', 'Queen', 'King', 'Ace'},
            display_ranks = {'Ace', 'King', 'Queen', 'Jack'},
            atlas = 'monarchy_deck_skin_HC',
            hc_default = true
        }
    }
}