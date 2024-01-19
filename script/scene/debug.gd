extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_show_leaderboard_pressed():
	AppController.show_leaderboard()
	
func _on_submit_pressed():
	DataController.submit_score(randi_range(0,100))

func _on_update_leaderboard_pressed():
	pass

func _on_update_playerscore_pressed():
	pass

func _on_show_all_leaderboard_pressed():
	GooglePlayController.show_all_leaderboards()
