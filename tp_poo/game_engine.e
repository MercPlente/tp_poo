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
			-- Constructeur du game_engine
		do
			clicked := ""
			sound := a_sound
			sound.play_music ("tristram")
			create font.make ("DIABLO_L.TTF", 27)
			if font.is_openable then
				font.open
			end
			create font_smaller.make ("DIABLO_L.TTF", 22)
			if font_smaller.is_openable then
				font_smaller.open
			end
			create background.make_background(a_window)
			create player.new_player
			create {LINKED_LIST[ENNEMY]} ennemies.make
			create {LINKED_LIST[LEVER]} levier.make
			create village.new_village
			create dungeon.new_dungeon
			create deckard_cain.new_cain(980, 230)
			levier.extend(create {LEVER}.make_levier(100,485))
			levier.extend(create {LEVER}.make_levier(100,1860))
			levier.extend(create {LEVER}.make_levier(1060,485))
			levier.extend(create {LEVER}.make_levier(1060,1860))
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,250,500))
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,300,650))
			ennemies.extend(create {ENNEMY}.new_ennemy("monstre3.png","monstre3_s.png",10,100,1000))
			ecran := a_window
			has_error := background.has_error
		end

feature

	run (a_window:GAME_WINDOW_SURFACED)
			-- Creation des ressources du jeu
		do

			player.y := 400
			player.x := 200
			player.next_y := 400
			player.next_x := 200
			player.hp := 50
			game_library.iteration_actions.extend (agent on_death)
			game_library.iteration_actions.extend (agent sound.on_iteration_sound)
			game_library.quit_signal_actions.extend (agent on_quit)
			a_window.mouse_button_pressed_actions.extend (agent on_mouse_down(?, ?, ?, a_window))	-- When a mouse button is pressed
			a_window.mouse_motion_actions.extend (agent on_mouse_motion(?, ?, ?, ?) ) -- When a mouse moves on screen
			game_library.iteration_actions.extend (agent on_iteration(?, a_window))
			game_library.launch
		end

	ennemies: LIST[ENNEMY]
			-- Liste des ennemies

	levier: LIST[LEVER]

	player:PLAYER
			-- Le joueur

	has_error : BOOLEAN
		-- Vérifie s'il n'y a pas d'erreur avant de commencer le jeu

	background:BACKGROUND
		-- La classe background pour modifier le fond d'écran

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
	-- Pour écrire du texte

	font_smaller: TEXT_FONT
	-- Pour écrire du texte

	clicked: STRING
	-- Objet cliqué


