
extends Node
###ADMOB
##Property
#var _ad_view: AdView = null
#var _ad_listener := AdListener.new()
#var _ad_unit_id : String = "ca-app-pub-3940256099942544/6300978111"

#DEFAULT
var default_leaderboard_id = "CgkIm8evpagMEAIQAg"

#SIGNAL
signal received_player_highscore(score,rank)

# Leaderboards methods
func show_leaderboard(leaderboard_id : String = "") -> void:
	print("show_leaderboard leaderboard_id = %s" % leaderboard_id)
	if leaderboard_id == "":
		leaderboard_id = default_leaderboard_id
	LeaderboardsClient.show_leaderboard(leaderboard_id)
	#if GPGS:
		#GPGS.showLeaderBoard(leaderboard_id) 
	pass

func show_all_leaderboards() -> void:
	print("show_all_leaderboards")
	LeaderboardsClient.show_all_leaderboards()
	#if GPGS:
		#GPGS.showAllLeaderBoards()
	pass
	
func submit_leaderboard_score(score : int , leaderboard_id : String = "") -> void:
	if leaderboard_id == "":
			leaderboard_id = default_leaderboard_id
	print("submit_leaderboard_score score = %s leaderboard_id = %s" % [score,leaderboard_id])
	LeaderboardsClient.submit_score(leaderboard_id,score)
	#if GPGS:
		#GPGS.submitLeaderBoardScore(leaderboard_id, score) 
	pass
	
func retrive_player_highscore(leaderboard_id : String = ""):
	if leaderboard_id == "":
		leaderboard_id = default_leaderboard_id
	print("retrive_player_highscore leaderboard_id = %s" % leaderboard_id)
	LeaderboardsClient.load_player_score(leaderboard_id,LeaderboardsClient.TimeSpan.TIME_SPAN_ALL_TIME,LeaderboardsClient.Collection.COLLECTION_FRIENDS)
	#if GPGS:
		#pass
	pass
	
func get_player_highscore(leaderboard_id : String = ""):
	retrive_player_highscore(leaderboard_id)
	var data = await received_player_highscore
	return data[0]
	pass
	
### ADMOB
#func load_banner():
	#if _ad_view == null:
		#_create_ad_view()
	#_ad_view.ad_listener = _ad_listener
	#var ad_request := AdRequest.new()
	#_ad_view.load_ad(ad_request)
	#
#func show_banner():
	#if not _ad_view:
		#load_banner()
	#_ad_view.show()	
#
#func hide_banner():
	#if _ad_view:
		#_ad_view.hide()
		#
#func destroy_banner():
	#if _ad_view:
		#_ad_view.destroy()

func _ready():
	#Inint GPGS
	_init_gpgs()
	_connect_gpgs()
	
	##Inint ADMob
	#_init_admob()
	#_connect_admob()

	pass
	
## GPGS
func _init_gpgs():
	pass

func _connect_gpgs():
	LeaderboardsClient.score_loaded.connect(_on_score_loaded)
	LeaderboardsClient.score_submitted.connect(_on_score_submitted)
	pass
	
### ADMOB
#func _init_admob():
	#MobileAds.initialize()
	#pass
	#
#func _connect_admob():
	#_ad_listener.on_ad_failed_to_load = _on_ad_failed_to_load 
	#_ad_listener.on_ad_clicked 		= _on_ad_clicked 
	#_ad_listener.on_ad_closed  		= _on_ad_closed
	#_ad_listener.on_ad_impression  	= _on_ad_impression
	#_ad_listener.on_ad_loaded  		= _on_ad_loaded
	#_ad_listener.on_ad_opened  		= _on_ad_opened
		#
#func _create_ad_view() -> void:
	#if _ad_view: 
		#_destroy_ad_view()
	#_ad_view = AdView.new(_ad_unit_id,AdSize.BANNER, AdPosition.Values.BOTTOM)
	#
#func _destroy_ad_view() -> void:
	#if _ad_view:
		##always call this method on all AdFormats to free memory on Android/iOS
		#_ad_view.destroy()
		#_ad_view = null
	
###  SLOTS	
## GPGS
func _on_score_loaded(leaderboard_id: String, score: LeaderboardsClient.Score):
	print("_on_score_loaded = %s" % score._to_string())
	received_player_highscore.emit(score.raw_score,score.display_rank)
	pass
	
func _on_score_submitted(is_submitted: bool, leaderboard_id: String):
	print("_on_score_submitted is_submitted = %s leaderboard_id = %s" % [is_submitted,leaderboard_id])
	pass

#func _on_ad_failed_to_load(load_ad_error):
	#print("_on_ad_failed_to_load: " + load_ad_error.message)
	#pass
	#
#func _on_ad_clicked():
	#print("_on_ad_clicked")
	#pass
#
#func _on_ad_closed():
	#print("on_ad_closed")
	#pass
#
#func _on_ad_impression():
	#print("on_ad_impression")
	#pass
#
#func _on_ad_loaded():
	#print("on_ad_loaded")
	#pass
#
#func _on_ad_opened ():
	#print("on_ad_opened")
	#pass
