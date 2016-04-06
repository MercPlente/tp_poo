note
	description: "Menu de création d'un nouveau personnage. L'utilisateur doit choisir son nom de héros."
	author: "Marc Plante, Jeremie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	NEW_GAME

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	new_game

feature {NONE}

	new_game (a_window:GAME_WINDOW_SURFACED)
		-- Fonction qui recommence les iterations avec les nouvelles valeurs pour ce menu.
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

			create l_image.make ("create_game.png")
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
			-- Fonction envoyant l'utilisateur dans la section "Start"
			--ou "back" selon l'endroit ou il clique
		require
			Souris_Appuyer_Correctement: a_mouse_state.is_left_button_pressed
			Nombre_Click: a_nb_clicks >= 1

		local
			l_village:VILLAGE

		do
			if a_nb_clicks = 1 and a_mouse_state.is_left_button_pressed then
				--print([a_mouse_state.x,a_mouse_state.y])
				if a_mouse_state.x>=604 and a_mouse_state.x<=779 then
					if a_mouse_state.y>=516 and a_mouse_state.y<=569 then
						--in_game
					end
				end
			end
		end

end
