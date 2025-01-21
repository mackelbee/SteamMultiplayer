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
	//var _shrunklist = player_list;
	//for (var _i = 0; _i < array_length(_shrunklist); _i++)
	//{
	//	_shrunklist[_i].character = undefined;	
	//}
	return json_stringify(player_list);
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

///@self obj_Server
function send_player_input_to_clients(_player_input){
	if _player_input == undefined then return
	var _b = buffer_create(13, buffer_fixed, 1); //1+8+1+1+1+1
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.SERVER_PLAYER_INPUT);	// 1, Identify this buffer to the client
	buffer_write(_b, buffer_u64, _player_input.steam_ID);				// 8, This identifies the player responsible for this input
	buffer_write(_b, buffer_u8, _player_input.xInput);					// 1, X INPUT FOR PLAYER
	buffer_write(_b, buffer_u8, _player_input.yInput);					// 1, Y Input for PLAYER
	buffer_write(_b, buffer_u8, _player_input.runKey);					// 1, Run Input
	buffer_write(_b, buffer_u8, _player_input.actionKey);				// 1, action INPUT
	
	for (var _i = 0; _i < array_length(obj_Server.player_list); _i++)   // Check through player list
	{
		if (obj_Server.player_list[_i].steam_ID != obj_Server.steam_ID) // Find all clients
		{
			steam_net_packet_send(obj_Server.player_list[_i].steam_ID, _b);	// send packet to each client
		}
	}
	buffer_delete(_b); // delete taht buff
}

///@description Constantly update the clients on every player's position
///@self obj_Server
function send_player_positions(){
	for (var _i = 0; _i < array_length(player_list); _i++)				// GRAB ALL THE PLAYERS ON THE PLAYER LIST
	{
		var _player = player_list[_i];
		if _player.character == undefined then continue					// PREVENT ERRORS IF UNDEFINED // Happens when players first connect
		if _player.steam_ID == undefined then continue					// PREVENT ERRORS IF UNDEFINED // Likewise new players might not have this info, YET
		var _b = buffer_create(13, buffer_fixed, 1)						// 1+8+2+2 = 13
		buffer_write(_b, buffer_u8, NETWORK_PACKETS.PLAYER_POSITION);	// 1, IDENTIFY THIS BUFFER TO THE CLIENT
		buffer_write(_b, buffer_u64, _player.steam_ID);					// 8, SEND THE PLAYER ID
		buffer_write(_b, buffer_u16, _player.character.x)				// 2, X POSITION OF THE PAWN
		buffer_write(_b, buffer_u16, _player.character.y)				// 2, Y POSITION OF THE PAWN
		for (var _k = 0; _k < array_length(player_list); _k++)
		{
			if (player_list[_k].steam_ID != obj_Server.steam_ID)		// FIND THE CLIENTS
			{
				steam_net_packet_send(player_list[_k].steam_ID, _b);	// SEND TO THE CLIENTS
			}
		}
		buffer_delete(_b);												// DELETE BUFFER
	}
}

///@description Recieve buffers and update player position
///@self obj_Client
function update_player_position(_b){
	var _steam_id	= buffer_read(_b, buffer_u64);						// READ THE STEAM ID, THIS IS WHO WE WILL SYNC
	var _x			= buffer_read(_b, buffer_u16);						// THE X POSITION IS THE NEXT PART OF THE BUFFER
	var _y			= buffer_read(_b, buffer_u16);						// THE Y POSITION IS THE NEXT PART OF THE BUFFER
	
	for (var _i = 0; _i < array_length(player_list); _i++)				// GO THROUGH PLAYER LIST
	{
		if (_steam_id == player_list[_i].steam_ID)						// IF WE MATCH THE STEAM ID WITH SOMEONE ON THE LIST
		{
			if player_list[_i].character = undefined then continue		// PREVENT AN ERROR IF THEY DON'T HAVE A CHARACTER, YET
			player_list[_i].character.x = _x;							// SYNC X POSITION
			player_list[_i].character.y = _y;							// SYNC Y POSITION
		}
	}
}