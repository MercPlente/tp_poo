note
	description: "Classe pour modifier des elements en jeu. Grandement inspirée de la classe 'engine' de Louis"
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialization

	make (a_window:GAME_WINDOW_SURFACED)
			-- Initialization of `Current'
		do
			create village.new_village
			create player.new_player
			has_error := village.has_error or player.has_error
		end

feature -- Access

	run (a_window:GAME_WINDOW_SURFACED)
			-- Create ressources and launch the game
		do

			player.y := 375
			player.x := 200
			player.next_y := 375
			player.next_x := 200
			game_library.quit_signal_actions.extend (agent on_quit)
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down)	-- When a mouse button is pressed
			game_library.iteration_actions.extend (agent on_iteration(?, a_window))
			game_library.launch
		end

	has_error:BOOLEAN
			-- `True' if an error occured during the creation of `Current'

	village:VILLAGE
			-- The background

	player:PLAYER
			-- The main character of the game



feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			player.update (a_timestamp)	-- Update Player animation and coordinate
			-- Be sure that Player does not get out of the screen
			if player.x < 0 then
				player.x := 0
			elseif player.x + player.sub_image_width > village.width then
				player.x := village.width - player.sub_image_width
			end

			-- Draw the scene
			a_window.surface.draw_surface (village, 0, 0)
			a_window.surface.draw_sub_surface (
									player.surface, player.sub_image_x, player.sub_image_y,
									player.sub_image_width, player.sub_image_height, player.x, player.y
								)

			-- Update modification in the screen
			a_window.update
		end

	on_mouse_down(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8)
			-- When the user pressed the left mouse button (from `a_mouse_state'), start to move maryo
		do

			player.next_x := a_mouse_state.x
			player.next_y := a_mouse_state.y

			if a_mouse_state.x > player.x + (player.surface.width // 6) then
				player.stop_left
				player.go_right (a_timestamp)
			elseif a_mouse_state.x < player.x + (player.surface.width // 6) then
				player.stop_right
				player.go_left (a_timestamp)
			end

			if a_mouse_state.y > player.y + (player.surface.height // 2) then
				player.stop_up
				player.go_down (a_timestamp)
			elseif a_mouse_state.y < player.y + (player.surface.height // 2) then
				player.stop_down
				player.go_up (a_timestamp)
			end

		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

end
