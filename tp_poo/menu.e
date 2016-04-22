note
	description: "Contient les methodes de tous les 'menu'."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	MENU

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'

feature {NONE} -- Initialisation

	make (a_window:GAME_WINDOW_SURFACED; a_sound: SOUND; a_image: IMAGE)
	-- Constructeur de la classe abstraite "MENU"
		do
			window := a_window
			sound := a_sound
			image := a_image
		ensure
			Son_Assigne: sound = a_sound
			Window_Assigne: window = a_window
		end

feature

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_image:GAME_SURFACE)
		-- methode qui gere les actions de la souris dans le menu
		deferred
		end

	menu_action
	-- methode gerant les iterations du menu
		do
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			game_library.iteration_actions.extend (agent image.on_iteration_background(?, image,window))
			window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, image))

		end


feature {ANY}

	quitter: BOOLEAN
	-- Bool pour quitter l'application

	sound : SOUND
	-- Attribut pour utiliser la classe SOUND

	image : IMAGE
	-- Attribut pour utiliser la classe IMAGE

	window : GAME_WINDOW_SURFACED
	-- Attribut pour utiliser et modifier la fenetre dans un menu

	return_depart : BOOLEAN
	-- Bool pour sortir de la boucle de menu

	return_principal : BOOLEAN
	-- Bool pour revenir au menu depart

	return_single_player : BOOLEAN
	-- Bool pour revenir au menu principal

	return_new_game : BOOLEAN
	-- Bool pour revenir au menu de single player

	return_load_village : BOOLEAN
	-- Bool pour revenir au menu de new game


end
