// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function send_player_sync(_steam_id){
	var _buff = buffer_create(1, buffer_grow, 1);
	buffer_write(_buff, buffer_u8, NETWORK_PACKETS.SYNC_PLAYERS);
	buffer_write(_buff, buffer_string, shrink_player_list());
	steam_net_packet_send(_steam_id, _buff);
	buffer_delete(_buff);
}

function send_player_spawn(_steam_id, _slot){
	var _pos = grab_spawn_point(_slot);
	var _buff = buffer_create(5, buffer_fixed, 1);
	buffer_write(_buff, buffer_u8, NETWORK_PACKETS.SPAWN_SELF);
	buffer_write(_buff, buffer_u16, _pos.x);
	buffer_write(_buff, buffer_u16, _pos.y);
	steam_net_packet_send(_steam_id,_buff);
	buffer_delete(_buff);
	server_player_spawn_at_pos(_steam_id,_pos);
	send_other_player_spawn(_steam_id, _pos);
}

function shrink_player_list(){
	var _shrunklist = player_list;
	for (var _i = 0; _i < array_length(_shrunklist); _i++)
	{
		_shrunklist[_i].character = undefined;	
	}
	return json_stringify(_shrunklist);
}

function server_player_spawn_at_pos(_steam_id, _pos){
	var _layer = layer_get_id("Instances");
	for (var _i = 0; _i < array_length(player_list); _i++){
		if player_list[_i].steam_ID == _steam_id{
			var _inst = instance_create_layer(_pos.x, _pos.y, _layer, obj_Player,{
				steam_name : player_list[_i].steam_name,
				steam_ID: _steam_id,
				lobby_member_ID: _i,
			});
		player_list[_i].character = _inst;	
		}	
	}
}

function send_other_player_spawn(_steam_id, _pos){
	var _buff = buffer_create(13, buffer_fixed, 1);
	buffer_write(_buff, buffer_u8, NETWORK_PACKETS.SPAWN_OTHER);
	buffer_write(_buff, buffer_u16, _pos.x);
	buffer_write(_buff, buffer_u16, _pos.y);
	buffer_write(_buff, buffer_u64, _steam_id);
	for (var _i = 0; _i < array_length(player_list); _i++){
		if player_list[_i].steam_ID != _steam_id {
			steam_net_packet_send(player_list[_i].steam_ID, _buff);	
		}
	}
	buffer_delete(_buff);
}