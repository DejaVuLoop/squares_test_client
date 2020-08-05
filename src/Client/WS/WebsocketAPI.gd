extends Node

export var websocket_url = "ws://127.0.0.1:8866";

var _client = WebSocketClient.new()

func _ready():
	#set_process(false);
	_client.connect("connection_closed", self, "_closed");
	_client.connect("connection_error", self, "_closed");
	_client.connect("connection_established", self, "_connected");
	_client.connect("data_received", self, "_on_data");

	#var err = _client.connect_to_url(websocket_url);
	#if err != OK:
	#	print("Unable to connect")
	#	set_process(false)

func _closed(was_clean = false):
	print("Closed, clean: ", was_clean)
	set_process(false)

func _connected(proto = ""):
	print("Connected with protocol: ", proto)
	var payload = '{"o": 1, "d": {"t": "asdf", "i": "202.11"}}';
	_client.get_peer(1).put_packet(payload.to_utf8());

func _on_data():
	print("Got data from server: ", _client.get_peer(1).get_packet().get_string_from_utf8())

func _process(delta):
	pass;
	#_client.poll()