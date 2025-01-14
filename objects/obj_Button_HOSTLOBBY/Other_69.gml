/// @description Listening for Lobby Creation

switch (async_load[?"event_type"])
{
	case "lobby_created":
	show_debug_message("Lobby Created: " + string(steam_lobby_get_lobby_id()));
	show_debug_message("try to join");
	steam_lobby_join_id(steam_lobby_get_lobby_id());
	
	break
	
	case "lobby_joined":
	if (steam_lobby_is_owner())
	{
		show_debug_message("lobby joined");
		steam_lobby_set_data("isGameMakerTest", "true" );
		steam_lobby_set_data("Creator", steam_get_persona_name());
	}
		//var b = buffer_create(16, buffer_fixed, 1);
		//	buffer_write(b, buffer_u8, test_network_packet.ping);
		//	show_debug_message("Initial ping:" + string(steam_net_packet_send(steam_lobby_get_owner_id(), b)));
		//	buffer_delete(b);
	room_goto(rm_GameRoom);
	
	break
}