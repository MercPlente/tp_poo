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

	turn_up
	-- la surface lorsque l'on tourne en haut
		do
			surface := surface_up
		end

	turn_down
	-- la surface lorsque l'on tourne en bas
		do
			surface := surface_down
		end

	turn_left
	-- la surface lorsque l'on tourne a gauche
		do
			surface := surface_left
		end

	turn_right
	-- la surface lorsque l'on tourne a droite
		do
			surface := surface_right
		end

feature {NONE} -- constants

	surface_up:GAME_SURFACE
	-- La surface de l'entite qui regarde vers le haut

	surface_down:GAME_SURFACE
	-- La surface de l'entite qui regarde vers le bas

	surface_right: GAME_SURFACE
	-- -- La surface de l'entite qui regarde vers la droite

	surface_left: GAME_SURFACE
	-- -- La surface de l'entite qui regarde vers la gauche

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
