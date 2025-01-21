/// @description Setup Player

localSteamID = steam_get_user_steam_id();
lobby_host = steam_lobby_get_owner_id();
is_host = steam_lobby_is_owner();

is_local = (localSteamID == steam_ID)
image_index = lobby_member_ID;


moveSpeed = 5
fireCooldown = 50
currentCooldown = 0

init_controls();