extends Node;

signal connection_result(result_type);
signal disconnected(was_clean);
signal got_data(opcode, data);

var ws_url: String;
var token;
var id;

var ws_client: WebSocketClient = WebSocketClient.new();

func _ready():
	set_process(false);

func _process(delta):
	ws_client.poll();

func init(ip: String):
	ws_url = "ws://" + ip + ":8866";
	
	ws_client.connect("connection_closed", self, "_closed");
	ws_client.connect("connection_error", self, "_closed");
	ws_client.connect("connection_established", self, "_connected");
	ws_client.connect("data_received", self, "_data_received");

	print("initialized WebsocketCommunicator for " + ws_url + "\n");

func connect_to_host(t, i):
	set_process(true);
	var err = ws_client.connect_to_url(ws_url);
	if err != OK:
		set_process(false);
		emit_signal("connection_result", "FAILURE");

func send_data(opcode : int, data):
	data = {
		"o" : opcode,
		"d" : data,
	}
	ws_client.get_peer(1).put_packet(JSON.print(data).to_utf8());

func _connected(proto = ""):
	emit_signal("connection_result", "SUCCESS");

func _closed(was_clean : bool = false):
	emit_signal("disconnected", was_clean);

func _data_received():
	var data = JSON.parse(ws_client.get_peer(1).get_packet().get_string_from_utf8()).result;
	#print("got data: " + str(data));
	emit_signal("got_data", data.o, data.d);
