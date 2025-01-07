/// @description Init Client Variables

player_list = [];

steam_ID = steam_get_user_steam_id();
steam_name = steam_get_persona_name();

lobby_member_ID = undefined;
character = undefined;

inbuff = buffer_create(16, buffer_grow, 1);

player_list[0] = {
	steam_ID		: steam_ID,
	steam_name		: steam_name,
	character		: undefined,
	start_pos		: grab_spawn_point(0),
	lobby_member_ID : undefined,
	
};