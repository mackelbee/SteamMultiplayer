// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function grab_spawn_point(_player)
	{
		var _spawnpoint = instance_find(obj_SpawnPoint, _player);
		if _spawnpoint == noone return{x:0,y:0};
		return {x: _spawnpoint.x, y: _spawnpoint.y};
	}


///@self obj_client
function send_player_input(_input, _lobby_host){
	// Simplify the inputs
	var _x_input = (_input.rightKey - _input.leftKey);	
	var _y_input = (_input.downKey - _input.upKey);
	var _runKey  = _input._runKey;
	var _actionKey = _input.actionKey;
	// Create the buffer
	var _b = buffer_create(5, buffer_fixed, 1); // 1 + 1 + 1 + 1 + 1 = 5
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.CLIENT_PLAYER_INPUT);// 1 Identify what we're sending
	buffer_write(_b, buffer_s8, _x_input); // 1 Send x input
	buffer_write(_b, buffer_s8, _y_input);// 1 send y input
	buffer_write(_b, buffer_u8, _runKey); // 1 send run key pressed
	buffer_write(_b, buffer_u8, _actionKey); // 1 send action key pressed
	steam_net_packet_send(_lobby_host, _b); // Send the buffer to the lobby host
	buffer_delete(_b); // Delete buffer
}

///@description Player Input Packet Reading for SERVER/CLIENT
function recieve_player_input(_b, _steam_id=-1){
	if _steam_id == -1 then _steam_id = buffer_read(_b, buffer_u64);
	
	var _xInput = buffer_read(_b, buffer_s8);
	var _yInput = buffer_read(_b, buffer_s8);
	var _runKey = buffer_read(_b, buffer_u8);
	var _actionKey = buffer_read(_b, buffer_u8);
	var _player = find_player_by_steam_id(_steam_id);
	if _player == noone return;
	_player._xInput		= _xInput;
	_player._yInput		= _yInput;
	_player._runKey		= _runKey;
	_player._actionKey	= _actionKey;
	
	return {
		steam_ID: _steam_id,
		xInput: _xInput,
		yInput: _yInput,
		runKey: _runKey,
		actionKey: _actionKey
	}
}

///@description Finding Player object on client/server
function find_player_by_steam_id(_steam_id){
	
	for (var _i = 0; _i < array_length(player_list); _i++)
	{
		var _player = player_list[_i].character;
		if _player == undefined continue;
		if _player.steam_id == _steam_id return _player;
	}
	return noone;
}