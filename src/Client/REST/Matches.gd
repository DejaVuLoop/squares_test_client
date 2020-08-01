extends Node;

var rc;
var authorization_token = "";


func _ready():
	rc = get_parent().get_node("RestCommunicator");

func set_body_of_result_to(result: RequestResult, index: String):
	if result.body.has(index):
		result.body = result.body[index];

#func is_authorization_loaded() -> bool: #offloading to external error handling
#	return (authorization_token == "");

func generate_headers_with_auth():
	return ["Content-Type: application/json", "Authorization: " + authorization_token];

func get_matches() -> RequestResult:
	var result : RequestResult = yield(rc.submit_request({
		"operation" : "/matches",
		"method" : HTTPClient.METHOD_GET,
		"custom_headers" : generate_headers_with_auth()
	}), "completed");
	
	set_body_of_result_to(result, "matches");
	return result;

func get_match(match_id: String) -> RequestResult:
	var result : RequestResult = yield(rc.submit_request({
		"operation" : "/matches/"+ match_id,
		"method" : HTTPClient.METHOD_GET,
		"custom_headers" : generate_headers_with_auth()
	}), "completed");
	
	set_body_of_result_to(result, "match");
	return result;

func get_random_match() -> RequestResult:
	var result : RequestResult = yield(rc.submit_request({
		"operation" : "/matches/@random",
		"method" : HTTPClient.METHOD_GET,
		"custom_headers" : generate_headers_with_auth()
	}), "completed");
	
	set_body_of_result_to(result, "match");
	return result;

func get_players(match_id: String) -> RequestResult:
	var result : RequestResult = yield(rc.submit_request({
		"operation" : "/matches/"+ match_id + "/players",
		"method" : HTTPClient.METHOD_GET,
		"custom_headers" : generate_headers_with_auth()
	}), "completed");
	
	set_body_of_result_to(result, "players");
	return result;

func new_match():
	var result : RequestResult = yield(rc.submit_request({
		"operation" : "/matches",
		"method" : HTTPClient.METHOD_PUT,
		"custom_headers" : generate_headers_with_auth()
	}), "completed");

	set_body_of_result_to(result, "match");
	return result;
