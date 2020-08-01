class_name RequestListener extends Node;

signal received_result(result_dict);

func _http_request_completed(_result, response_code, _headers, body):
	var result_struct: RequestResult = RequestResult.new();
	result_struct.body = parse_json(body.get_string_from_utf8());
	result_struct.code = response_code;
	emit_signal("received_result", result_struct);
