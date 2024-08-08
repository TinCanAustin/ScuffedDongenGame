extends Node2D

var player_stat;

func _ready():
	if(ResourceLoader.exists("user://PlayerSave.tres")):
		player_stat = load("user://PlayerSave.tres")
		if(player_stat.onePlayDone == true):
			get_node("done").text = "Highets Level: %s \n\n Levels played: %s" % [player_stat.heightScore , player_stat.levelCompleted]
			get_node("done").visible = true
		else:
			get_node("notDone").visible = true	
	else:
		get_node("notDone").visible = true

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scene/fight.tscn")

func _on_quit_pressed():
	get_tree().quit()
