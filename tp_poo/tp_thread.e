note
	description: "Classe contenant les threads utilisable par le programme ."
	author: "Marc Plante"
	date: "$2016-04-22$"
	revision: "$Revision$"

class
	TP_THREAD

inherit
	GAME_LIBRARY_SHARED
	THREAD
	rename
		make as make_thread
	end
create
	make
feature {NONE}
	make
		do
			make_thread
			must_stop:= false
			recu := false
			highscore := ""
		end

feature
	stop_thread
		do
			must_stop := true
		end

	highscore : STRING
	recu : BOOLEAN

feature {NONE}
	execute

		local
			serveur: SERVER_POO
			--temps: NATURAL_32
			--temps_string: STRING
		do
			--temps:= game_library.time_since_create
			--temps_string:= temps.out
			create serveur.client("requete")
			from
			until
				serveur.reponse_recu = true
			loop
				serveur.attendre_reponse
			end
			stop_thread
			highscore := serveur.high_score
			recu := true

		end

feature {NONE}
	must_stop: BOOLEAN


end
