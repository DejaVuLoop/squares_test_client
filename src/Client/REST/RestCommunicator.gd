extends Node;

var base_rest_url: String;

var default_headers: PoolStringArray = ["Content-Type: application/json"];
var default_ssl_validate: bool = false;
var default_request_data: String = "";

func init(url: String):
	base_rest_url = url;
	print("initialized RestCommunicator for " + base_rest_url + "\n");
	

func catch_defaults_for_request(request_data: Dictionary) -> Dictionary:
	return {
		"operation" : request_data["operation"], #operation is required
		"custom_headers": (default_headers if not request_data.has('custom_headers') else request_data['custom_headers']),
		"ssl_validate_domain" : (default_ssl_validate if not request_data.has('ssl_validate_domain') else request_data['ssl_validate_domain']),
		"method" : request_data["method"], #method is required
		"data" : (default_request_data if not request_data.has('data') else request_data['data'])
	}

func submit_request(request_data: Dictionary):
	request_data = catch_defaults_for_request(request_data);
	
	var http_request = HTTPRequest.new();
	var listener = RequestListener.new();
	add_child(http_request);
	add_child(listener);
	
	http_request.connect("request_completed", listener, "_http_request_completed");
	
	var error = http_request.request(
		base_rest_url + request_data["operation"],
		request_data["custom_headers"],
		request_data["ssl_validate_domain"],
		request_data["method"],
		request_data["data"]
	);

	if error != OK:
		push_error("An error occurred in the HTTP request.");
	
	return yield(listener, "received_result");
