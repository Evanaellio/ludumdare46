extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_Player_update_electronics(nb_electronics):
	$NbElectronics.text = str(nb_electronics)
