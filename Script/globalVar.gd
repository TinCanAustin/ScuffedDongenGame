extends Node

enum rpc {rock, paper, scissors}
enum compAction {non, attacked, received}
enum itemType {heal, atkBuff, atkObj}

var level : int = 1
var playerHealth : int:
	set(value):
		playerHealth = clamp(value, 0, 1000)
var remeberHealth = 0;

var common = ["Small Med", "Small+ Med", "Medium Med", "ATK UP", "Darts"]
var rare = ["Medium+ Med", "Large Med", "ATK+ UP", "ATK++ UP", "Bombs"]
var LEG = ["Large+ Med", "GOD PILL", "NUKE"]
