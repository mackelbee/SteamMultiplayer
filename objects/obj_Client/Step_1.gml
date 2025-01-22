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
		
		case NETWORK_PACKETS.SPAWN_OTHER:
			var _layer = layer_get_id("Instances");
			var _x	= buffer_read(inbuff, buffer_u16);
			var _y	= buffer_read(inbuff, buffer_u16);
			var _steamID = buffer_read(inbuff, buffer_u64);
			var _num = array_length(player_list);
			var _inst = instance_create_layer(_x, _y, _layer, obj_Player, {
				steam_name : steam_get_user_persona_name(_steamID),
				steam_ID : _steamID,
				lobby_member_ID : _num,
			})
			array_push(player_list,{
				steam_ID: _steamID,
				steam_name: steam_get_persona_name(_steamID),
				character: _inst,
				lobby_member_ID: _num,
				
			})
		break;
		
		case NETWORK_PACKETS.SPAWN_SELF:
			for (var _i = 0; _i < array_length(player_list); _i++)
			{
				if player_list[_i].steam_ID == steam_ID then lobby_member_ID = player_list[_i].lobby_member_ID;	
			}
			var _layer = layer_get_id("Instances");
			var _x	= buffer_read(inbuff, buffer_u16);
			var _y	= buffer_read(inbuff, buffer_u16);
			var _inst = instance_create_layer(_x, _y, _layer, obj_Player, {
				steam_name : steam_name,
				steam_ID : steam_ID,
				lobby_member_ID : lobby_member_ID,
			})
			
			player_list[0].character = _inst;
			character = _inst;
			
		break;
		
		case NETWORK_PACKETS.SERVER_PLAYER_INPUT:
			recieve_player_input(inbuff);
			break
			
		case NETWORK_PACKETS.PLAYER_POSITION:
			update_player_position(inbuff)
			break
		
		default:
			show_debug_message("unknown packet recieved");
		break;
	}
	
	
	
}