note
	description: "Classe abstraite contenant les attributs / setter / iteration des entitées."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ABSTRACT_ENTITY

feature {ANY}

	update(a_timestamp:NATURAL_32)
		-- Rafraîchie la surface selon le `a_timestamp'
		-- Chaque 100 ms , l'image change; chaque 10 ms l'entité bouge (s'il y a déplacement)
		local
			l_coordinate:TUPLE[x,y:INTEGER]
			l_delta_time:NATURAL_32
			l_movement_time:INTEGER_32
		do
			if (next_x - x > -3 and next_x - x < 3) then
				if going_right then
					stop_right
				elseif going_left then
					stop_left
				end
			end

			if (next_y - y > -3 and next_y - y < 3) then
				if going_up then
					stop_up
				elseif going_down then
					stop_down
				end
			end

			if going_left or going_right or going_up or going_down then
				l_coordinate := animation_coordinates.at ((((a_timestamp // animation_delta) \\
												animation_coordinates.count.to_natural_32) + 1).to_integer_32)
				sub_image_x := l_coordinate.x
				sub_image_y := l_coordinate.y
				l_delta_time := a_timestamp - old_timestamp

				if l_delta_time // movement_delta > 0 then
					if going_right then
						turn_right
						l_movement_time := (l_delta_time // movement_delta).to_integer_32
						x := x + l_movement_time
					elseif going_left then
						turn_left
						x := x - (l_delta_time // movement_delta).to_integer_32
					end

					if going_up then
						turn_up
						y := y - (l_delta_time // movement_delta).to_integer_32
					elseif going_down then
						turn_down
						y := y + (l_delta_time // movement_delta).to_integer_32
					end
					if going_up and going_right then
						turn_up_right
					elseif going_up and going_left then
						turn_up_left
					elseif going_down and going_right then
						turn_down_right
					elseif going_down and going_left then
						turn_down_left
					end

					old_timestamp := old_timestamp + (l_delta_time // movement_delta) * movement_delta
				end
			end
		end

	surface_width:INTEGER
	-- La largeur de la surface
		deferred
		end

	surface_height:INTEGER
	-- La hauteur de la surface
		deferred
		end

	turn_up
	-- Fonction lorsqu'une entité tourne en haut
		deferred
		end

	turn_down
	-- Fonction lorsqu'une entité tourne en bas
		deferred
		end

	turn_left
	-- Fonction lorsqu'une entité tourne a gauche
		deferred
		end

	turn_right
	-- Fonction lorsqu'une entité tourne a droite
		deferred
		end

	turn_up_right
	-- Fonction lorsqu'une entité regarde en diagonale haut-droite
		deferred
		end
	turn_down_right
	-- Fonction lorsqu'une entité regarde en diagonale bas-droite
		deferred
		end
	turn_up_left
	-- Fonction lorsqu'une entité regarde en diagonale haut-gauche
		deferred
		end
	turn_down_left
	-- Fonction lorsqu'une entité regarde en diagonale bas-gauche
		deferred
		end

	going_left:BOOLEAN
			-- L'entité bouge a gauche

	going_right:BOOLEAN
			-- L'entité bouge a droite

	going_up:BOOLEAN
			-- L'entité bouge vers le haut

	going_down:BOOLEAN
			-- L'entité bouge vers le bas

	next_x:INTEGER assign set_next_x
			-- L'endroit où le joueur s'en va '(x)'

	next_y:INTEGER assign set_next_y
			-- L'endroit où le joueur s'en va '(y)'

	set_next_x(a_x:INTEGER)
		-- Assigne la valeur de `next_x' avec `a_x'
		require
			Is_x_ok: a_x >= 0
		do
			next_x := a_x
		ensure
			Is_Assign: next_x = a_x
		end

	set_next_y(a_y:INTEGER)
			-- Assigne la valeur de`next_y' avec `a_y'
		require
			Is_y_ok: a_y >= 0
		do
			next_y := a_y
		ensure
			Is_Assign: next_y = a_y
		end



	hp:INTEGER assign set_hp
		-- points de vie de l'entité

	x:INTEGER assign set_x
			-- Position horizontale de l'entité

	y:INTEGER assign set_y
			-- Position verticale de l'entité

	set_hp(a_hp:INTEGER)
			-- Assigne la valeur de `hp' avec `a_hp'
		require
			correct : a_hp >= 0
		do
			hp := a_hp
		ensure
			Is_ok: a_hp >= 0
			Is_Assign: hp = a_hp
		end

	set_x(a_x:INTEGER)
			-- Assigne la valeur de `x' avec `a_x'
		require
			correct : a_x >= 0
		do
			x := a_x
		ensure
			Is_ok: a_x >= 0
			Is_Assign: x = a_x
		end

	set_y(a_y:INTEGER)
			-- Assigne la valeur de `y' avec `a_y'
		require
			correct : a_y >= 0
		do
			y := a_y
		ensure
			Is_ok: y >= 0
			Is_Assign: y = a_y
		end

	sub_image_x, sub_image_y:INTEGER
			-- Position de la portion de l'image visible de `surface'

	sub_image_width, sub_image_height:INTEGER
			--Dimension de la portion de l'image visible de `surface'

	has_error:BOOLEAN
			-- S'il y a une erreur lors de la création de `surface'

	go_left(a_timestamp:NATURAL_32)
			-- Fait déplacer l'entité vers la gauche
		do
			old_timestamp := a_timestamp
			going_left := True
		end

	go_right(a_timestamp:NATURAL_32)
			-- Fait déplacer l'entité vers la droite
		do
			old_timestamp := a_timestamp
			going_right := True
		end

	stop_left
			-- Arrête le déplacement vers la gauche de l'entité
		do
			going_left := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
			end
		end

	stop_right
			-- Arrête le déplacement vers la droite de l'entité
		do
			going_right := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
			end
		end

	go_up(a_timestamp:NATURAL_32)
			-- Fait déplacer l'entité vers le haut
		do
			old_timestamp := a_timestamp
			going_up := True
		end

	go_down(a_timestamp:NATURAL_32)
			-- Arrête le déplacement vers le bas de l'entité
		do
			old_timestamp := a_timestamp
			going_down := True
		end

	stop_up
			-- Arrête le déplacement vers le haut de l'entité
		do
			going_up := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
			end
		end

	stop_down
			-- Arrête le déplacement vers la droite de l'entité
		do
			going_down := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x
				sub_image_y := animation_coordinates.first.y
			end
		end

	animation_coordinates:LIST[TUPLE[x,y:INTEGER]]
			-- Liste de toutes les parties de `surface'

	old_timestamp:NATURAL_32
			-- Le moment du dernier mouvement (considérant `movement_delta')

feature {NONE} -- Constante

	movement_delta:NATURAL_32 = 10
			-- Le temps delta de l'entité entre chaque mouvement

	animation_delta:NATURAL_32 = 100
			-- Le temps delta de l'entité entre chaque animation
end
