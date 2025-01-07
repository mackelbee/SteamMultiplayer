/// @description SERVER LISTENER
switch (async_load[? "event_type"])
{
	case "lobby_chat_update":
		var _from_id = async_load[?"user_id"]; //steam ID
		var _from_name = steam_get_user_persona_name_sync(_from_id); //Steam PLayer Name
		if (async_load[?"change_flags"] & steam_lobby_member_change_entered)
		{
			show_debug_message("Player Joined " + _from_name);
			var _slot = array_length(player_list);
			array_push(player_list,
				{
					steam_ID		: _from_id,
					steam_name		: _from_name,
					character		: undefined,
					start_pos		: grab_spawn_point(_slot),
					lobby_member_ID : _slot,
				});
				 send_player_sync(_from_id);
				 send_player_spawn(_from_id, _slot);
		}
	
	break;
	
	
}