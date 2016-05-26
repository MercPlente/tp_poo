note
	description: "Le menu highscore."
	author: "Marc Plante, Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	HIGHSCORE

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

	make (a_window:GAME_WINDOW_SURFACED;a_sound:SOUND; string_highscore: STRING)
		-- Construit le menu : image et continue la musique
		local
			l_image:IMAGE
			l_text: TEXT_SURFACE_BLENDED
		do
			a_highscore := string_highscore

			create font.make ("DIABLO_L.TTF", 27)
			if font.is_openable then
				font.open
			end
			create l_image.make("highscore.png")
			l_image.change_background("highscore.png",a_window)
			make_menu (a_window, a_sound, l_image)
			menu_action
			if font.is_open then
				create l_text.make (a_highscore, font, create {GAME_COLOR}.make_rgb (255, 255, 255))
				if not l_text.has_error then
					a_window.surface.draw_surface (l_text, 50, 50)
				end
			end
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
					if a_mouse_state.y>=490 and a_mouse_state.y<=560 then
						--back
						retour_precedant
						return_highscore := True
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
				return_highscore := False
			until
				return_highscore
			loop
				game_library.clear_all_events
				Precursor
				game_library.launch
			end
		end

	font: TEXT_FONT
	-- Pour écrire du texte

	a_highscore: STRING
	-- Le meilleur temps

end
