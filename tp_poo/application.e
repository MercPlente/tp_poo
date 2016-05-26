note
	description : "Classe qui active les librairies de jeu et roule le jeu "
	author		: "Marc Plante, Insipire by Louis Marchand"
	date        : " "
	revision    : " "

class
	APPLICATION

inherit
	GAME_LIBRARY_SHARED		-- Pour Utiliser `game_library'
	TEXT_LIBRARY_SHARED		-- Pour Utiliser `text_library'
	AUDIO_LIBRARY_SHARED	-- Pour Utiliser `audio_library'
	IMG_LIBRARY_SHARED		-- Pour Utiliser `image_file_library'
	EXCEPTIONS

create
	make

feature {NONE} -- Initialisation

	make
			-- Rouler l'application.
		local
			l_menu:detachable MENU_DEPART
		do
			game_library.enable_video -- Active les fonctionnalitees video
			text_library.enable_text	-- Pour �crire du texte
			image_file_library.enable_image (true, false, false)
			audio_library.enable_sound
			create l_menu.make
			l_menu := Void
			audio_library.quit_library
			image_file_library.quit_library
			game_library.quit_library
		end

end
