extends Node2D


@export var level_01: PackedScene


func _on_play_btn_pressed():
	get_tree().change_scene_to_packed(level_01)


func _on_quit_btn_pressed():
	get_tree().quit()
