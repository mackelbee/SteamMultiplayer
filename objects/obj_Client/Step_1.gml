/// @description Insert description here
// You can write your code in this editor


// Recieving packets
while(steam_net_packet_receive())
{
	var _sender = steam_net_packet_get_sender_id();
	steam_net_packet_get_data(inbuff);
	buffer_seek(inbuff,buffer_seek_start,0);
	
	var _type = buffer_read(inbuff, buffer_u8);
	
	switch(_type)
	{
		case NETWORK_PACKETS.SYNC_PLAYERS:
			var _playerlist = buffer_read(inbuff, buffer_string);
			_playerlist = json_parse(_playerlist);
			sync_players(_playerlist);
		break;
		
	}
	
	
	
}