extends Node

func load_network_conf(osc_client: Node) -> void:
	var config = ConfigFile.new()
	config.load("user://settings.cfg")
	var saved_ip = config.get_value("network", "ip", "127.0.0.1")
	var saved_port = config.get_value("network", "port", 4646)
	osc_client.connect_socket(saved_ip, int(saved_port))
