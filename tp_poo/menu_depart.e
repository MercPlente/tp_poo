note
	description: "Classe gérant le menu de départ."
	author: "Marc Plante, Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_DEPART

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

feature {NONE}

	make
		-- Construit la fenêtre et le menu principal : image et son
		local
			l_window:GAME_WINDOW_SURFACED
			l_image:IMAGE
		do
			create sound.set_sound
			l_window := create_window
			sound.play_music ("beginning")
			create l_image.make("background_resized.jpg")
			l_image.change_background("background_resized.jpg",l_window)
			make_menu(l_window,sound,l_image)
			menu_action

		end

	create_window:GAME_WINDOW_SURFACED
			-- Crée la fenêtre affiche à l'écran. La fenêtre contient un titre et un icone
		local
			l_icon_image:GAME_IMAGE_BMP_FILE
			l_icon:GAME_SURFACE
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_image:IMAGE
		do
			create l_image.make ("background_resized.jpg")
			create l_window_builder
			if not l_image.has_error then
				l_window_builder.set_dimension (l_image.width, l_image.height)
			end
			Result := l_window_builder.generate_window
			l_window_builder.set_title ("Diablo IV")
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

feature

	menu_action
		-- Faire afficher et gérer les events du menu
		local
			l_menu_principal:MENU_PRINCIPAL
		do
			from
				return_depart := False
			until
				return_depart or quitter
			loop
				menu_principal_selectionne := False
				game_library.clear_all_events
				Precursor
				game_library.launch
				if menu_principal_selectionne then
					create l_menu_principal.make (sound,window)
					quitter := l_menu_principal.quitter
					return_principal := True
				end
			end
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_image:GAME_SURFACE)
		-- Fonction qui entre dans la fonction entrer_menu_principal lorsqu'un clique est fait dans la fenêtre.
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				entrer_menu_principal
			end
		end

	entrer_menu_principal
		-- Met le menu_principal_selectionne à True pour entrer dans le menu principal en retournant dans la boucle et arrêter les events.
		do
			menu_principal_selectionne := True
			game_library.stop
		end


	menu_principal_selectionne:BOOLEAN
	-- Bool pour savoir si on entre dans le prochain menu


end


