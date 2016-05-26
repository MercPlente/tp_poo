note
	description: "Classe gerant les options lorsque l'utilisateur choisi le mode: Single Player."
	author: "Marc Plante, Jeremie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_SINGLE_PLAYER

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
			create l_image.make("single_player.png")
			l_image.change_background("single_player.png",a_window)
			make_menu (a_window, a_sound, l_image)
			menu_action
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_surface:GAME_SURFACE)
			-- Fonction envoyant l'utilisateur dans la section "New Game", "Continuer"
			--ou "back" selon l'endroit où il clique
		require else
			Souris_Appuyer_Correctement: a_mouse_state.is_left_button_pressed
			Nombre_Click: a_nb_clicks >= 1

		local
			l_new_game:NEW_GAME

		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then

				if a_mouse_state.x>=235 and a_mouse_state.x<=556 then
					if a_mouse_state.y>=56 and a_mouse_state.y<=130 then
						create l_new_game.make (window,sound)
					end
					if a_mouse_state.y>=170 and a_mouse_state.y<=242 then
						--continue
					end
					if a_mouse_state.y>=490 and a_mouse_state.y<=560 then
						--back
						retour_precedant
						return_single_player := True
						game_library.stop
					end
				end
			end
		end

	retour_precedant
	-- Crée les images et son du menu precedent pour revenir en arrière
		do
			create image.make("menu_resized.jpg")
			image.change_background("menu_resized.jpg",window)
		end

feature {ANY}

	menu_action
	-- Faire afficher et gérer les events du menu
		local
			l_menu_new_game: NEW_GAME
		do
			from
				return_single_player := False
			until
				return_single_player
			loop
				menu_new_game_selectioner := False
				game_library.clear_all_events
				Precursor
				game_library.launch
				if menu_new_game_selectioner then
					create l_menu_new_game.make (window,sound)
					return_new_game := True
				end
			end
		end

		menu_new_game_selectioner : BOOLEAN
		-- Bool pour savoir si on entre dans le prochain menu

end
