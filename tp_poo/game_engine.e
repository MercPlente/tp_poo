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

	make_run (a_window:GAME_WINDOW_SURFACED;a_sound:SOUND)
			-- Initialization of `Current'
		do
			sound := a_sound
			sound.play_music ("menu_principal")
			create background.make_background(a_window)
			create player.new_player
			create {LINKED_LIST[ENNEMY]} ennemies.make
			create village.new_village
			create dungeon.new_dungeon
			create deckard_cain.new_cain(980, 230)
			ennemies.extend(create {ENNEMY}.new_ennemy("kenny.png",5,100,100))
			ennemies.extend(create {ENNEMY}.new_ennemy("kenny.png",5,600,600))
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
			player.hp := 50
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			game_library.quit_signal_actions.extend (agent on_quit)
			a_window.key_pressed_actions.extend (agent on_key_down(?, ?))
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down(?, ?, ?, a_window))	-- When a mouse button is pressed
			-- a_window.mouse_motion_actions.extend (agent on_mouse_motion(?, ?) ) -- When a mouse moves on screen
			game_library.iteration_actions.extend (agent on_iteration(?, a_window))
			game_library.iteration_actions.extend (agent deplacement_ennemies(?) )
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

	sound: SOUND
	-- Le son du jeu

	village: VILLAGE
	-- la carte village

	dungeon: DUNGEON
	-- la carte dungeon

	deckard_cain: DECKARD_CAIN
	-- deckard cain (npc)


feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		local
			i:INTEGER
		do
			player.update (a_timestamp)	-- Update Player animation and coordinate
			-- Be sure that Player does not get out of the screen


			-- Draw the scene
			a_window.surface.draw_sub_surface (background.game_running_surface, (player.x + player.sub_image_width // 2), (player.y + player.sub_image_height // 2), 800, 600, 0, 0)
			a_window.surface.draw_sub_surface (
									player.surface, player.sub_image_x, player.sub_image_y,
									player.sub_image_width, player.sub_image_height,
									(a_window.surface.width - player.sub_image_width) // 2,
									(a_window.surface.height - player.sub_image_height) // 2
								)

			if not ennemies.is_empty then
				from
					i := 1
				until
					i > ennemies.count
				loop
					a_window.surface.draw_sub_surface (
											ennemies[i].surface,ennemies[i].sub_image_x, ennemies[i].sub_image_y,
											ennemies[i].sub_image_width, ennemies[i].sub_image_height,
											(a_window.surface.width - player.sub_image_width) // 2 - (player.x - ennemies[i].x),
											(a_window.surface.height - player.sub_image_height) // 2 - (player.y - ennemies[i].y)
										)
					i := i + 1
				end

			end

			if background.current_map.is_equal ("village") then
				collisions_village(a_timestamp)
				pivoter_cain
				a_window.surface.draw_surface (deckard_cain.surface,
									(a_window.surface.width - player.sub_image_width) // 2 - (player.x - deckard_cain.x),
									(a_window.surface.height - player.sub_image_height) // 2 - (player.y - deckard_cain.y)
								)
				a_window.surface.draw_surface (background.filtre_village, 0, 0)

			elseif background.current_map.is_equal ("dungeon") then
				collisions_dungeon(a_timestamp)
				a_window.surface.draw_surface (background.filtre_dungeon, 0, 0)
			end


			-- Update modification in the screen
			a_window.update
		end

	on_mouse_down(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			--  Fait deplacer le player

		do
			if player.x + (a_mouse_state.x - a_window.surface.width // 2) >= 0 then
				player.next_x := player.x + (a_mouse_state.x - a_window.surface.width // 2)
			else
				player.next_x := 0
			end
			if player.y + (a_mouse_state.y - a_window.surface.height // 2) >= 0 then
				player.next_y := player.y + (a_mouse_state.y - a_window.surface.height // 2)
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


	deplacement_ennemies(a_timestamp: NATURAL_32)
	-- Fait déplacer les ennemies selon l'emplacement du joueur
		local
			i : INTEGER
			bool : BOOLEAN
		do
			if not ennemies.is_empty then
				from
					i := 0
				until
					i >= ennemies.count
				loop
					bool := false
					--bool := collision(i+1)
					--if  then

						if ennemies[i + 1].x - player.x >= 30 and ennemies[i + 1].x >= player.x  then
							ennemies[i + 1].x := ennemies[i + 1].x - 1

						elseif ennemies[i + 1].x >= player.x then
							ennemies[i + 1].x := ennemies[i + 1].x + 1
						end

						if ennemies[i + 1].x - player.x <= -30 and ennemies[i + 1].x <= player.x  then
							ennemies[i + 1].x := ennemies[i + 1].x + 1
						elseif ennemies[i + 1].x <= player.x  then

							ennemies[i + 1].x := ennemies[i + 1].x -1
						end

						if ennemies[i + 1].y - player.y >= 30 and ennemies[i + 1].y >= player.y  then
							ennemies[i + 1].y := ennemies[i + 1].y - 1

						elseif ennemies[i + 1].y >= player.y then
							ennemies[i + 1].y := ennemies[i + 1].y + 1
						end

						if ennemies[i + 1].y - player.y <= -30 and ennemies[i + 1].y <= player.y  then
							ennemies[i + 1].y := ennemies[i + 1].y + 1

						elseif ennemies[i + 1].y <= player.y  then
							ennemies[i + 1].y := ennemies[i + 1].y -1
						end
					--end
					i := i + 1
				end

			end
		end

	collisions_ennemies(a_i : INTEGER) : BOOLEAN
		local
			direction_x : INTEGER
			direction_y : INTEGER
			i : INTEGER
			collision_x : BOOLEAN
			collision_y : BOOLEAN
			collision : BOOLEAN
		do
			direction_x := 0
			direction_y := 0
			if ennemies[a_i].x > player.x  then
					direction_x := 1
				end

			if ennemies[a_i].y > player.y then
					direction_y := 1
				end
			from
				i := a_i
			until
				i >= ennemies.count - i
			loop
				if direction_x = 1 then
					if ennemies[a_i].x - ennemies[i + 1].x < ennemies[i].surface.width and ennemies[a_i].x >= ennemies[i + 1].x  then
						collision_x := true
					end
				else
					if ennemies[a_i].x - ennemies[i + 1].x < -(ennemies[i].surface.width) and ennemies[a_i].x <= ennemies[i + 1].x  then
						collision_x := true
					end
				end


				if direction_y =1 then
					if ennemies[a_i].y - ennemies[i + 1].y < ennemies[i].surface.height and ennemies[a_i].y >= ennemies[i + 1].y  then
						collision_y := true
					end
				else
					if ennemies[a_i].y - ennemies[i + 1].y < -(ennemies[i].surface.height) and ennemies[a_i].y <= ennemies[i + 1].y then
						collision_y := true
					end
				end

				if collision_x = true and collision_y = true  then
					collision := true
				end

			end
			Result := collision
		end


	on_key_down(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
		-- Sert seulement à vérifier la position actuel du personnage en appuyant sur la touche "k"
		-- Ou changer de carte en appuyant sur "m"
		local
			i: INTEGER
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_k then
					print("Les coordonnees du joueur sont: (")
					print(player.x)
					print(", ")
					print(player.y)
					print(")%N%N")

					print("Les coordonnees de Deckard Cain sont: (")
					print(deckard_cain.x)
					print(", ")
					print(deckard_cain.y)
					print(")%N%N")

					if not ennemies.is_empty then
						from
							i := 1
						until
							i > ennemies.count
						loop
							print("Les coordonnees de l'ennemi sont: (")
							print(ennemies[i].x)
							print(", ")
							print(ennemies[i].y)
							print(")%N%N")
							i := i + 1
						end

					end

				end
				if a_key_state.is_m then -- sert à tester le changement de cartes
					if background.current_map.is_equal("village") then
						changer_carte("dungeon", a_timestamp)
					elseif background.current_map.is_equal("dungeon") then
						changer_carte("village", a_timestamp)
					end
				end
			end
		end

	pivoter_cain
		-- fait pivoter deckard_cain selon la position du player
		do
			if player.x - deckard_cain.x < 20 and player.x - deckard_cain.x > -20 then
				if deckard_cain.y >= player.y then
					deckard_cain.turn_up
				else
					deckard_cain.turn_down
				end
			elseif player.y - deckard_cain.y < 20 and player.y - deckard_cain.y > -20 then
				if deckard_cain.x >= player.x then
					deckard_cain.turn_left
				else
					deckard_cain.turn_right
				end
			elseif deckard_cain.x > player.x then
				if deckard_cain.y > player.y then
					deckard_cain.turn_up_left
				else
					deckard_cain.turn_down_left
				end
			elseif deckard_cain.x < player.x then
				if deckard_cain.y > player.y then
					deckard_cain.turn_up_right
				else
					deckard_cain.turn_down_right
				end
			end
		end

	collisions_village(a_timestamp: NATURAL_32)
		-- vérifie si le personnage est en collision avec un obstacle sur la carte "village"
		local
			plus_petite_difference_x: INTEGER
			plus_petite_difference_y: INTEGER
		do
			if background.current_map.is_equal ("village") then
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

				if ((player.x >= 392 and player.x <= 710)
					or
					(player.x >= 743 and player.x <= 1065))
					and
					(player.y >= 0 and player.y <= 68) then  -- collision avec le toit
					plus_petite_difference_y := 68 - player.y
					if 1065 - player.x <= player.x - 392 then
						plus_petite_difference_x := 1065 - player.x
					else
						plus_petite_difference_x := player.x - 392
					end
					if plus_petite_difference_y <= plus_petite_difference_x then
						player.y := 69
						player.next_y := 69
						player.stop_up
					else
						if 1065 - player.x <= player.x - 392 then
							player.x := 1066
							player.next_x := 1066
							player.stop_left
						else
							player.x := 391
							player.next_x := 391
							player.stop_right
						end
					end
				elseif (player.x >= 711 and player.x <= 742) and (player.y >= 0 and player.y <= 65) then
					changer_carte("dungeon", a_timestamp)
				end

				if player.x >= 545 and player.x <= 935 and player.y >= 385 and player.y <= 635 then -- collision avec la fontaine
					if 935 - player.x <= player.x - 545 then
						plus_petite_difference_x := 935 - player.x
					else
						plus_petite_difference_x := player.x - 545
					end
					if 635 - player.y <= player.y - 385 then
						plus_petite_difference_y := 635 - player.y
					else
						plus_petite_difference_y := player.y - 385
					end
					if plus_petite_difference_y <= plus_petite_difference_x then
						if 635 - player.y <= player.y - 385 then
							player.y := 636
							player.next_y := 636
							player.stop_up
						else
							player.y := 384
							player.next_y := 384
							player.stop_down
						end
					else
						if 935 - player.x <= player.x - 545 then
							player.x := 936
							player.next_x := 936
							player.stop_left
						else
							player.x := 544
							player.next_x := 544
							player.stop_right
						end
					end
				end
			end
		end

	collisions_dungeon(a_timestamp: NATURAL_32)
		-- vérifie si le personnage est en collision avec un obstacle sur la carte "dungeon"
		do
			if background.current_map.is_equal ("dungeon") then

				if (player.x >= 521 and player.x <= 612) and (player.y >= 2000 - player.sub_image_height) then
					changer_carte("village", a_timestamp)
				end

				if player.x < 0 then
					player.x := 0
					player.stop_left
				elseif player.x > 1200 - player.sub_image_width then
					player.x := 1200 - player.sub_image_width
					player.stop_right
				end

				if player.y < 0 then
					player.y := 0
					player.stop_up
				elseif player.y > 2000 - player.sub_image_height then
					player.y := 2000 - player.sub_image_height
					player.stop_down
				end
			end
		end


	changer_carte(nouvelle_carte: STRING; a_timestamp: NATURAL_32)
		-- change la carte
		do
			if nouvelle_carte.is_equal("village") then
				background.game_running_surface := village
				background.current_map := "village"
				player.x := 725
				player.y := 69
				player.turn_down
				player.next_x := 725
				player.next_y := 85
				if player.going_up then
					player.stop_up
				end
				player.go_down (a_timestamp)
			elseif nouvelle_carte.is_equal("dungeon") then
				background.game_running_surface := dungeon
				background.current_map := "dungeon"
				player.x := 568
				player.y := 1949
				player.turn_up
				player.next_x := 568
				player.next_y := 1935
				if player.going_down then
					player.stop_down
				end
				player.go_up (a_timestamp)
			end
		end

	on_mouse_motion (a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_MOTION_STATE)
		do

		end

	on_quit(a_timestamp: NATURAL_32)
			-- This method is called when the quit signal is send to the application (ex: window X button pressed).
		do
			game_library.stop  -- Stop the controller loop (allow game_library.launch to return)
			sound.play_music ("beginning")
		end

feature {ANY}


end
