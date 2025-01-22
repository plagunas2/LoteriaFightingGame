extends Control

signal addressEntered(address)
signal hostWorldStart()
signal characterType(type)

var host: bool
var type

#MultiplayerScreen
func _on_host_button_pressed():
	host = true
	$MultiplayerScreen/AddressEntry.hide()
	$MultiplayerScreen/StartButton.text = "START SERVER"
	$MultiplayerScreen/StartButton.show()

func _on_join_button_pressed():
	host = false
	$MultiplayerScreen/AddressEntry.show()
	$MultiplayerScreen/StartButton.text = "JOIN SERVER"
	$MultiplayerScreen/StartButton.show()

func _on_start_button_pressed():
	if not host:
		var address = $MultiplayerScreen/AddressEntry.text
		if address == "":
			address = "localhost"
		emit_signal("addressEntered", address)
	else:
		emit_signal("hostWorldStart")
	emit_signal("characterType", type)
