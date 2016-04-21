note
	description: "Classe gerant le menu principal."
	author: ""
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
		-- Fonction qui recommence les iterations avec les nouvelles valeurs pour ce menu.
		local
			l_image:IMAGE
		do
			a_sound.play_music ("menu_principal")
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
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then

				if a_mouse_state.x>=244 and a_mouse_state.x<=548 then
					if a_mouse_state.y>=206 and a_mouse_state.y<=231 then
						print("Single Player%N")
						entrer_menu_single_player
					end
					if a_mouse_state.y>=251 and a_mouse_state.y<=276 then
						print("Multi Player%N")
					end
					if a_mouse_state.y>=296 and a_mouse_state.y<=321 then
						print("Replay Intro%N")
						retour_precedant
						return_principal := True
						game_library.stop
					end
					if a_mouse_state.y>=341 and a_mouse_state.y<=366 then
						print("Show Credits%N")
					end
					if a_mouse_state.y>=386 and a_mouse_state.y<=411 then
						print("Exit Diablo%N")
						game_library.stop
					end
				end
			end
		end


	retour_precedant
		do
			sound.play_music ("beginning")
			create image.make("background_resized.jpg")
				image.change_background("background_resized.jpg",window)
		end



feature {ANY}

	menu_action
		local
			l_menu_single_player: MENU_SINGLE_PLAYER
		do
			from
				return_principal := False
			until
				return_principal
			loop
				menu_single_player_selectioner := False
				game_library.clear_all_events
				Precursor
				game_library.launch
				if menu_single_player_selectioner then
					create l_menu_single_player.make (window,sound)
					return_single_player := True
				end
			end
		end

	entrer_menu_single_player
		do
			menu_single_player_selectioner := True
			game_library.stop
		end

	menu_single_player_selectioner: BOOLEAN


end
