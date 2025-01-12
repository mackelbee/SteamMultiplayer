// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function sync_players(_new_list){
	var _steamIDs = [];
	for (var _i = 0; _i < array_length(player_list); _i++)
		{
			array_push(_steamIDs, player_list[_i].steam_ID);	
		}
	for (var _i = 0; _i < array_length(_new_list); _i++)
		{
			var _new_steam_ID = _new_list[_i].steam_ID;
			if !array_contains(_steamIDs,_new_steam_ID)
			{
				var _inst = client_player_spawn_at_pos(_new_list[_i])
				_new_list[_i].character = _inst;
				array_push(player_list, _new_list[_i]);
			}
			else
			{
				for (var _k = 0; _k < array_length(player_list); _k++)
				{
					if (player_list[_k].steam_ID == _new_steam_ID)
					{
						player_list[_k].start_pos = _new_list[_i].start_pos;
						player_list[_k].lobby_member_ID = _new_list[_i].lobby_member_ID;
						if player_list[_k].character == undefined && player_list[_k].steam_ID != _new_steam_ID
						{
							var _inst = client_player_spawn_at_pos(player_list[_k]);
							player_list[_k].character = _inst;
						}
					}
				}
			}
		}
}

function client_player_spawn_at_pos(_player_info){
	var _layer = layer_get_id("Instances");
	var _name	= _player_info.steam_name;
	var _steamID = _player_info.steam_ID;
	var _num = _player_info.lobby_member_ID;
	var _loc = _player_info.start_pos;
	var _inst = instance_create_layer(_loc.x, _loc.y, _layer, obj_Player, {
		steam_name : _name,
		steam_ID	: _steamID,
		lobby_member_ID : _num
		
	});
	return _inst;
}