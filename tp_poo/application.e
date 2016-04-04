note
	description : "Classe qui active les librairies de jeu et roule le jeu "
	author		: "Marc Plante, Insipire by Louis Marchand"
	date        : " "
	revision    : " "

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- Pour Utilliser `game_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utilliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utilliser `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialisation

	make
			-- Rouler l'application.
		local
			l_engine:detachable GAME_ENGINE
		do
			game_library.enable_video -- Active les fonctionnalitees video
			image_file_library.enable_image (true, false, false)
			audio_library.enable_sound
			create l_engine.make
			l_engine.run_game	  -- Roule la fonction "run_game".
			l_engine := Void
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end


end
