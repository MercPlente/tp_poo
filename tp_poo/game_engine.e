note
	description: "Summary description for {GAME_ENGINE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	IMG_LIBRARY_SHARED		-- To use `image_file_library'
create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			create sound.set_sound
		end

feature


	run_game
			-- Preparing and launching the game
		local
			l_window:GAME_WINDOW_SURFACED
		do
			l_window := create_window
			sound.play_music
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			l_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, l_window))
			l_window.key_pressed_actions.extend (agent on_key_down_quit)
			l_window.key_pressed_actions.extend (agent on_key_down_sound)
			game_library.quit_signal_actions.extend (agent on_quit)		-- When the X of the window is pressed, execute the on_quit method.
			game_library.launch	-- The controller will loop until the stop controller.method is called (in method on_quit).
			l_window.close	-- To be sure that every ressources inside `l_window' can be disposed at `quit_library' call
		end

	create_window:GAME_WINDOW_SURFACED
			-- Create the window that will be show. The window have an icon and a title
		local
			l_icon_image:GAME_IMAGE_BMP_FILE
			l_icon:GAME_SURFACE
			l_window_builder:GAME_WINDOW_SURFACED_BUILDER
			l_image:IMAGE
			l_window:GAME_WINDOW_SURFACED
		do
			create l_image
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



	on_iteration_background(a_timestamp:NATURAL_32; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			l_window.surface.draw_surface (a_image, 0, 0)
			l_window.update
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW)
			-- When the user pressed on a mouse button on `a_window'
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				if a_mouse_state.x>=244 and a_mouse_state.x<=548 then
					if a_mouse_state.y>=206 and a_mouse_state.y<=231 then
						print("Single Player")
					end
					if a_mouse_state.y>=251 and a_mouse_state.y<=276 then
						print("Multi Player")
					end
					if a_mouse_state.y>=296 and a_mouse_state.y<=321 then
						print("Replay Intro")
					end
					if a_mouse_state.y>=341 and a_mouse_state.y<=366 then
						print("Show Credits")
					end
					if a_mouse_state.y>=386 and a_mouse_state.y<=411 then
						print("Exit Diablo")
						game_library.stop
					end

				end
			end
		end

	on_key_down_quit(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- When the escape button is pressed (in `a_key_state') exit the application
		do
			if a_key_state.is_escape then			-- If the escape key as been pressed,
				game_library.stop					-- quit the application
			end
		end

	on_key_down_sound(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
			-- When the space button is pressed (in `a_key_state'), play `a_sount' in `a_sound_source'
		do
			if a_key_state.is_space then			-- If the space key as been pressed, play the space sound
				sound.on_space_key
			end
			if a_key_state.is_a then
				sound.on_a_key
			end

		end

	on_quit(a_timestamp:NATURAL)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow controller.launch to return)
		end


	sound:SOUND

end
