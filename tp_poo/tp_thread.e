note
	description: "Classe contenant les threads utilisable par le programme ."
	author: "Marc Plante, Jérémie Daem"
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
	-- Constructeur du thread et le démarre
		do
			make_thread
			must_stop:= false
			recu := false
			highscore := ""
		end

feature
	stop_thread
	-- Arrêter le thread
		do
			must_stop := true
		end

	highscore : STRING
	-- String contenant le highscore

	recu : BOOLEAN
	-- Bool pour savoir si le client a reçu une réponse du serveur

feature {NONE}
	execute
	-- l'execution du thread
		local
			serveur: SERVER_POO
		do
			create serveur.client("requete")
			serveur.reponse_recu := false
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
	-- Bool pour faire arrêter le thread


end
