/// @description spawn players

var _player_layer = layer_get_id("Instances");

for (var _player = 0; _player < array_length(player_list); _player++){
	var _pos = grab_spawn_point(_player);
	var _inst = instance_create_layer(_pos.x,_pos.y,_player_layer,obj_Player,{
		steam_name		: player_list[_player].steam_name,
		steam_ID		: player_list[_player].steam_ID,
		lobby_member_ID : _player,
	});
	player_list[_player].character = _inst;
	player_list[_player].start_pos = _pos;
	if (player_list[_player].steam_ID == steam_ID) then character = _inst;
}