/// @description Load lobbies from steam

switch (async_load[?"event_type"])
{
	case "lobby_list":
	//reset lobbies
	if steam_lobby_list_get_count() == 0
	{
		lobby_list[0] = instance_create_depth(x, bbox_top + 40,-20,obj_LobbyItem);	
	}
	else
	{
			
	}
	
	break;
	
}