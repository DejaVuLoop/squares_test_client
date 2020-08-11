extends Node;

export var ip : String = "127.0.0.1";

enum Opcode {
	DISPATCH = 0,
	IDENTIFY = 1,
	HELLO = 2,
	RECONNECT = 3,
	DISCONNECT = 4
}

func init(ip: String):
	$WebsocketCommunicator.init(ip);

func connect_to_host(token, id) -> bool:
	$WebsocketCommunicator.connect_to_host(token, id)
	var result: String = yield($WebsocketCommunicator, "connection_result");
	
	match result:
		"SUCCESS":
			$WebsocketCommunicator.send_data(Opcode.IDENTIFY, {
				"t" : token,
				"i" : id
			});
			return true;
		_:
			return false;

func _ready():
	pass;
