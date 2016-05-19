note
	description: "Classe permettant de creer et gerer les ennemies dans l'application."
	author: "Marc Plante"
	date: "$Date$"
	revision: "$Revision$"

class
	ENNEMY

inherit
	ENTITY

create
	new_ennemy

feature {NONE} -- Initialization

	new_ennemy(image:STRING;a_hp:INTEGER;a_x:INTEGER;a_y:INTEGER)
	-- Constructeur de la classe ENNEMY pour creer un nouvel ennemie
		local
			l_image:IMG_IMAGE_FILE
		do
			set_hp(a_hp)
			set_x(a_x)
			set_y(a_y)
			has_error := False
			create l_image.make (image)
			if l_image.is_openable then
				l_image.open
				if l_image.is_open then
					create right_surface.make_from_image (l_image)
					left_surface := right_surface
				else
					has_error := False
					create right_surface.make(1,1)
					left_surface := right_surface
				end
			else
				has_error := False
				create right_surface.make(1,1)
				left_surface := right_surface
			end
			surface := right_surface
			create {ARRAYED_LIST[TUPLE[x,y:INTEGER]]} animation_coordinates.make(0)
		end

end
