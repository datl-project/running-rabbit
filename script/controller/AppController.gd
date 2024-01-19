extends Node

var initialized: bool = false


## PROPERTY
#LOCAL DATA
var path_local : String:
	get:
		match OS.get_name():
			"Window": 	return "res://save/"
			"Android": 	return "user://"
			_ : 		return "res://save/"

# GOOGLE PLAY
var is_google_play_signin : bool = false
var google_play_leaderboard_id : String = "CgkIm8evpagMEAIQAw"

## SIGNAL
signal phone_back()
signal phone_resume()
signal phone_pause()

#GOOGLE PLAY
signal google_play_leader_board_loaded(list : Array)
signal google_play_player_score_loaded(score: int)
signal google_play_submit_score(value)
signal google_play_current_player_loaded(player_name)

## FUNCTION
func close_app():
	get_tree().quit()
	pass

func focus_out_app():
	pass
	
func show_leaderboard():
	GooglePlayController.show_leaderboard()
	pass

## IMPLEMENTED
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		close_app()
	elif what == NOTIFICATION_WM_GO_BACK_REQUEST :
		phone_back.emit()
	elif what == NOTIFICATION_APPLICATION_RESUMED:
		phone_resume.emit()
	elif what == NOTIFICATION_APPLICATION_PAUSED:
		phone_pause.emit()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT:
		focus_out_app()
		
func _ready():
	SettingsController.load_local_file	(path_local + "settings.json")
	initialized = true
	pass



