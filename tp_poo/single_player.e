note
	description: "Classe gerant les options lorsque l'utilisateur choisi le mode: Single Player."
	author: "Marc Plante, Jeremie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	MENU_SINGLE_PLAYER

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	single_player

feature {NONE}

	single_player (a_window:GAME_WINDOW_SURFACED)

		local
			l_image:IMAGE

		do
			a_window.clear_events
			from
				game_library.iteration_actions.finish
			until
				game_library.iteration_actions.count <= 1
			loop
				game_library.iteration_actions.remove
				game_library.iteration_actions.back
			end

			create l_image.make ("single_player.png")
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_pressed(?, ?, ?, a_window))
			game_library.iteration_actions.extend (agent on_iteration_background(?,l_image,a_window))
		end

	on_iteration_background(a_timestamp:NATURAL_32; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED)
			-- Evenement mettant a jour le fond d'ecran a chaque iteration .
		do
			l_window.surface.draw_surface (a_image, 0, 0)
			l_window.update
		end

	on_mouse_pressed(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			-- description TODO

		local
			l_new_game:NEW_GAME

		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				--print([a_mouse_state.x,a_mouse_state.y])
				if a_mouse_state.x>=235 and a_mouse_state.x<=556 then
					if a_mouse_state.y>=56 and a_mouse_state.y<=130 then
						create l_new_game.new_game (a_window)
					end
					if a_mouse_state.y>=170 and a_mouse_state.y<=242 then
						--continue
					end
					if a_mouse_state.y>=56 and a_mouse_state.y<=130 then
						--back
					end
				end
			end
		end

end
