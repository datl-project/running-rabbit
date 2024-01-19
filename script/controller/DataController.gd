extends SerializingData

#### Highscore
@export var highscore : int = 0

var _is_loaded := false

func submit_score(value):
	GooglePlayController.submit_leaderboard_score(value)
	pass

func update_highscore():
	highscore = await GooglePlayController.get_player_highscore()
	pass

