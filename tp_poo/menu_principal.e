note
	description: "Summary description for {MENU_PRINCIPAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_PRINCIPAL

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	AUDIO_LIBRARY_SHARED	-- To use `audio_library'
	IMG_LIBRARY_SHARED		-- To use `image_file_library'

create
	make

feature {NONE} -- Initialization

	make (a_sound:SOUND;a_window:GAME_WINDOW_SURFACED)


		local
			l_image:IMAGE

		do
			game_library.clear_all_events
			create l_image.make ("menu_resized.jpg")
			sounds := a_sound
			game_library.iteration_actions.extend (agent sounds.on_iteration_sound)
			game_library.iteration_actions.extend (agent on_iteration_background(?,l_image,a_window))
		end

	on_iteration_background(a_timestamp:NATURAL_32; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			l_window.surface.draw_surface (a_image, 0, 0)
			l_window.update
		end


	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			-- When the user pressed on a mouse button on `a_window'
		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				if a_mouse_state.x>=244 and a_mouse_state.x<=548 then
					if a_mouse_state.y>=206 and a_mouse_state.y<=231 then
						print("Single Player")
						--change_background("menu_resized.jpg",a_window)
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

	sounds:SOUND

end
