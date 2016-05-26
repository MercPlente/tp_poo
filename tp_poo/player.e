note
	description: "Classe permettant de gerer le personnage du joueur dans l'application. Grandement inspirée de la classe 'Maryo' de Louis"
	author: "Marc Plante, Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	PLAYER

inherit
	ENTITY


create
	new_player

feature {ANY}

	new_player
			-- Initialization of `Current'
		local
			l_image:IMG_IMAGE_FILE
			l_image2:IMG_IMAGE_FILE
			l_image3:IMG_IMAGE_FILE
			l_image4:IMG_IMAGE_FILE
			l_image_barre:IMG_IMAGE_FILE
		do
			has_error := False
			create l_image.make ("kenny.png")
			create l_image2.make ("kenny_rotated.png")
			create l_image3.make ("kenny_diag_hautdroite.png")
			create l_image4.make ("kenny_diag_basdroite.png")
			create l_image_barre.make ("barre.png")
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create surface_up.make_from_image (l_image)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down.make_rotate(surface_up, 180, True)

					sub_image_width := surface_up.width // 3
					sub_image_height := surface_up.height
				else
					has_error := False
					create surface_up.make(1,1)
					surface_down := surface_up
				end
			else
				has_error := False
				create surface_up.make(1,1)
				surface_down := surface_up
			end

			if l_image2.is_openable then
				l_image2.open
				if l_image2.is_open then
					create surface_right.make_from_image (l_image2)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_left.make_rotate(surface_right, 180, True)
				else
					has_error := False
					create surface_right.make(1,1)
					surface_left := surface_right
				end
			else
				has_error := False
				create surface_right.make(1,1)
				surface_left := surface_right
			end

			if l_image3.is_openable then
				l_image3.open
				if l_image3.is_open then
					create surface_up_right.make_from_image (l_image3)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_down_left.make_rotate(surface_up_right, 180, True)
				else
					has_error := False
					create surface_up_right.make(1,1)
					surface_down_left := surface_up_right
				end
			else
				has_error := False
				create surface_up_right.make(1,1)
				surface_down_left := surface_up_right
			end

			if l_image4.is_openable then
				l_image4.open
				if l_image4.is_open then
					create surface_down_right.make_from_image (l_image4)
					create {GAME_SURFACE_ROTATE_ZOOM} surface_up_left.make_rotate(surface_down_right, 180, True)
				else
					has_error := False
					create surface_down_right.make(1,1)
					surface_up_left := surface_down_right
				end
			else
				has_error := False
				create surface_down_right.make(1,1)
				surface_up_left := surface_down_right
			end

			surface := surface_up
			initialize_animation_coordinate

			if l_image_barre.is_openable then
				l_image_barre.open
				if l_image_barre.is_open then
					create barre.make_from_image (l_image_barre)
				else
					has_error := False
					create barre.make(1,1)
				end
			else
				has_error := False
				create barre.make(1,1)
			end
		end

	barre: GAME_SURFACE
	-- Barre en bas qui montre ce qui est selectionné ainsi que la vie du joueur



	initialize_animation_coordinate
			-- Make de `animation_coordinates'
		do
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(4)
			animation_coordinates.extend ([surface.width // 3, 0])	-- Be sure to place the image standing still first
			animation_coordinates.extend ([0, 0])
			animation_coordinates.extend ([(surface.width // 3) * 2, 0])
			animation_coordinates.extend ([0, 0])
		end


end
