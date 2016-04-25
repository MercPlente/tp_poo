note
	description: "Classe gerant les images du programmes."
	author: "Marc Plante"
	date: "$2016-04-25$"
	revision: "$Revision$"

class
	IMAGE

inherit
	GAME_SURFACE
		rename
			make as make_surface
		end

create
	make

feature {NONE} -- Initialisation

	make (background:STRING)
	-- Fonction modifiant le fond d'ecran.
		local
			l_imageBackground: IMG_IMAGE_FILE
		do
			create l_imageBackground.make (background)
			if l_imageBackground.is_openable then
				l_imageBackground.open
				if l_imageBackground.is_open then
					make_from_image (l_imageBackground)
				else
					has_error := True
					make_surface(1,1)
				end
			else
				has_error := True
				make_surface(1,1)
			end
		end


feature {ANY}

	change_background(background:STRING;l_window:GAME_WINDOW_SURFACED)
	-- Utilisse "IMAGE" pour modifier le background
		local
			l_image:IMAGE
		do
			create l_image.make (background)
			game_library.iteration_actions.start
			if game_library.iteration_actions.writable then
				game_library.iteration_actions.remove
			end


			end

	on_iteration_background(a_timestamp:NATURAL_32; a_image:GAME_SURFACE; l_window:GAME_WINDOW_SURFACED)
			-- Evenement qui modifie le fond d'ecran a chaque iteration.
		do
			l_window.surface.draw_surface (a_image, 0, 0)
			l_window.update
		end

end
