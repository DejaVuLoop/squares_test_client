extends Node;

signal connection_failed;
signal connection_successful;

var ws_url: String;
var token;
var id;

var ws_client: WebSocketClient = WebSocketClient.new();


func _ready():
	set_process(false);

func init(url: String):
	ws_url = url;
	print("initialized WebsocketCommunicator for " + ws_url + "\n");

func connect_to_host(t, i):
	print("connecting");
	token = t;
	id = i;
	
	ws_client.connect("connection_closed", self, "_closed");
	ws_client.connect("connection_error", self, "_closed");
	ws_client.connect("connection_established", self, "_connected");
	ws_client.connect("data_received", self, "_on_data");
	
	set_process(true);
	var err = ws_client.connect_to_url(ws_url);
	if err != OK:
		print("failed");
		set_process(false);
		emit_signal("connection_failed");
		return;

func _connected(proto = ""):
	var payload = {
		"o" : 1,
		"d" : 
			{
				"t" : token,
				"i" : id
			}
	};
	emit_signal("connected_successfully");
	ws_client.get_peer(1).put_packet(JSON.print(payload).to_utf8());

func _closed(was_clean = false):
	pass;

func _on_data():
	print("got response");
	pass;

func _process(delta):
	ws_client.poll();