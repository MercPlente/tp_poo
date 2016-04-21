note
	description: "Summary description for {MENU}."
	author: ""
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
		deferred
		end

	menu_action
		do
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			game_library.iteration_actions.extend (agent image.on_iteration_background(?, image,window))
			window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, image))

		end


feature {ANY}

	quitter: BOOLEAN

	sound : SOUND

	image : IMAGE

	window : GAME_WINDOW_SURFACED

	return_depart : BOOLEAN

	return_principal : BOOLEAN

	return_single_player : BOOLEAN

	return_new_game : BOOLEAN

	return_load_village : BOOLEAN


end
