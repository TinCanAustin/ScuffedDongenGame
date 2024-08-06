extends Node

signal itemUsed(itemUsed: String)
signal savePlayerHealth()
signal SpawnEnemy(copx: int)
signal calPlayerDamage(copx: int)

const font = preload("res://Assets/PixelOperator8.ttf")

@export var op1 : Control
@export var op2 : Control
@export var op3 : Control
@export var op4 : Control

enum action {fight, inventory, run, idel}

#gameState
@export var state : action = action.idel; 

#damage
var playerDamage: int;
var enemyDamage: int;

#items
var itemNode = preload("res://Prefabs/item.tscn")
@onready var button = $Button

var gameState = true

#playerInventory
var player_stat = playerStat.new()
var savePath :=  "user://PlayerSave.tres"


func savePlayerStat():
	ResourceSaver.save(player_stat, savePath);
	
func loadPlayerStat():
	if(ResourceLoader.exists(savePath)):
		player_stat = load(savePath)
	else:
		print("not work")
		player_stat = playerStat.new()

func _ready():
	loadPlayerStat()
	SpawnEnemy.emit(Global.level / 15)
	calPlayerDamage.emit(player_stat.levelCompleted / 15)
	
	print(player_stat.levelCompleted)
	
	op4.visible = false
	op2.visible = false
	for item in player_stat.items:
		if player_stat.items[item]["amount"] != 0:
			var node = itemNode.instantiate()
			node.get_node("Amount").text = str(player_stat.items[item]["amount"])
			node.get_node("Label").text = item
			
			var buttonPress = func(): itemUsed.emit(item)
			node.get_node("ItemButton").connect("pressed",buttonPress)
			
			node.name = str(item)
			
			op3.get_node("GridContainer").add_child(node)
	op3.visible = false	
	
	$Level.text = "Level: " + str(Global.level)

func closeAttackMenu():
	op2.visible = false
	op1.visible = true
	state = action.idel;

func openAttckMenu():
	op1.visible = false
	op2.visible = true
	state = action.fight;
	
func closeItemMenu():
	op3.visible = false
	op1.visible = true
	state = action.idel;
	
func openItemMenu():
	op1.visible = false
	op3.visible = true
	state = action.inventory;
	
func finalStat():
	op1.visible = false
	op2.visible = false
	op3.visible = false
	op4.visible = true
	
func _on_fight_pressed():
	openAttckMenu()

func _on_back_pressed():
	closeAttackMenu()
	closeItemMenu()

func _on_enemy_enemy_action_complete(action):
	if gameState == true:
		closeAttackMenu()
		match action:
			Global.compAction.non:
				op1.get_node("ActionTaken").text = "No Damage Taken";
			Global.compAction.attacked:
				op1.get_node("ActionTaken").text = "Enemy took " + str(playerDamage) + " damage";
			Global.compAction.received:
				op1.get_node("ActionTaken").text = "Player took " + str(enemyDamage) + " damage";


func _on_items_pressed():
	openItemMenu()


func _on_give_up_pressed():
	Global.level = 1
	Global.playerHealth = Global.remeberHealth
	savePlayerStat()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")


func get_items():
	#print(player_stat.itemsRecieved)
	
	if player_stat.levelCompleted % 30 == 0 && player_stat.levelCompleted != 0:
		player_stat.itemsRecieved = player_stat.itemsRecieved * int(player_stat.levelCompleted/30)
		
	var scroll = op4.get_node("Items").get_node("ScrollContainer").get_node("VBoxContainer")
	
	for rolls in range(player_stat.itemsRecieved):
		var roll = randi_range(1, 100)
		var item;
		var amount;
		var stat;
		
		if roll <= 50:
			item = Global.common[randi_range(0, 4)]
			amount = randi_range(1, 5)
			player_stat.items[item]["amount"] += amount
		elif roll > 50 and roll <= 95:
			item = Global.rare[randi_range(0, 4)]
			amount = randi_range(1, 3)
			player_stat.items[item]["amount"] += amount
		elif roll > 95:
			item = Global.LEG[randi_range(0, 2)]
			amount = randi_range(1, 2)
			player_stat.items[item]["amount"] += amount
		
		stat = item + " x" + str(amount)
		
		var lab = Label.new()
		lab.text = stat
		lab.add_theme_font_override("font", font)
		
		scroll.add_child(lab)
		
func _on_enemy_enemy_is_dead():
	finalStat()
	get_items()
	op4.get_node("Statement").text = "You win"
	op4.get_node("You lose").visible = false
	gameState = false

func _on_player_player_is_dead():
	finalStat()
	op4.get_node("Statement").text = "You lose"
	op4.get_node("You Win").visible = false
	op4.get_node("Items").visible = false
	gameState = false

func reduceItem(itemUsed):
	player_stat.reduceAmount(itemUsed)
	var node = op3.get_node("GridContainer").get_node(itemUsed)
	if player_stat.items[itemUsed]["amount"] != 0:
		node.get_node("Amount").text = str(player_stat.items[itemUsed]["amount"])
	else:
		node.queue_free()

func _on_player_player_item_used(itemUsed):
	reduceItem(itemUsed)


func _on_enemy_item_used_on_enemy(itemUsed):
	reduceItem(itemUsed)


func _on_next_level_pressed():
	Global.level += 1;
	savePlayerHealth.emit()
	savePlayerStat()
	get_tree().reload_current_scene()


func _on_end_pressed():
	player_stat.levelCompleted += Global.level
	Global.level = 1
	Global.playerHealth = Global.remeberHealth
	savePlayerStat()
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