feature {NONE} -- Implémentation

	on_iteration(a_timestamp:NATURAL_32; a_window:GAME_WINDOW_SURFACED)
			-- Évenements produites à chaque itération
		local
			i:INTEGER
			l_text: TEXT_SURFACE_BLENDED
			l_selection: INTEGER
			l_text2: TEXT_SURFACE_BLENDED
			l_text3: TEXT_SURFACE_BLENDED
			l_text_cain: TEXT_SURFACE_BLENDED
			l_text_levier: TEXT_SURFACE_BLENDED
			l_text_levier2: TEXT_SURFACE_BLENDED
		do
			l_selection := 0
			player.update (a_timestamp)

			a_window.surface.draw_sub_surface (background.game_running_surface, (player.x + player.sub_image_width // 2), (player.y + player.sub_image_height // 2), 800, 600, 0, 0)

			if not levier.is_empty and background.current_map.is_equal ("dungeon") then

				from
					i := 1
				until
					i > levier.count
				loop
					a_window.surface.draw_surface (levier[i].lever_running_surface,(a_window.surface.width - player.sub_image_width) // 2 - (player.x - levier[i].x),(a_window.surface.height - player.sub_image_height) // 2 - (player.y - levier[i].y))

					i := i + 1
				end
			end

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
					if ennemies[i].is_selected then
						l_selection := i
					end

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
				create l_text.make (player.hp.out, font, create {GAME_COLOR}.make_rgb (255, 255, 255))
				if not l_text.has_error then
					a_window.surface.draw_surface (l_text, 17, 406)
				end
			end

			if ennemies.valid_index (l_selection) then
				if font.is_open then
					create l_text2.make ("HP: "+ennemies[l_selection].hp.out, font_smaller, create {GAME_COLOR}.make_rgb (255, 255, 255))
					if not l_text2.has_error then
						a_window.surface.draw_surface (l_text2, 370, 550)
					end
					create l_text3.make ("Ennemy", font, create {GAME_COLOR}.make_rgb (255, 255, 255))
					if not l_text3.has_error then
						a_window.surface.draw_surface (l_text3, 340, 520)
					end
				end
			end

			if deckard_cain.is_selected and background.current_map.is_equal ("village") then
				if font.is_open then
					create l_text_cain.make ("Deckard Cain", font_smaller, create {GAME_COLOR}.make_rgb (255, 255, 255))
					if not l_text_cain.has_error then
						a_window.surface.draw_surface (l_text_cain, 315, 540)
					end
				end
			end

			if not levier.is_empty then

				from
					i := 1
				until
					i > levier.count
				loop
					if levier[i].is_selected then
						create l_text_levier.make ("Lever", font, create {GAME_COLOR}.make_rgb (255, 255, 255))
						if not l_text_levier.has_error then
							a_window.surface.draw_surface (l_text_levier, 350, 520)
						end
						if levier[i].levier_ouvert then
							create l_text_levier2.make ("Opened", font_smaller, create {GAME_COLOR}.make_rgb (255, 255, 255))
							if not l_text_levier2.has_error then
								a_window.surface.draw_surface (l_text_levier2, 350, 550)
							end
						else
							create l_text_levier2.make ("Closed", font_smaller, create {GAME_COLOR}.make_rgb (255, 255, 255))
							if not l_text_levier2.has_error then
								a_window.surface.draw_surface (l_text_levier2, 350, 550)
							end
						end
					end

					i := i + 1
				end
			end

			a_window.update
		end


	deplacement_ennemies(a_timestamp: NATURAL_32)
	-- Fait déplacer les ennemies selon l'emplacement du joueur
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

					if ennemies[i].x - player.x > 20 and ennemies[i].x >= player.x  then
						if not ennemies[i].is_selected then
							ennemies[i].turn_left
						else
							ennemies[i].turn_left_s
						end
					end
					if ennemies[i].x - player.x < -20 and ennemies[i].x <= player.x  then
						if not ennemies[i].is_selected then
							ennemies[i].turn_right
						else
							ennemies[i].turn_right_s
						end
					end
					if ennemies[i].y - player.y > 20 and ennemies[i].y >= player.y  then
						if not ennemies[i].is_selected then
							ennemies[i].turn_down
						else
							ennemies[i].turn_down_s
						end
					end
					if ennemies[i].y - player.y < -20 and ennemies[i].y <= player.y  then
						if not ennemies[i].is_selected then
							ennemies[i].turn_up
						else
							ennemies[i].turn_up_s
						end
					end

					if ennemies[i].x - player.x <= 30 and ennemies[i].x - player.x >= -30 and ennemies[i].y - player.y <= 30 and ennemies[i].y - player.y >= 30  then


					else

						if ennemies[i].x - player.x >= 30 and ennemies[i].x >= player.x  then
							if list.has (0) or list.has (4) or list.has (5) then
								ennemies[i].x := ennemies[i].x - 1
							end
						end

						if ennemies[i].x - player.x <= -30 and ennemies[i].x <= player.x  then
							if list.has (0) or list.has (4) or list.has (6)  then
								ennemies[i].x := ennemies[i].x + 1

							end
						end

						if ennemies[i].y - player.y >= 30 and ennemies[i].y >= player.y  then
							if list.has (0) or list.has (1) or list.has (2)  then
								ennemies[i].y := ennemies[i].y - 1

							end
						end

						if ennemies[i].y - player.y <= -30 and ennemies[i].y <= player.y  then
							if list.has (0) or list.has (1) or list.has (3)  then
								ennemies[i].y := ennemies[i].y + 1

							end
						end
					end
					i := i + 1
				end

			end
		end

	collisions_ennemies(a_i : INTEGER) : LIST [INTEGER]
		-- Vérifie s'il y une collision avec un ennemi
		require
			a_i_plus_petit_que_zero : a_i > 0
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
		-- Retourne quel chemin l'ennemi peut prendre
		require
			x_gauche_correct : x_gauche = true or x_gauche = false
			x_droite_correct : x_droite = true or x_droite = false
			y_haut_correct : y_haut = true or y_haut = false
			y_bas_correct: y_bas = true or y_bas = false
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

	action_cain
	-- Met la vie du joueur au maximum
		do
			player.hp := 50
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

				collision_entity_objet(545, 935, 385, 635, player, "player", "f", a_timestamp) -- collision fontaine
				collision_entity_objet(deckard_cain.x - player.sub_image_width // 2, deckard_cain.x + deckard_cain.sub_image_width - player.sub_image_width // 2,
											deckard_cain.y - player.sub_image_height // 2, deckard_cain.y + deckard_cain.sub_image_height - player.sub_image_height // 2, player, "player", "cain", a_timestamp) -- collision deckard_cain

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

				collision_entity_objet(329, 444, 1090, 1441, player, "player", "b", a_timestamp) -- collision bibli
				collision_entity_objet(694, 803, 1090, 1441, player, "player", "b", a_timestamp) -- collision bibli
				collision_entity_objet(395, 747, 794, 903, player, "player", "b", a_timestamp) -- collision bibli
				collision_entity_objet(456, 516, 1679, 2000, player, "player", "m", a_timestamp)	-- collision mur
				collision_entity_objet(617, 677, 1679, 2000, player, "player", "m", a_timestamp)	-- collision mur
				collision_entity_objet(0, 520, 327, 402, player, "player", "m", a_timestamp)	-- collision mur
				collision_entity_objet(616, 1150, 327, 402, player, "player", "m", a_timestamp)	-- collision mur
				if not background.door_open then
					collision_entity_objet(520, 616, 327, 402, player, "player", "p", a_timestamp)	-- collision porte
				end

				across levier as la_levier loop
					collision_entity_objet(la_levier.item.x - player.sub_image_width // 2 - 10, la_levier.item.x + la_levier.item.lever_running_surface.width - player.sub_image_width // 2 + 10,
										la_levier.item.y - player.sub_image_height // 2 - 10, la_levier.item.y + la_levier.item.lever_running_surface.height - player.sub_image_height // 2 + 10,
										player, "player", "levier" + la_levier.cursor_index.out, a_timestamp)	-- collision levier

				end

				across ennemies as la_ennemy loop
					collision_entity_objet(la_ennemy.item.x - player.sub_image_width // 2 - 15, la_ennemy.item.x + la_ennemy.item.sub_image_width - player.sub_image_width // 2 + 15,
										la_ennemy.item.y - player.sub_image_height // 2 - 15, la_ennemy.item.y + la_ennemy.item.sub_image_height - player.sub_image_height // 2 + 15,
										player, "player", "ennemi" + la_ennemy.cursor_index.out, a_timestamp) -- collision ennemi

					collision_entity_objet(339, 454, 1080, 1431, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(704, 813, 1080, 1431, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(405, 757, 784, 893, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(466, 506, 1689, 1990, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(627, 667, 1689, 1990, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(0, 510, 337, 392, la_ennemy.item, "ennemi", "", a_timestamp)
					collision_entity_objet(626, 1150, 337, 392, la_ennemy.item, "ennemi", "", a_timestamp)
					if not background.door_open then
						collision_entity_objet(520, 616, 327, 402, la_ennemy.item, "ennemi", "", a_timestamp)
					end
				end
			end
		end

	collision_entity_objet(x_min: INTEGER; x_max: INTEGER; y_min: INTEGER; y_max: INTEGER; entity: ENTITY; type: STRING; type2: STRING; a_timestamp:NATURAL_32)
		-- Vérifie les collisions de deux objets et agit en conséquence
		local
			plus_petite_difference_x: INTEGER
			plus_petite_difference_y: INTEGER
		do
			if entity.x >= x_min and entity.x <= x_max and entity.y >= y_min and entity.y <= y_max then -- collision une bibliothèque
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
							if type2.item(1).is_equal('e') then
								attaquer_joueur(type2.item(7).out, a_timestamp)
							end
							if type2.is_equal ("cain") and clicked.is_equal ("deckard_cain") then
								action_cain
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('e') then
								attaquer_ennemi(type2.item(7).out, a_timestamp)
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('l') then
								action_levier(type2.item(7).out)
								clicked := ""
							end
						end
					else
						entity.y := y_min - 1
						if type.is_equal ("player") then
							entity.next_y := y_min - 1
							entity.stop_down
							if type2.item(1).is_equal('e') then
								attaquer_joueur(type2.item(7).out, a_timestamp)
							end
							if type2.is_equal ("cain") and clicked.is_equal ("deckard_cain") then
								action_cain
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('e') then
								attaquer_ennemi(type2.item(7).out, a_timestamp)
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('l') then
								action_levier(type2.item(7).out)
								clicked := ""
							end
						end
					end
				else
					if x_max - entity.x <= entity.x - x_min then
						entity.x := x_max + 1
						if type.is_equal ("player") then
							entity.next_x := x_max + 1
							entity.stop_left
							if type2.item(1).is_equal('e') then
								attaquer_joueur(type2.item(7).out, a_timestamp)
							end
							if type2.is_equal ("cain") and clicked.is_equal ("deckard_cain") then
								action_cain
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('e') then
								attaquer_ennemi(type2.item(7).out, a_timestamp)
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('l') then
								action_levier(type2.item(7).out)
								clicked := ""
							end
						end
					else
						entity.x := x_min - 1
						if type.is_equal ("player") then
							entity.next_x := x_min - 1
							entity.stop_right
							if type2.item(1).is_equal('e') then
								attaquer_joueur(type2.item(7).out, a_timestamp)
							end
							if type2.is_equal ("cain") and clicked.is_equal ("deckard_cain") then
								action_cain
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('e') then
								attaquer_ennemi(type2.item(7).out, a_timestamp)
								clicked := ""
							elseif type2.is_equal (clicked) and type2.item(1).is_equal('l') then
								action_levier(type2.item(7).out)
								clicked := ""
							end
						end
					end
				end
			end
		end

	attaquer_joueur(a_i: STRING; a_timestamp: NATURAL_32)
		-- Un ennemi qui attaque le joueur
		local
			i: INTEGER
			int_timestamp: INTEGER
		do
			i := a_i.to_integer
			int_timestamp := a_timestamp.to_integer_32
			if (int_timestamp // 1000) - ennemies[i].last_hit > 0 then
				ennemies[i].last_hit := int_timestamp // 1000
				player.hp := player.hp - 1
			end
		end

	attaquer_ennemi(a_i: STRING; a_timestamp: NATURAL_32)
		-- le joueur attaque l'ennemi
		local
			i: INTEGER
		do
			i := a_i.to_integer

			if ennemies[i].hp > 3 then
				sound.son_epee
				ennemies[i].hp := ennemies[i].hp - 3
			else
				if ennemies[i].is_diablo then
					terminer_jeu(a_timestamp)
				elseif not ennemies.is_empty then
					ennemies.go_i_th (i)
					ennemies.remove
				end
			end

		end

	action_levier(a_i: STRING)
	 -- Action lorsque le levier est activé
		local
			i: INTEGER
		do
			i := a_i.to_integer
			if not levier[i].levier_ouvert then
				levier[i].levier_ouvert := True
				sound.son_levier
				if i = 1 then
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,120,450))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,200,380))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,150,400))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,70,550))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre3.png","monstre3_s.png",10,80,380))
				elseif i = 2 then
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,120,1825))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,200,1755))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,150,1775))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,70,1900))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre4.png","monstre4_s.png",10,80,1755))
				elseif i = 3 then
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,1080,450))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,1160,380))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,1110,400))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,1030,550))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre4.png","monstre4_s.png",10,1040,380))
				elseif i = 4 then
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,1080,1825))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,1160,1755))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre1.png","monstre1_s.png",5,1110,1775))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre2.png","monstre2_s.png",5,1030,1900))
					ennemies.extend(create {ENNEMY}.new_ennemy("monstre3.png","monstre3_s.png",10,1040,1755))
				end
				if levier[1].levier_ouvert and levier[2].levier_ouvert and levier[3].levier_ouvert and levier[4].levier_ouvert then
					background.door_open := True
					ennemies.extend(create {ENNEMY}.new_ennemy("diablo.png","diablo_s.png",200,550,100))
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

	on_mouse_down(a_timestamp: NATURAL_32; a_mouse_state: GAME_MOUSE_BUTTON_PRESSED_STATE; a_nb_clicks: NATURAL_8; a_window:GAME_WINDOW_SURFACED)
			--  Fait deplacer le player
		local
			i: INTEGER
		do
			clicked := ""

			from
				i := 1
			until
				i > ennemies.count
			loop
				if ennemies[i].is_selected then
					clicked := "ennemi" + i.out
				end
				i := i + 1
			end

			from
				i := 1
			until
				i > levier.count
			loop
				if levier[i].is_selected then
					clicked := "levier" + i.out
				end
				i := i + 1
			end

			if deckard_cain.is_selected then
				clicked := "deckard_cain"
			end

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

	on_mouse_motion (a_timestamp: NATURAL_32; a_mouse_state:GAME_MOUSE_MOTION_STATE; int1: INTEGER; int2: INTEGER)
		-- Événements lorsque la souris bouge dans l'écran
		local
			x_carte: INTEGER
			y_carte: INTEGER
			selection: BOOLEAN
			i: INTEGER
		do
			x_carte := (player.x + player.sub_image_width // 2) + (a_mouse_state.x - ecran.surface.width // 2)
			y_carte := (player.y + player.sub_image_height // 2) + (a_mouse_state.y - ecran.surface.height // 2)
			selection := False
			if background.current_map.is_equal ("village") then
				deckard_cain.is_selected := False

				if x_carte >= deckard_cain.x and x_carte <= deckard_cain.x + deckard_cain.sub_image_width and y_carte >= deckard_cain.y and y_carte <= deckard_cain.y + deckard_cain.sub_image_height then
					deckard_cain.is_selected := True
				end


			elseif background.current_map.is_equal ("dungeon") then
				if not ennemies.is_empty then
					from
						i := 1
					until
						i > ennemies.count
					loop
						ennemies[i].is_selected := False
						if x_carte >= ennemies[i].x and x_carte <= ennemies[i].x + ennemies[i].sub_image_width and y_carte >= ennemies[i].y and y_carte <= ennemies[i].y + ennemies[i].sub_image_height and not selection then
							ennemies[i].is_selected := True
							selection := True
						end
						i := i + 1
					end

				end

				if not levier.is_empty then
					from
						i:= 1
					until
						i > levier.count
					loop
						levier[i].is_selected := False
						if x_carte >= levier[i].x and x_carte <= levier[i].x + levier[i].lever_running_surface.width and y_carte >= levier[i].y and y_carte <= levier[i].y + levier[i].lever_running_surface.height and not selection then
							levier[i].is_selected := True
							selection := True
							if not levier[i].levier_ouvert then
								levier[i].lever_running_surface := levier[i].surface_levier_selectionner_fermer
							else
								levier[i].lever_running_surface := levier[i].surface_levier_selectionner_ouvert
							end
						else
							if not levier[i].levier_ouvert then
								levier[i].lever_running_surface := levier[i].surface_levier_fermer
							else
								levier[i].lever_running_surface := levier[i].surface_levier_ouvert
							end
						end
						i := i + 1
					end
				end
			end
		end

	terminer_jeu(a_timestamp: NATURAL_32)
	-- Fonction lorsque Diablo meurt
	-- envoie le temps au serveur
		local
			reseau: SERVER_POO
			temps: NATURAL_32
			temps_string: STRING
		do
			temps:= game_library.time_since_create // 1000
			temps_string:= temps.out
			create reseau.client (temps_string)
			on_quit(a_timestamp)
		end

	on_death(a_timestamp: NATURAL_32)
		-- Si le joueur meurt
		do
			if player.hp = 0 then
				on_quit(a_timestamp)
			end
		end

	on_quit(a_timestamp: NATURAL_32)
			-- Cette méthode sert à retourner au menu lorsque le x de la fenêtre est appuyé
		do
			game_library.stop
			sound.play_music ("beginning")
		end


end
