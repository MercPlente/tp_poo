note
	description: "Classe pour modifier des elements en jeu. Grandement inspir�e de la classe 'engine' de Louis"
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
			sound.play_music ("tristram")
			create font.make ("DIABLO_L.TTF", 27)
			if font.is_openable then
				font.open
			end
			create background.make_background(a_window)
			create player.new_player
			create {LINKED_LIST[ENNEMY]} ennemies.make
			create village.new_village
			create dungeon.new_dungeon
			create deckard_cain.new_cain(980, 230)
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png",5,250,500))
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png",5,300,650))
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre3.png",5,100,1000))
			ecran := a_window
			has_error := background.has_error
		end

feature -- Access

	ennemies: LIST[ENNEMY]
			-- List of ennemies

	run (a_window:GAME_WINDOW_SURFACED)
			-- Create ressources and launch the game
		do

			player.y := 400
			player.x := 200
			player.next_y := 400
			player.next_x := 200
			player.hp := 50
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			game_library.quit_signal_actions.extend (agent on_quit)
			a_window.key_pressed_actions.extend (agent on_key_down(?, ?))
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down(?, ?, ?, a_window))	-- When a mouse button is pressed
			-- a_window.mouse_motion_actions.extend (agent on_mouse_motion(?, ?, ?, ?) ) -- When a mouse moves on screen
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

	sound: SOUND
	-- Le son du jeu

	village: VILLAGE
	-- la carte village

	dungeon: DUNGEON
	-- la carte dungeon

	deckard_cain: DECKARD_CAIN
	-- deckard cain (npc)

	font: TEXT_FONT
	-- Used to draw text


