extends Node;

export var base_url : String = "127.0.0.1";
var rest_url : String = "http://" + base_url + ":8865";
var logged_in: bool = false;

var token: String;
var id;

func login_and_return_code() -> int:
	var login_result: RequestResult = yield(
		$RestCommunicator.submit_request({
			"operation" : "/login?username=david",
			"method" : HTTPClient.METHOD_POST
		}), "completed");
	
	match (login_result.code):
		200:
			token = login_result.body["token"];
			id = login_result.body["id"];
			$Matches.authorization_token = token;
			logged_in = true;
		_: 
			printerr("could not log in. Error code: " + str(login_result.code));
	
	return login_result.code;


func test_run():
	#INIT
	$RestCommunicator.init(rest_url);
	
	#LOGIN
	print("Login request sent.")
	var login_code = yield(login_and_return_code(), "completed");
	
	if login_code == 200:
		print("Successfully logged in.\n");
	else:
		return;
	
	# NEW MATCH
	print("creating a new match.");
	var new_match = yield($Matches.new_match(), "completed").body;
	print("Match created:\n\t" + str(new_match) + "\n");
	
	# GET MATCHES
	print("Fetching a list of all matches.");
	var matches = yield($Matches.get_matches(), "completed").body;
	print("Found " + str(len(matches)) + ":");
	
	for _match in matches:
		print("\t" + str(_match));
	print(" ");
	
	# GET MATCH
	var target_match_id = "OOPS";
	print("looking for a match of id '" + target_match_id + "'");
	var query_result: RequestResult = yield($Matches.get_match(target_match_id), "completed");
	
	match(query_result.code):
		200:
			print("Match found: \n\t" + str(query_result.body));
		404:
			print("No match with id '" + target_match_id + "' was found; Eror code: 404.");
		_:
			printerr("Issue finding the match. Error code: " + str(query_result.code));
	print(" ");
	
	# GET RANDOM MATCH
	print("Finding a random match.");
	var random_match_result: RequestResult = yield($Matches.get_random_match(), "completed");
	
	match(random_match_result.code):
		200:
			print("Match found: \n\t" + str(random_match_result.body));
		503:
			print("Could not find a random match because there are no matches; Eror code: 503.");
		_:
			printerr("Issue finding a random match. Error code: " + str(random_match_result.code));
	print(" ");
	
	# GET PLAYERS FROM MATCH
	var target_match = new_match["id"];
	print("Finding the players from match id '" + target_match + "'.");
	var players_result: RequestResult = yield($Matches.get_players(target_match), "completed");
	
	match(players_result.code):
		200:
			print("Players found: \n\t" + str(players_result.body));
		404:
			print("Could not find the players because the match does not exist; Eror code: 404.");
		_:
			printerr("Issue finding players from the match. Error code: " + str(players_result.code));
	print(" ");
	
func _ready():
	pass;
	#test_run();
