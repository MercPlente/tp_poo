note
	description : "[
					Example of sound playing with background music (containing intro and loop body).
					The sound is trigger with a key press event from a window.
				]"
	author		: "Marc Plante, Insipire by Louis Marchand"
	date        : " "
	revision    : " "

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	IMG_LIBRARY_SHARED		-- To use `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		local
			l_engine:detachable GAME_ENGINE
		do
			game_library.enable_video -- Enable the video functionalities
			image_file_library.enable_image (true, false, false)
			audio_library.enable_sound
			create l_engine.make
			l_engine.run_game	  -- Run the core creator of the game.
			l_engine := Void
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library  -- Clear the library before quitting
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

					--print("yes")
				end
				--print(["click left", a_mouse_state.x, a_mouse_state.y])
			end
		end
end
