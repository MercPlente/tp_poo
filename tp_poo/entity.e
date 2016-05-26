note
	description: "Classe contenant l'information que n'importe quel personnage possede ."
	author: "Marc Plante,Jérémie Daem"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	ENTITY

inherit
	ABSTRACT_ENTITY

feature {ANY}

	surface:GAME_SURFACE
			-- La surface lorsque l'on dessine l'entité

	turn_up
	-- la surface lorsqu'on va vers le haut
		do
			surface := surface_up
		end

	turn_down
	-- la surface lorsqu'on va vers le bas
		do
			surface := surface_down
		end

	turn_left
	-- la surface lorsqu'on va vers la gauche
		do
			surface := surface_left
		end

	turn_right
	-- la surface lorsqu'on va vers la droite
		do
			surface := surface_right
		end

	turn_up_right
	-- la surface lorsqu'on va vers la diagonale haut-droite
		do
			surface := surface_up_right
		end

	turn_down_right
	-- la surface lorsqu'on va vers la diagonale bas-droite
		do
			surface := surface_down_right
		end

	turn_up_left
	-- la surface lorsqu'on va vers la diagonale haut-gauche
		do
			surface := surface_up_left
		end

	turn_down_left
	-- la surface lorsqu'on va vers la diagonale bas-gauche
		do
			surface := surface_down_left
		end


feature {NONE} -- constants

	surface_up:GAME_SURFACE
	-- La surface de l'entité qui regarde vers le haut

	surface_down:GAME_SURFACE
	-- La surface de l'entité qui regarde vers le bas

	surface_right: GAME_SURFACE
	-- -- La surface de l'entité qui regarde vers la droite

	surface_left: GAME_SURFACE
	-- -- La surface de l'entité qui regarde vers la gauche

	surface_up_right:GAME_SURFACE
	-- La surface de l'entité qui regarde vers le haut

	surface_down_right:GAME_SURFACE
	-- La surface de l'entité qui regarde vers le bas

	surface_up_left: GAME_SURFACE
	-- -- La surface de l'entité qui regarde vers la droite

	surface_down_left: GAME_SURFACE
	-- -- La surface de l'entité qui regarde vers la gauche

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
