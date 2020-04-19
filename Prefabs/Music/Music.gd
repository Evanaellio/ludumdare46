extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	$Music.init_song("Song")
	$Music.start_alone("Song", "ambiant")
	$Music.fade_in("Song", "ambiant-bass")

func combat():
	$Music.fade_in("Song", "lead")
	$Music.fade_in("Song", "piano")
	$Music.fade_in("Song", "drums")
	$Music.fade_in("Song", "combat-bass")
	$Timer.start()

func calm():
	$Music.fade_out("Song", "lead")
	$Music.fade_out("Song", "piano")
	$Music.fade_out("Song", "drums")
	$Music.fade_out("Song", "combat-bass")
	$Music.fade_in("Song", "ambiant-bass")

func switch_to_calm(_a, _b, _c):
	calm()

func stop():
	$Music.stop("Song")

func _on_Timer_timeout():
	$Music.fade_out("Song", "ambiant-bass")
