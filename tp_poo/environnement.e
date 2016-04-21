note
	description: "Summary description for {ENVIRONNEMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ENVIRONNEMENT

create
	make

feature {NONE} -- initialisation

	make(a_window: GAME_WINDOW_SURFACED; a_image: GAME_WINDOW_SURFACED)
		do
			window := a_window
			image := a_image
		end
feature -- disponible
	window: GAME_WINDOW_SURFACED
		-- fenetre de l'application

	image : GAME_WINDOW_SURFACED
		-- surface de l'application



end
