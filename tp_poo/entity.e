note
	description: "Classe contenant l'information que n'importe quel personnage possede ."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

inherit
	ABSTRACT_ENTITY

feature {ANY}

	surface:GAME_SURFACE
			-- The surface to use when drawing `Current'

	turn_left
		do
			surface := right_surface
		end

	turn_right
		do
			surface := left_surface
		end

feature {NONE} -- constants

	left_surface:GAME_SURFACE

	right_surface:GAME_SURFACE

	surface_width:INTEGER
		do
			Result := surface.width
		end

	surface_height:INTEGER
		do
			Result := surface.height
		end

end
