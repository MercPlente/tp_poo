note
	description: "Classe abstraite contenant les attribues / setter / iteration des entit�es."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ABSTRACT_ENTITY

feature {ANY}

	update(a_timestamp:NATURAL_32)
			-- Update the surface depending on the present `a_timestamp'.
			-- Each 100 ms, the image change; each 10ms `Current' is moving
		local
			l_coordinate:TUPLE[x,y:INTEGER]
			l_delta_time:NATURAL_32
			l_movement_time:INTEGER_32
		do
			if (next_x - (x + (surface_width // 6)) > -3 and next_x - (x + (surface_width // 6)) < 3) then
				if going_right then
					stop_right
				elseif going_left then
					stop_left
				end
			end

			if (next_y - (y + (surface_height // 2)) > -3 and next_y - (y + (surface_height // 2)) < 3) then
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
	-- Fonction lorsqu'une entit� tourne en haut
		deferred
		end

	turn_down
	-- Fonction lorsqu'une entit� tourne en bas
		deferred
		end

	turn_left
	-- Fonction lorsqu'une entit� tourne a gauche
		deferred
		end

	turn_right
	-- Fonction lorsqu'une entit� tourne a droite
		deferred
		end

	going_left:BOOLEAN
			-- Is `Current' moving left

	going_right:BOOLEAN
			-- Is `Current' moving right

	going_up:BOOLEAN
			-- Is `Current' moving up

	going_down:BOOLEAN
			-- Is `Current' moving down

	next_x:INTEGER assign set_next_x
			-- Where Player is going (x)

	next_y:INTEGER assign set_next_y
			-- Where Player is going (y)

	set_next_x(a_x:INTEGER)
			-- Assign the value of `next_x' with `a_x'
		require
			Is_x_ok: a_x >= 0
		do
			next_x := a_x
		ensure
			Is_Assign: next_x = a_x
		end

	set_next_y(a_y:INTEGER)
			-- Assign the value of `next_y' with `a_y'
		require
			Is_y_ok: a_y >= 0
		do
			next_y := a_y
		ensure
			Is_Assign: next_y = a_y
		end



	hp:INTEGER assign set_hp
		-- hit point de l'entite

	x:INTEGER assign set_x
			-- Vertical position of `Current'

	y:INTEGER assign set_y
			-- Horizontal position of `Current'

	set_hp(a_hp:INTEGER)
			-- Assign the value of `hp' with `a_hp'
		require
			correct : a_hp >= 0
		do
			hp := a_hp
		ensure
			Is_ok: a_hp >= 0
			Is_Assign: hp = a_hp
		end

	set_x(a_x:INTEGER)
			-- Assign the value of `x' with `a_x'
		require
			correct : a_x >= 0
		do
			x := a_x
		ensure
			Is_ok: a_x >= 0
			Is_Assign: x = a_x
		end

	set_y(a_y:INTEGER)
			-- Assign the value of `y' with `a_y'
		require
			correct : a_y >= 0
		do
			y := a_y
		ensure
			Is_ok: y >= 0
			Is_Assign: y = a_y
		end

	sub_image_x, sub_image_y:INTEGER
			-- Position of the portion of image to show inside `surface'

	sub_image_width, sub_image_height:INTEGER
			-- Dimension of the portion of image to show inside `surface'

	has_error:BOOLEAN
			-- Is an error happen when initializing the `surface'

	go_left(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move left
		do
			old_timestamp := a_timestamp
			going_left := True
		end

	go_right(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move right
		do
			old_timestamp := a_timestamp
			going_right := True
		end

	stop_left
			-- Make `Current' stop moving to the left
		do
			going_left := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
			end
		end

	stop_right
			-- Make `Current' stop moving to the right
		do
			going_right := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
			end
		end

	go_up(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move left
		do
			old_timestamp := a_timestamp
			going_up := True
		end

	go_down(a_timestamp:NATURAL_32)
			-- Make `Current' starting to move right
		do
			old_timestamp := a_timestamp
			going_down := True
		end

	stop_up
			-- Make `Current' stop moving to the left
		do
			going_up := False
			if not going_right then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
			end
		end

	stop_down
			-- Make `Current' stop moving to the right
		do
			going_down := False
			if not going_left then
				sub_image_x := animation_coordinates.first.x	-- Place the image standing still
				sub_image_y := animation_coordinates.first.y	-- Place the image standing still
			end
		end

	animation_coordinates:LIST[TUPLE[x,y:INTEGER]]
			-- Every coordinate of portion of images in `surface'

	old_timestamp:NATURAL_32
			-- When appen the last movement (considering `movement_delta')

feature {NONE} -- constants

	movement_delta:NATURAL_32 = 10
			-- The delta time between each movement of `Current'

	animation_delta:NATURAL_32 = 100
			-- The delta time between each animation of `Current'
end
