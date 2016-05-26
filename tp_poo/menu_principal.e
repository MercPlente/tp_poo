note
	description: "Classe gerant le menu principal."
	author: "Marc Plante, Jeremie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_PRINCIPAL

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

create
	make

feature {NONE} -- Initialization

	make (a_sound:SOUND;a_window:GAME_WINDOW_SURFACED)
		-- Construit le menu : son et image
		local
			l_image:IMAGE
		do
			a_highscore := ""
			create l_image.make("menu_resized.jpg")
			l_image.change_background("menu_resized.jpg",a_window)
			make_menu (a_window, a_sound, l_image)
			menu_action
		end


	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_image:GAME_SURFACE)
			-- Fonction envoyant l'utilisateur dans la section "Single Player", "Multiplayer", "Replay Intro"
			--ou "show credit" selon l'endroit ou il clique

	require else
		Souris_Appuyer_Correctement: a_mouse_state.is_left_button_pressed
		Nombre_Click: a_nb_clicks >= 1

		local
			l_menu_single_player:MENU_SINGLE_PLAYER
			l_thread:TP_THREAD
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				if a_mouse_state.x>=244 and a_mouse_state.x<=548 then
					if a_mouse_state.y>=249 and a_mouse_state.y<=276 then
						entrer_menu_single_player
					end
					if a_mouse_state.y>=302 and a_mouse_state.y<=335 then
					end
					if a_mouse_state.y>=355 and a_mouse_state.y<=384 then
						retour_precedant
						return_principal := True
						game_library.stop
					end
					if a_mouse_state.y>=408 and a_mouse_state.y<=438 then
						create l_thread.make
						l_thread.launch
						from
						until
							l_thread.recu = true
						loop
						end
						a_highscore := l_thread.highscore
						print("Meilleur temps: " + a_highscore + "%N")

						entrer_highscore

					end
					if a_mouse_state.y>=456 and a_mouse_state.y<=500 then
						quitter := True
						game_library.stop
					end
				end
			end
		end


	retour_precedant
		-- Crée les images et son du menu précédent pour revenir en arrière.
		do
			sound.play_music ("beginning")
			create image.make("background_resized.jpg")
				image.change_background("background_resized.jpg",window)
		end



feature {ANY}

	menu_action
	-- Faire afficher et gérer les events du menu
		local
			l_menu_single_player: MENU_SINGLE_PLAYER
			l_highscore: HIGHSCORE
		do
			from
				return_principal := False
			until
				return_principal or quitter
			loop
				menu_single_player_selectioner := False
				highscore := False
				game_library.clear_all_events
				Precursor
				game_library.launch
				if menu_single_player_selectioner then
					create l_menu_single_player.make (window,sound)
					return_single_player := True
				elseif highscore then
					create l_highscore.make (window,sound,a_highscore)
					return_highscore := True
				end
			end
		end

	a_highscore: STRING
	-- Le meilleur temps

	entrer_menu_single_player
	-- Met le menu_single_player à True pour entrer dans le menu single player en retournant dans la boucle et arrêter les events.
		do
			menu_single_player_selectioner := True
			game_library.stop
		end

	entrer_highscore
	-- Met le highscore à True pour entrer dans le menu highscore en retournant dans la boucle et arrêter les events.
		do
			highscore := True
			game_library.stop
		end

	menu_single_player_selectioner: BOOLEAN
	-- Bool pour savoir si on entre dans le prochain menu

	highscore: BOOLEAN
	-- Bool pour savoir si on entre dans le prochain menu


end
