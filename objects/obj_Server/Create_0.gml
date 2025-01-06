/// @description Init Server Variables

player_list = [];

steam_ID = steam_get_user_steam_id();
steam_name = steam_get_persona_name();

character = undefined;


player_list[0] = {
	steam_ID		: steam_ID,
	steam_name		: steam_name,
	character		: undefined,
	start_pos		: grab_spawn_point(0),
	lobby_member_ID : 0,
	
};