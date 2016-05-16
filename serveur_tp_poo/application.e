note
	description : "serveur_tp_poo application root class"
	date        : "$Date$"
	revision    : "$Revision$"

class
	APPLICATION

create
	serveur

feature {NONE} -- Initialization

	serveur
			-- Exécution du programme serveur
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
			l_port:INTEGER
			l_taille_message:INTEGER
			l_message:STRING
		do
			l_port:=1337
			create l_socket.make_bound (l_port)
			l_socket.read_integer
			l_taille_message:=l_socket.last_integer
			l_socket.read_stream (l_taille_message)
			l_message:=l_socket.last_string
			io.put_string (l_message)
			io.put_new_line
			if l_message = "requete" then
				renvoyer_high_score
			else
				high_score(l_message)
			end
			l_socket.close
		end


		high_score(message:STRING)
		-- prend le high score / le change s'il est meilleur
			do

			end

		renvoyer_high_score
		-- prend le high score et le renvoit dans le jeu s'il est plus grand
			local
				l_high_score : STRING
				l_socket: NETWORK_DATAGRAM_SOCKET
			do
				-- shit pour trouver le high score
				create l_socket.make_targeted ("localhost", 1337)
				create l_high_score.make_empty
				l_socket.put_integer (l_high_score.count)
				l_socket.put_string (l_high_score)
			end



--	client
--			-- Exécution du programme client
--		local
--			l_socket: NETWORK_DATAGRAM_SOCKET
--			l_port:INTEGER
--			l_host:STRING
--			l_message:STRING
--		do
--			l_port:=1337
--			l_host:="localhost"
--			l_message:="Bonjour serveur!%N"
--			create l_socket.make_targeted (l_host, l_port)
--			l_socket.put_integer (l_message.count)
--			l_socket.put_string (l_message)
--			l_socket.close
--		end


end
