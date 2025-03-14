extends Control

signal addressEntered(address)
signal hostWorldStart()
signal characterType(type)
signal startOfflineGame(num_players)

var host: bool
var type
var num_players = 0

#music stuff
var reverb = AudioEffectReverb.new()  # Create a new reverb effect

func _process(delta):
	if Input.is_action_just_pressed("test"):
		slow_music()

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

func _on_online_button_pressed():
	$MultiplayerScreen.show()
	$TitleScreen.hide()

func _on_offline_button_pressed():
	$TitleScreen.hide()
	$OfflineScreen.show()

func _on_online_back_button_pressed():
	$MultiplayerScreen/AddressEntry.clear()
	$MultiplayerScreen.hide()
	$TitleScreen.show()
	$MultiplayerScreen/AddressEntry.hide()
	$MultiplayerScreen/StartButton.hide()
	$MultiplayerScreen/AddressEntry.hide()

func _on_quit_button_pressed():
	get_tree().quit()

func _on_two_button_pressed():
	num_players = 2
	$OfflineScreen/OfflineStartButton.show()

func _on_three_button_pressed():
	num_players = 3
	$OfflineScreen/OfflineStartButton.show()

func _on_four_button_pressed():
	num_players = 4
	$OfflineScreen/OfflineStartButton.show()

func _on_offline_back_button_pressed():
	$OfflineScreen/OfflineStartButton.hide()
	num_players = 0
	$OfflineScreen.hide()
	$TitleScreen.show()

func _on_offline_start_button_pressed():
	emit_signal("startOfflineGame", num_players)
	emit_signal("characterType", type)

func slow_music(time = 3.0):
	$SlowMusicTimer.start(time)
	$MusicPlayer.pitch_scale = 0.5
	AudioServer.add_bus_effect(0,reverb)

func _on_slow_music_timer_timeout():
	$MusicPlayer.pitch_scale = 1.0
	AudioServer.remove_bus_effect(0,0)
