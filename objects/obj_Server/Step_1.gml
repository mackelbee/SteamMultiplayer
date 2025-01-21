/// @description listening for activity as server

// recieving packets

while(steam_net_packet_receive()){
	var _sender = steam_net_packet_get_sender_id();
	steam_net_packet_get_data(inbuff);
	buffer_seek(inbuff,buffer_seek_start,0);
	var _type = buffer_read(inbuff, buffer_u8);
	
	switch(_type)
	{
		case NETWORK_PACKETS.CLIENT_PLAYER_INPUT:
			var _player_input = recieve_player_input(inbuff, _sender);
			send_player_input_to_clients(_player_input);
			break
		
		default:
			show_debug_message("unknown packet recieved" + string(_type));
			break
	}
}