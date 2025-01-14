/// @description Insert description here
// You can write your code in this editor
alarm[0] = 500;

//steam_lobby_list_add_distance_filter(steam_lobby_list_distance_filter_far);
steam_lobby_list_add_string_filter("isGameMakerTest", "true" ,steam_lobby_list_filter_eq);
steam_lobby_list_request();