feature {NONE} -- Implementation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Event that is launch at each iteration.
		local
			i:INTEGER
			l_text: TEXT_SURFACE_BLENDED
			l_hp_string: STRING_32
		do
			player.update (a_timestamp)	-- Update Player animation and coordinate


			-- Draw the scene
			a_window.surface.draw_sub_surface (background.game_running_surface, (player.x + player.sub_image_width // 2), (player.y + player.sub_image_height // 2), 800, 600, 0, 0)
			a_window.surface.draw_sub_surface (
									player.surface, player.sub_image_x, player.sub_image_y,
									player.sub_image_width, player.sub_image_height,
									(a_window.surface.width - player.sub_image_width) // 2,
									(a_window.surface.height - player.sub_image_height) // 2
								)



			if background.current_map.is_equal ("village") then
				collisions_village(a_timestamp)
				pivoter_cain
				a_window.surface.draw_surface (deckard_cain.surface,
									(a_window.surface.width - player.sub_image_width) // 2 - (player.x - deckard_cain.x),
									(a_window.surface.height - player.sub_image_height) // 2 - (player.y - deckard_cain.y)
								)
				a_window.surface.draw_surface (background.filtre_village, 0, 0)

			elseif background.current_map.is_equal ("dungeon") then
				if not background.door_open then
					a_window.surface.draw_surface(background.door,
									(a_window.surface.width - player.sub_image_width) // 2 - (player.x - 521),
									(a_window.surface.height - player.sub_image_height) // 2 - (player.y - 382)
								)
				end

				if not ennemies.is_empty then
				deplacement_ennemies(a_timestamp)

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
				collisions_dungeon(a_timestamp)
				a_window.surface.draw_surface (background.filtre_dungeon, 0, 0)

			end

			a_window.surface.draw_surface (player.barre, 0, 0)
			if font.is_open then
				l_hp_string := player.hp.out
				create l_text.make (l_hp_string, font, create {GAME_COLOR}.make_rgb (255, 255, 255))
				if not l_text.has_error then
					a_window.surface.draw_surface (l_text, 17, 406)
				end
			end

			-- Update modification in the screen
			a_window.update
		end


	deplacement_ennemies(a_timestamp: NATURAL_32)
	-- Fait d�placer les ennemies selon l'emplacement du joueur
		local
			i : INTEGER
			list : LIST [INTEGER]
		do
			create {LINKED_LIST[INTEGER]} list.make
			if not ennemies.is_empty then
				from
					i := 1
				until
					i > ennemies.count
				loop
					list := collisions_ennemies(i)


					if ennemies[i].x - player.x <= 30 and ennemies[i].x - player.x >= -30 and ennemies[i].y - player.y <= 30 and ennemies[i].y - player.y >= 30  then

					else

						if ennemies[i].x - player.x >= 30 and ennemies[i].x >= player.x  then
							if list.has (0) or list.has (4) or list.has (5) then
								ennemies[i].x := ennemies[i].x - 1
								ennemies[i].turn_left
							end
						end

						if ennemies[i].x - player.x <= -30 and ennemies[i].x <= player.x  then
							if list.has (0) or list.has (4) or list.has (6)  then
								ennemies[i].x := ennemies[i].x + 1
								ennemies[i].turn_right
							end
						end

						if ennemies[i].y - player.y >= 30 and ennemies[i].y >= player.y  then
							if list.has (0) or list.has (1) or list.has (2)  then
								ennemies[i].y := ennemies[i].y - 1
								ennemies[i].turn_down
							end
						end

						if ennemies[i].y - player.y <= -30 and ennemies[i].y <= player.y  then
							if list.has (0) or list.has (1) or list.has (3)  then
								ennemies[i].y := ennemies[i].y + 1
								ennemies[i].turn_up
							end
						end
					end
					i := i + 1
				end

			end
		end

	collisions_ennemies(a_i : INTEGER) : LIST [INTEGER]
		local
			direction_x : INTEGER
			direction_y : INTEGER
			i : INTEGER
			collision_x_gauche : BOOLEAN
			collision_y_haut : BOOLEAN
			collision_x_droite : BOOLEAN
			collision_y_bas : BOOLEAN
			collision : LIST [INTEGER]
		do
			create {LINKED_LIST[INTEGER]} collision.make
			direction_x := 0
			direction_y := 0
			collision_x_gauche := false
			collision_y_haut := false
			collision_x_droite := false
			collision_y_bas := false
			if ennemies[a_i].x >= player.x  then
					direction_x := 1
				end

			if ennemies[a_i].y >= player.y then
					direction_y := 1
			end

			from
				i := 1
			until
				i > ennemies.count
			loop
				if not (i = a_i) then
					if direction_x = 1 then

						if ennemies[a_i].x - ennemies[i].x <= 20 and ennemies[a_i].x >= ennemies[i].x and ennemies[a_i].y - ennemies[i].y <= 20 and ennemies[a_i].y - ennemies[i].y >= -20 then
							collision_x_gauche := true
						end
					else
						if ennemies[i].x - ennemies[a_i].x <= 20 and ennemies[a_i].x <= ennemies[i].x and ennemies[a_i].y - ennemies[i].y <= 20 and ennemies[a_i].y - ennemies[i].y >= -20  then
							collision_x_droite := true
						end
					end


					if direction_y =1 then
						if ennemies[a_i].y - ennemies[i].y <= 20 and ennemies[a_i].y >= ennemies[i].y and ennemies[a_i].x - ennemies[i].x <= 20 and ennemies[a_i].x - ennemies[i].x >= -20  then
							collision_y_haut := true
						end
					else
						if ennemies[i].y - ennemies[a_i].y <= 20 and ennemies[a_i].y <= ennemies[i].y and ennemies[a_i].x - ennemies[i].x <= 20 and ennemies[a_i].x - ennemies[i].x >= -20 then
							collision_y_bas := true
						end
					end

				end
				i := i + 1
			end
			if collision_x_gauche = true or collision_x_droite = true or collision_y_haut = true or collision_y_bas = true  then
				collision := collision_retour(collision_x_gauche,collision_x_droite,collision_y_haut,collision_y_bas)
			else
				collision.extend (0)
			end
			Result := collision
		end

	collision_retour(x_gauche, x_droite, y_haut, y_bas: BOOLEAN) : LIST [INTEGER]
		local
			chemin: LIST [INTEGER]
		do
			create {LINKED_LIST[INTEGER]} chemin.make
				if y_haut = false and y_bas = false then
					chemin.extend (1)
				elseif y_haut = false then
					chemin.extend (2)
				elseif y_bas = false then
					chemin.extend (3)
				end

				if x_gauche = false and x_droite = false then
					chemin.extend (4)
				elseif x_gauche = false then
					chemin.extend (5)
				elseif x_droite = false then
					chemin.extend (6)
				end


			Result := chemin

		end

	pivoter_cain
		-- fait pivoter deckard_cain selon la position du player
		do
			if not deckard_cain.is_selected then
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
			elseif deckard_cain.is_selected then
				if player.x - deckard_cain.x < 20 and player.x - deckard_cain.x > -20 then
					if deckard_cain.y >= player.y then
						deckard_cain.turn_up_s
					else
						deckard_cain.turn_down_s
					end
				elseif player.y - deckard_cain.y < 20 and player.y - deckard_cain.y > -20 then
					if deckard_cain.x >= player.x then
						deckard_cain.turn_left_s
					else
						deckard_cain.turn_right_s
					end
				elseif deckard_cain.x > player.x then
					if deckard_cain.y > player.y then
						deckard_cain.turn_up_left_s
					else
						deckard_cain.turn_down_left_s
					end
				elseif deckard_cain.x < player.x then
					if deckard_cain.y > player.y then
						deckard_cain.turn_up_right_s
					else
						deckard_cain.turn_down_right_s
					end
				end
			end

		end

	collisions_village(a_timestamp: NATURAL_32)
		-- v�rifie si le personnage est en collision avec un obstacle sur la carte "village"
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
		-- v�rifie si le personnage est en collision avec un obstacle sur la carte "dungeon"
		local
			i: INTEGER
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

				collision_entity_objet(329, 444, 1090, 1441, player, "player") -- collision bibli
				collision_entity_objet(694, 803, 1090, 1441, player, "player") -- collision bibli
				collision_entity_objet(395, 747, 794, 903, player, "player") -- collision bibli
				collision_entity_objet(456, 516, 1679, 2000, player, "player")	-- collision mur
				collision_entity_objet(617, 677, 1679, 2000, player, "player")	-- collision mur
				collision_entity_objet(0, 520, 327, 402, player, "player")	-- collision mur
				collision_entity_objet(616, 1150, 327, 402, player, "player")	-- collision mur
				if not background.door_open then
					collision_entity_objet(520, 616, 327, 402, player, "player")	-- collision porte
				end

				if not ennemies.is_empty then
					from
						i := 1
					until
						i > ennemies.count
					loop
						collision_entity_objet(ennemies[i].x - player.sub_image_width // 2, ennemies[i].x + ennemies[i].sub_image_width - player.sub_image_width // 2,
											ennemies[i].y - player.sub_image_height // 2, ennemies[i].y + ennemies[i].sub_image_height - player.sub_image_height // 2, player, "player")

						collision_entity_objet(339, 454, 1080, 1431, ennemies[i], "ennemi")
						collision_entity_objet(704, 813, 1080, 1431, ennemies[i], "ennemi")
						collision_entity_objet(405, 757, 784, 893, ennemies[i], "ennemi")
						collision_entity_objet(466, 506, 1689, 1990, ennemies[i], "ennemi")
						collision_entity_objet(627, 667, 1689, 1990, ennemies[i], "ennemi")
						collision_entity_objet(0, 510, 337, 392, ennemies[i], "ennemi")
						collision_entity_objet(626, 1150, 337, 392, ennemies[i], "ennemi")
						if not background.door_open then
							collision_entity_objet(520, 616, 327, 402, ennemies[i], "ennemi")
						end

						i := i + 1
					end
				end
			end
		end

	collision_entity_objet(x_min: INTEGER; x_max: INTEGER; y_min: INTEGER; y_max: INTEGER; entity: ENTITY; type: STRING)
		local
			plus_petite_difference_x: INTEGER
			plus_petite_difference_y: INTEGER
		do
			if entity.x >= x_min and entity.x <= x_max and entity.y >= y_min and entity.y <= y_max then -- collision une biblioth�que
				if x_max - entity.x <= entity.x - x_min then
					plus_petite_difference_x := x_max - entity.x
				else
					plus_petite_difference_x := entity.x - x_min
				end
				if y_max - entity.y <= player.y - y_min then
					plus_petite_difference_y := y_max - entity.y
				else
					plus_petite_difference_y := entity.y - y_min
				end
				if plus_petite_difference_y <= plus_petite_difference_x then
					if y_max - entity.y <= entity.y - y_min then
						entity.y := y_max + 1
						if type.is_equal ("player") then
							entity.next_y := y_max + 1
							entity.stop_up
						end
					else
						entity.y := y_min - 1
						if type.is_equal ("player") then
							entity.next_y := y_min - 1
							entity.stop_down
						end
					end
				else
					if x_max - entity.x <= entity.x - x_min then
						entity.x := x_max + 1
						if type.is_equal ("player") then
							entity.next_x := x_max + 1
							entity.stop_left
						end
					else
						entity.x := x_min - 1
						if type.is_equal ("player") then
							entity.next_x := x_min - 1
							entity.stop_right
						end
					end
				end
			end
		end


	changer_carte(nouvelle_carte: STRING; a_timestamp: NATURAL_32)
		-- change la carte
		do
			if nouvelle_carte.is_equal("village") then
				sound.play_music("tristram")
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
				sound.play_music ("dungeon")
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


	on_key_down(a_timestamp: NATURAL_32; a_key_state: GAME_KEY_STATE)
		-- Sert seulement � v�rifier la position actuel du personnage en appuyant sur la touche "k"
		-- Ou changer de carte en appuyant sur "m"
		local
			i: INTEGER
		do
			if not a_key_state.is_repeat then
				if a_key_state.is_k then
					background.door_open := True
					deckard_cain.is_selected := True

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
				if a_key_state.is_m then -- sert � tester le changement de cartes
					if background.current_map.is_equal("village") then
						changer_carte("dungeon", a_timestamp)
					elseif background.current_map.is_equal("dungeon") then
						changer_carte("village", a_timestamp)
					end
				end
			end
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

	on_mouse_motion (a_timestamp: NATURAL_32; mouse_state:GAME_MOUSE_MOTION_STATE; int1: INTEGER; int2: INTEGER)
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
