note
	description: "Classe permettant de creer et gerer les ennemies dans l'application."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	ENNEMY

inherit
	ENTITY
	SELECTABLE

create
	new_ennemy

feature {NONE} -- Initialization

	new_ennemy(image:STRING;a_hp:INTEGER;a_x:INTEGER;a_y:INTEGER)
	-- Constructeur de la classe ENNEMY pour creer un nouvel ennemie
		local
			l_image:IMG_IMAGE_FILE
			l_image_s:IMG_IMAGE_FILE
		do
			set_hp(a_hp)
			set_x(a_x)
			set_y(a_y)
			make_selection
			has_error := False
			create l_image.make (image)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create surface_up.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down.make_rotate(surface_up, 180, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_right.make_rotate(surface_up, 90, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_left.make_rotate(surface_up, 270, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_right.make_rotate(surface_up, 135, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_left.make_rotate(surface_up, 225, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_right.make_rotate(surface_up, 45, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_left.make_rotate(surface_up, 315, True)

					sub_image_width := surface_up.width
					sub_image_height := surface_up.height
				else
					has_error := False
					create surface_up.make(1,1)
					surface_down := surface_up
					surface_right := surface_up
					surface_left := surface_up
					surface_up_right := surface_up
					surface_up_left := surface_up
					surface_down_right := surface_up
					surface_down_left := surface_up
				end
			else
				has_error := False
				create surface_up.make(1,1)
				surface_down := surface_up
				surface_right := surface_up
				surface_left := surface_up
				surface_up_right := surface_up
				surface_up_left := surface_up
				surface_down_right := surface_up
				surface_down_left := surface_up
			end
			surface := surface_up
			initialize_animation_coordinate

		create l_image_s.make ("deckard_cain_s.png")
			if l_image_s.is_openable then
				l_image_s.open
				if l_image_s.is_open then
					create surface_up_s.make_from_image (l_image_s)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_right_s.make_rotate(surface_up_s, 315, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_right_s.make_rotate(surface_up_s, 270, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_right_s.make_rotate(surface_up_s, 225, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_s.make_rotate(surface_up_s, 180, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_left_s.make_rotate(surface_up_s, 135, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_left_s.make_rotate(surface_up_s, 90, True)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_left_s.make_rotate(surface_up_s, 45, True)
				else
					has_error := False
					create surface_up_s.make(1,1)
					surface_down_s := surface_up_s
					surface_right_s := surface_up_s
					surface_left_s := surface_up_s
					surface_up_right_s := surface_up_s
					surface_up_left_s := surface_up_s
					surface_down_right_s := surface_up_s
					surface_down_left_s := surface_up_s
				end
			else
				has_error := False
				create surface_up_s.make(1,1)
				surface_down_s := surface_up_s
				surface_right_s := surface_up_s
				surface_left_s := surface_up_s
				surface_up_right_s := surface_up_s
				surface_up_left_s := surface_up_s
				surface_down_right_s := surface_up_s
				surface_down_left_s := surface_up_s
			end

			surface := surface_up
			initialize_animation_coordinate
		end


	turn_up_s
	-- la surface lorsqu'on va vers le haut
		do
			surface := surface_up_s
		end

	turn_down_s
	-- la surface lorsqu'on va vers le bas
		do
			surface := surface_down_s
		end

	turn_left_s
	-- la surface lorsqu'on va vers la gauche
		do
			surface := surface_left_s
		end

	turn_right_s
	-- la surface lorsqu'on va vers la droite
		do
			surface := surface_right_s
		end

	turn_up_right_s
	-- la surface lorsqu'on va vers la diagonale haut-droite
		do
			surface := surface_up_right_s
		end

	turn_down_right_s
	-- la surface lorsqu'on va vers la diagonale bas-droite
		do
			surface := surface_down_right_s
		end

	turn_up_left_s
	-- la surface lorsqu'on va vers la diagonale haut-gauche
		do
			surface := surface_up_left_s
		end

	turn_down_left_s
	-- la surface lorsqu'on va vers la diagonale bas-gauche
		do
			surface := surface_down_left_s
		end

	surface_up_s:GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers le haut

	surface_down_s:GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers le bas

	surface_right_s: GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers la droite

	surface_left_s: GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers la gauche

	surface_up_right_s:GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers le haut

	surface_down_right_s:GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers le bas

	surface_up_left_s: GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers la droite

	surface_down_left_s: GAME_SURFACE
	-- La surface selectionnée de l'entite qui regarde vers la gauche


	initialize_animation_coordinate
			-- Create the `animation_coordinates'
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface.width // 3, 0])	-- Be sure to place the image standing still first
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface.width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
		end

end
