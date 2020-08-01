extends Node;

# The URL we will connect to

export var base_url : String = "127.0.0.1";
var websocket_url = "ws://" + base_url + ":8866"
var rest_url = "http://" + base_url + ":8865";

# Our WebSocketClient instance
var _client = WebSocketClient.new()
var http_request = HTTPRequest.new()

func _ready():
	print("setting up connections for rest")
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")
	
	var query = JSON.print({"username":"david"})
	
	# Add 'Content-Type' header:
	var headers = ["Content-Type: application/json"]
	
	var error = http_request.request(
		rest_url + "/login",
		headers, 
		false,
		HTTPClient.METHOD_POST,
		query
	)
	
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
	#print("setting up connections for ws")
	#_client.connect("connection_closed", self, "_closed")
	#_client.connect("connection_error", self, "_closed")
	#_client.connect("connection_established", self, "_connected")
	
	#_client.connect("data_received", self, "_on_data")

	#var err = _client.connect_to_url(websocket_url)
	#if err != OK:
	#	print("Unable to connect")
	#	set_process(false)

#func _closed(was_clean = false):
#	print("Closed, clean: ", was_clean)
#	set_process(false)

#func _connected(proto = ""):

#	print("Connected with protocol: ", proto)
#	var test_json = '{"o": 0, "d": {"e": "USER_JOIN", "i": "222.342424", "u": "Ollie"}}'
#	_client.get_peer(1).put_packet(test_json.to_utf8())

#func _on_data():
#	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _http_request_completed(result, response_code, headers, body):
    var response = parse_json(body.get_string_from_utf8())

    # Will print the user agent string used by the HTTPRequest node (as recognized by httpbin.org).
    print(body.get_string_from_utf8())

func _process(delta):
	pass
	#_client.poll()