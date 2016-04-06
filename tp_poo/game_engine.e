note
	description: "Classe pour modifier des elements en jeu."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ENGINE

inherit


	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'

create


create
	make



feature {NONE} -- Initialisation

	make
			-- Initialisation des sons `sounds'.
		do
			create sounds.set_sound
		end


feature


	run_game
			-- Prepare et lancer le jeu (fênetre, son et action)
		local
			l_window:GAME_WINDOW_SURFACED
		do
			l_window := create_window
			sounds.play_music ("beginning")

			game_library.iteration_actions.extend (agent sounds.on_iteration_sound)
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, l_window))
			l_window.key_pressed_actions.extend (agent on_key_down_quit)
			l_window.key_pressed_actions.extend (agent on_key_down_sound)
			game_library.quit_signal_actions.extend (agent on_quit)
			game_library.launch
			l_window.close
		end

	create_window:GAME_WINDOW_SURFACED
			-- Creee la fenetre affichee a l'ecran. La fenetre contient un titre et un icone
		local
			l_icon_image:GAME_IMAGE_BMP_FILE
			l_icon:GAME_SURFACE
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_image:IMAGE
			l_window:GAME_WINDOW_SURFACED
		do
			create l_image.make ("background_resized.jpg")
			create l_window_builder
			if not l_image.has_error then
				l_window_builder.set_dimension (l_image.width, l_image.height)
			end
			Result := l_window_builder.generate_window
			l_window_builder.set_title ("Diablo IV")
			Result.key_pressed_actions.extend (agent on_key_down_quit)
			game_library.iteration_actions.extend (agent on_iteration_background(?, l_image,Result))
			create l_icon_image.make ("Diablo-icon.bmp")
			if l_icon_image.is_openable then
				l_icon_image.open
				if l_icon_image.is_open then
					create l_icon.share_from_image (l_icon_image)
					l_icon.set_transparent_color (create {GAME_COLOR}.make_rgb (255, 0, 255))
					Result.set_icon (l_icon)
				else
					print("Cannot set the window icon.")
				end
			end
		end

	change_background(background:STRING;l_window:GAME_WINDOW_SURFACED)
	-- Utilisse "IMAGE" pour modifier le background
		local
			l_image:IMAGE
		do
			create l_image.make (background)
			game_library.iteration_actions.start
			game_library.iteration_actions.remove
			game_library.iteration_actions.extend (agent on_iteration_background(?,l_image,l_window))

			end


	on_iteration_background(a_timestamp:NATURAL_32; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED)
			-- Evenement qui modifie le fond d'ecran a chaque iteration.
		do
			l_window.surface.draw_surface (a_image, 0, 0)
			l_window.update
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			-- Fonction qui change le menu et fond d'ecran quand l'utilisateur fait un clique gauche à l'ecran
	require
		Souris_Appuyer_Correctement: a_mouse_state.is_left_button_pressed
		Nombre_Click: a_nb_clicks >= 1

		local
			l_menu_principal:MENU_PRINCIPAL
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				change_background("menu_resized.jpg",a_window)
				sounds.play_music ("menu_principal")
				create l_menu_principal.make(sounds,a_window)
			end
		end

	on_key_down_quit(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Quand la touche "escape" est appuyee, l'application se termine
	require
		Key_State: a_key_state.is_escape
		do
			if a_key_state.is_escape then
				game_library.stop
			end
		end

	on_key_down_sound(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- Lorsque la touche sace est appuyee, le son "on_space_key" jouera une fois.
	require
		Key_State: a_key_state.is_space
		do
			if a_key_state.is_space then
				sounds.on_space_key
			end
			if a_key_state.is_a then
				sounds.on_a_key
			end

		end

	on_quit(a_timestamp:NATURAL)
			-- Fonction pour arreter la librairie
		do
			game_library.stop
		end


	sounds:SOUND


end
