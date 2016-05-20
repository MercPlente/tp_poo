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
			create background.make_background(a_window)
			create player.new_player
			create {LINKED_LIST[ENNEMY]} ennemies.make
			--ennemies.extend(create {ENNEMY}.new_ennemy("personnage.png",5,30,30))
			ecran := a_window
			has_error := background.has_error
		end

feature -- Access

	ennemies: LIST[ENNEMY]
			-- List of ennemies

	run (a_window:GAME_WINDOW_SURFACED)
			-- Create ressources and launch the game
		do

			player.y := 375
			player.x := 200
			player.next_y := 375
			player.next_x := 200
			player.hp := 30
			game_library.quit_signal_actions.extend (agent on_quit)
			a_window.key_pressed_actions.extend (agent on_key_down(?, ?))
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down(?, ?, ?, a_window))	-- When a mouse button is pressed
			game_library.iteration_actions.extend (agent on_iteration(?, a_window))
			game_library.launch
		end


	player:PLAYER
			-- The main character of the game

	has_error : BOOLEAN
		-- Verifie s'il n'y a pas d'erreur avant de commencer le jeu

	background:BACKGROUND
		-- La classe background pour utiliser la camera

	ecran:GAME_WINDOW_SURFACED
	-- La surface en cours


feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		local
			i:INTEGER
		do
			player.update (a_timestamp)	-- Update Player animation and coordinate
			-- Be sure that Player does not get out of the screen
			if player.x < 0 then
				player.x := 0
				player.stop_left
			elseif player.x > 1600 - player.sub_image_width then
				player.x := 1600 - player.sub_image_width
				player.stop_right
			end

			if player.y < 0 then
				player.y := 0
				player.stop_up
			elseif player.y > 1200 - player.sub_image_height then
				player.y := 1200 - player.sub_image_height
				player.stop_down
			end


			-- Draw the scene
			a_window.surface.draw_sub_surface (background.game_running_surface, (player.x + player.sub_image_width // 2), (player.y + player.sub_image_height // 2), 800, 600, 0, 0)
			a_window.surface.draw_sub_surface (
									player.surface, player.sub_image_x, player.sub_image_y,
									player.sub_image_width, player.sub_image_height, (a_window.surface.width - player.sub_image_width) // 2, (a_window.surface.height - player.sub_image_height) // 2
								)
			if not ennemies.is_empty then
				from
					i := 1
				until
					i < ennemies.count
				loop
					a_window.surface.draw_sub_surface (ennemies[i].surface,ennemies[i].x, ennemies[i].y, ennemies[i].surface.width, ennemies[i].surface.height, ennemies[i].next_x, ennemies[i].next_y)
					i := i + 1
				end

			end

			-- Update modification in the screen
			a_window.update
		end

	verifier_collisions(player_x: INTEGER; player_y: INTEGER; carte: STRING)
			-- Vérifie si le joueur entre en collision avec un objet selon des coordonnees précises
		do
			if carte = "village" then
				--collisions village
			elseif carte = "dungeon" then
				--collisions dungeon
			end
		end

	on_mouse_down(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			--  Fait deplacer le player

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

	on_key_down(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
		-- Sert seulement à vérifier la position actuel du personnage en appuyant sur la touche "k"
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_k then
					print("Les coordonnees du joueur sont: (")
					print(player.x)
					print(", ")
					print(player.y)
					print(")%N")
				end
				if a_key_state.is_m then -- sert à tester le changement de cartes
					if background.current_map.is_equal("village") then
						changer_carte("dungeon")
					elseif background.current_map.is_equal("dungeon") then
						changer_carte("village")
					end
				end
			end
		end

	changer_carte(nouvelle_carte: STRING)
		-- change la carte
		local
			village: VILLAGE
			dungeon: DUNGEON
		do
			if nouvelle_carte.is_equal("village") then
				create village.new_village
				background.game_running_surface := village
				background.current_map := "village"
			elseif nouvelle_carte.is_equal("dungeon") then
				create dungeon.new_dungeon
				background.game_running_surface := dungeon
				background.current_map := "dungeon"
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
		end

feature {ANY}


end
