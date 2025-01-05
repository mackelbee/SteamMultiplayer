/// @description Setup lobby_list

lobby_list = []

image_xscale = xScale;
image_yscale = yScale;

lobby_list[0] = instance_create_depth(x, bbox_top + 40,-20,obj_LobbyItem);

steam_lobby_list_add_string_filter("IsGameMakerTest","true",steam_lobby_list_filter_eq);
steam_lobby_list_request();