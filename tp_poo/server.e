note
	description: "Summary description for {SERVER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SERVER_POO

create
	client

feature {ANY} -- Initialization

	client(message:STRING)
			-- Ex�cution du programme serveur
		local
			l_socket: NETWORK_DATAGRAM_SOCKET
			l_port:INTEGER
			l_taille_message:INTEGER
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
	--boucle pour attendre la reponse
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
		end


--	serveur
--			-- Ex�cution du programme client
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


	high_score : STRING
	reponse_recu : BOOLEAN
end