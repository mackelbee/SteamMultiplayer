// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function grab_spawn_point(_player)
	{
		var _spawnpoint = instance_find(obj_SpawnPoint, _player);
		if _spawnpoint == noone return{x:0,y:0};
		return {x: _spawnpoint.x, y: _spawnpoint.y};
	}