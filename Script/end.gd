extends Node2D

func _on_end_pressed():
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


func _on_play_again_pressed():
	get_tree().change_scene_to_file("res://Scene/fight.tscn")
