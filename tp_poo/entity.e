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
	-- la surface lorsque l'on tourne a gauche
		do
			surface := right_surface
		end

	turn_right
	-- la surface lorsque l'on tourne a droite
		do
			surface := left_surface
		end

feature {NONE} -- constants

	left_surface:GAME_SURFACE
	-- La surface gauche de l'entite

	right_surface:GAME_SURFACE
	-- La surface droite de l'entite

	surface_width:INTEGER
	-- La largeur de la surface
		do
			Result := surface.width
		end

	surface_height:INTEGER
	-- La hauteur de la surface
		do
			Result := surface.height
		end

end
