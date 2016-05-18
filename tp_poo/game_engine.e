note
	description: "Classe pour modifier des elements en jeu. Grandement inspirée de la classe 'engine' de Louis"
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	GAME_ENGINE

inherit
	GAME_LIBRARY_SHARED		-- To use `game_library'
	IMG_LIBRARY_SHARED
	EXCEPTIONS

create
	make_run

feature {NONE} -- Initialization

	make_run (a_window:GAME_WINDOW_SURFACED)
			-- Initialization of `Current'
		do
			create background.nouvelle_camera(a_window)
			create player.new_player
			 ecran := a_window
			has_error := background.has_error

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
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down(?, ?, ?, a_window))	-- When a mouse button is pressed
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down_2)
			game_library.iteration_actions.extend (agent on_iteration(?, a_window))
			game_library.launch
		end


	player:PLAYER
			-- The main character of the game

	has_error : BOOLEAN

	background:BACKGROUND

	ecran:GAME_WINDOW_SURFACED



feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		do
			player.update (a_timestamp)	-- Update Player animation and coordinate
			-- Be sure that Player does not get out of the screen
			if player.x < 0 then
				player.x := 0
			elseif player.x + player.sub_image_width > ecran.width then
				player.x := ecran.width - player.sub_image_width
			end

			-- Draw the scene
			a_window.surface.draw_sub_surface (background.game_running_surface, (player.x + player.sub_image_width // 2) + a_window.surface.width // 2, (player.y + player.sub_image_height // 2) + a_window.surface.height // 2, 800, 600, background.camera_x, background.camera_y)
			a_window.surface.draw_sub_surface (
									player.surface, player.sub_image_x, player.sub_image_y,
									player.sub_image_width, player.sub_image_height, (a_window.surface.width - player.sub_image_width) // 2, (a_window.surface.height - player.sub_image_height) // 2
								)

			-- Update modification in the screen
			a_window.update
		end

	on_mouse_down(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			-- When the user pressed the left mouse button (from `a_mouse_state'), start to move maryo

		do
			if (player.x + player.sub_image_width // 2) + (a_mouse_state.x - a_window.surface.width // 2) >= 0 then
				player.next_x := (player.x + player.sub_image_width // 2) + (a_mouse_state.x - a_window.surface.width // 2)
			else
				player.next_x := 0
			end
			if (player.y + player.sub_image_height // 2) + (a_mouse_state.y - a_window.surface.height // 2) >= 0 then
				player.next_y := (player.y + player.sub_image_height // 2) + (a_mouse_state.y - a_window.surface.height // 2)
			else
				player.next_y := 0
			end

			if ((player.x + player.sub_image_width // 2) + (a_mouse_state.x - a_window.surface.width // 2)) > (player.x + player.sub_image_width // 2) then
				player.stop_left
				player.go_right (a_timestamp)
			elseif ((player.x + player.sub_image_width // 2) + (a_mouse_state.x - a_window.surface.width // 2)) < (player.x + player.sub_image_width // 2) then
				player.stop_right
				player.go_left (a_timestamp)
			end

			if ((player.y + player.sub_image_height // 2) + (a_mouse_state.y - a_window.surface.height // 2)) > (player.y + player.sub_image_height // 2) then
				player.stop_up
				player.go_down (a_timestamp)
			elseif ((player.y + player.sub_image_height // 2) + (a_mouse_state.y - a_window.surface.height // 2)) < (player.y + player.sub_image_height // 2) then
				player.stop_down
				player.go_up (a_timestamp)
			end

		end

	on_mouse_down_2(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8)

		do
			if  a_mouse_state.x >= (ecran.width // 2) then
				--print("yé plus grand que la moitier")
				background.next_background_x := background.camera_x + ((a_mouse_state.x) + ecran.width // 2)
			else
				--print("yé plus petit que la moitier")
				background.next_background_x := background.camera_x + (-(a_mouse_state.x) + ecran.width // 2)
			end

			--background.next_background_y := background.camera_y + (a_mouse_state.y - ecran.height // 2)

		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

feature {ANY}


end
