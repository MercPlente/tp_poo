note
	description: "Classe du coter client du serveur"
	author: "Marc Plante, J�r�mie Daem"
	date: "$Date$"
	revision: "$Revision$"

class
	SERVER_POO

create
	client

feature {ANY} -- Initialization

	client(message:STRING)
			-- Ex�cution du programme client
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
			l_port:INTEGER
			l_message:STRING
		do
			l_port:=1337
			create l_socket.make_targeted ("localhost", l_port)
			high_score := ""
			reponse_recu := FALSE
			l_message := message
			l_socket.put_integer (l_message.count)
			l_socket.put_string (l_message)
			l_socket.close
		end



	attendre_reponse
	--boucle pour attendre la r�ponse du serveur et changer le highscore
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
			l_port:INTEGER
			l_taille_message:INTEGER
			l_message:STRING
		do
			l_port:=1338
			create l_socket.make_bound (l_port)
			l_socket.read_integer
			l_taille_message:=l_socket.last_integer
			l_socket.read_stream (l_taille_message)
			l_message:=l_socket.last_string
			high_score := l_message
			reponse_recu := TRUE
			l_socket.close
		end





	high_score : STRING
	-- String contenant le highscore

	set_reponse_recu(bool:BOOLEAN)
	--change reponse_recu
	require
			is_bool_ok : bool = true or bool = false
	do
		reponse_recu := bool
	end

	reponse_recu : BOOLEAN assign set_reponse_recu
	-- Boolean pour savoir quand le serveur a r�pondu

end
