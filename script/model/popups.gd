extends Node
class_name Popups

enum PopupID{
	POPUP_NONE = -1,
	
	POPUP_CLEAR_DATA,
	POPUP_QUIT_APP,
}

## FLAGS
const PRESSED_KEEP : 		int = 0b0000001
const CLICK_OUTSIDE_CLOSE : int = 0b0000010

#DEFINE CLASS
#class PopupData:
	#var id : int
	#var type 	 :  String
	#var content : String
	#var buttons : Array[String]
	#var flags   : int

#DEFINE POPUP
const PopupsDefine: Dictionary = {
	PopupID.POPUP_CLEAR_DATA : {
		"id" : PopupID.POPUP_CLEAR_DATA,
		"type"    : "type1",
		"content" : "Do you want to clear all data?",
		"buttons" : ["yes","no"],
		"flags"   : CLICK_OUTSIDE_CLOSE ,
	},
	PopupID.POPUP_QUIT_APP : {
		"id" : PopupID.POPUP_QUIT_APP,
		"type"    : "type1",
		"content" : "Do you want to quit app?",
		"buttons" : ["yes","no"],
		"flags"   : CLICK_OUTSIDE_CLOSE ,
	}
}
