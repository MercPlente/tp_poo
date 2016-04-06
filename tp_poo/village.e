note
	description: "Summary description for {VILLAGE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	VILLAGE

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	new_village

feature {NONE}

	new_village (a_sound:SOUND; a_window:GAME_WINDOW_SURFACED)

		local
			l_image:IMAGE
			--l_player:PLAYER

		do
			game_library.clear_all_events
			create l_image.make ("village.png")
			sounds := a_sound
			--a_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, a_window))
			game_library.iteration_actions.extend (agent sounds.on_iteration_sound)
			--game_library.iteration_actions.extend (agent on_iteration_background(?,l_image,a_window))

		end

	sounds:SOUND

end
