note
	description : "Classe pour demarrer le serveur et attendre une reponse"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	serveur

feature {NONE} -- Initialization

	serveur
			-- Ex�cution du programme serveur
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
			l_port:INTEGER
			l_taille_message:INTEGER
			l_message:STRING
			continuer : BOOLEAN
		do
			continuer := true
			l_port:=1337
			create l_socket.make_bound (l_port)
			from
			until
				continuer = false
			loop
				l_socket.read_integer
				l_taille_message:=l_socket.last_integer
				l_socket.read_stream (l_taille_message)
				l_message:=l_socket.last_string

				if l_message ~ "requete" then
					renvoyer_highscore
				else
					highscore(l_message)
				end
			end


			l_socket.close
		end


		highscore(message:STRING)
		-- prend le high score / le change s'il est meilleur
			local
				l_highscore_file: PLAIN_TEXT_FILE
				l_score: NATURAL_32
				l_highscore: NATURAL_32

			do
				l_score := message.to_natural_32


				create l_highscore_file.make_open_read_write ("highscore.txt")
				l_highscore_file.read_stream (l_highscore_file.count)
				l_highscore := l_highscore_file.last_string.twin.to_natural_32
				l_highscore_file.close

				if l_score < l_highscore then
					l_highscore_file.make_open_write ("highscore.txt")
					l_highscore_file.put_string (message)
					l_highscore_file.close
				end

			end

		renvoyer_highscore
		-- prend le high score et le renvoit dans le jeu s'il est plus grand
			local
				l_highscore : STRING
				l_socket: NETWORK_DATAGRAM_SOCKET
				l_highscore_file: PLAIN_TEXT_FILE
			do
				create l_highscore_file.make_open_read_write ("highscore.txt")
				l_highscore_file.read_stream (l_highscore_file.count)
				l_highscore := l_highscore_file.last_string.twin
				l_highscore_file.close

				create l_socket.make_targeted ("localhost", 1338)
				l_socket.put_integer (l_highscore.count)
				l_socket.put_string (l_highscore)
			end


end
