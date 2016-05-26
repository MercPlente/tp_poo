note
	description: "Menu de création d'un nouveau personnage. L'utilisateur doit choisir son nom de héros."
	author: "Marc Plante, Jeremie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_GAME

inherit
	MENU
		rename
			make as make_menu
		redefine
			menu_action
		end

	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE}

	make (a_window:GAME_WINDOW_SURFACED;a_sound:SOUND)
		-- Construit le menu : image et continue la musique
		local
			l_image:IMAGE
		do
			create l_image.make("create_game.png")
			l_image.change_background("single_player.png",a_window)
			make_menu (a_window, a_sound, l_image)
			sound := a_sound
			menu_action
		end


	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_SURFACE)
			-- Fonction envoyant l'utilisateur dans la section "Start"
			--ou "back" selon l'endroit ou il clique
		require else
			Souris_Appuyer_Correctement: a_mouse_state.is_left_button_pressed
			Nombre_Click: a_nb_clicks >= 1

		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				if a_mouse_state.x>=604 and a_mouse_state.x<=779 then
					if a_mouse_state.y>=516 and a_mouse_state.y<=569 then
						start_game (window)
					end
				end
				if a_mouse_state.x>=50 and a_mouse_state.x<=224 and a_mouse_state.y>=515 and a_mouse_state.y<=566 then
					retour_precedant
					return_new_game := True
					game_library.stop
				end
			end
		end

	start_game (a_window:GAME_WINDOW_SURFACED)
	-- Commence la partie
		local
			l_game_engine:GAME_ENGINE

		do
			game_library.clear_all_events
			create l_game_engine.make_run (a_window,sound)
			if not l_game_engine.has_error then
				l_game_engine.run (a_window)
			end
		end

	retour_precedant
	-- Crée les images et son du menu précédent pour revenir en arrière
		do
			create image.make("single_player.png")
			image.change_background("single_player.png",window)
		end

FEATURE {ANY}

	menu_action
	-- Faire afficher et gérer les events du menu
		local
			l_village: VILLAGE
		do
			from
				return_new_game := False
			until
				return_new_game
			loop
				load_village_selectionner := False
				game_library.clear_all_events
				Precursor
				game_library.launch
				if load_village_selectionner then
					create l_village.new_village
					return_load_village := True
				end
			end
		end

		load_village_selectionner : BOOLEAN
		-- Bool pour savoir si on entre dans le prochain menu

end
