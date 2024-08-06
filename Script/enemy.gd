extends Node2D

signal enemy_action_complete(action)
signal enemy_is_dead()
signal item_Used_On_Enemy(itemUsed)

@export var health : int:
	set(value):
		health = clamp(value, 0, 1000)
@export var damage : int 

@onready var Elabel = $Label
@onready var manager = %fgManager

enum Enemytype {common, unordinary, mythic}

var Enemies = {
	Enemytype.common : [
		[preload("res://Prefabs/common_enemy/slime.tscn"), 10, 2],
		[preload("res://Prefabs/common_enemy/skeleton.tscn"), 20, 5],
		[preload("res://Prefabs/common_enemy/zombie.tscn"), 30, 8],
		[preload("res://Prefabs/common_enemy/amongus.tscn"), 35, 12],
	],
	Enemytype.unordinary : [
		[preload("res://Prefabs/unordinary_enemy/eye.tscn"), 50, 25],
		[preload("res://Prefabs/unordinary_enemy/tall.tscn"), 65, 35],
		[preload("res://Prefabs/unordinary_enemy/snake.tscn"), 40, 22],
		[preload("res://Prefabs/unordinary_enemy/the_rock.tscn"),40, 15],
	],
	Enemytype.mythic : [
		[preload("res://Prefabs/mythic/largezomboid.tscn"), 80, 50],
		[preload("res://Prefabs/mythic/wishing_star.tscn"), 85, 60],
		[preload("res://Prefabs/mythic/anomaly.tscn"), 90, 70]
	]
}
	
func is_die():
	if health <= 0:
		enemy_is_dead.emit()
		get_node("enemySprite").play("die")
	
func attackTaken():
	health -= manager.playerDamage;
	Elabel.text = "Health: " + str(health)
	is_die()
	
func _on_player_on_attack(option):
	var choice = randi_range(0,2);
	match option:
		Global.rpc.rock:
			if choice == int(Global.rpc.rock):
				enemy_action_complete.emit(Global.compAction.non);
			elif choice == int(Global.rpc.paper):
				enemy_action_complete.emit(Global.compAction.received);
			elif choice == int(Global.rpc.scissors):
				attackTaken()
				enemy_action_complete.emit(Global.compAction.attacked);
				
		Global.rpc.paper:
			if choice == int(Global.rpc.rock):
				attackTaken()
				enemy_action_complete.emit(Global.compAction.attacked);
			elif choice == int(Global.rpc.paper):
				enemy_action_complete.emit(Global.compAction.non);
			elif choice == int(Global.rpc.scissors):
				enemy_action_complete.emit(Global.compAction.received);
				
		Global.rpc.scissors:
			if choice == int(Global.rpc.rock):
				enemy_action_complete.emit(Global.compAction.received);
			elif choice == int(Global.rpc.paper):
				attackTaken()
				enemy_action_complete.emit(Global.compAction.attacked);
			elif choice == int(Global.rpc.scissors):
				enemy_action_complete.emit(Global.compAction.non);
	


func _on_fg_manager_item_used(itemUsed):
	var stat = manager.player_stat.items
	
	if stat[itemUsed]["amount"] > 0:
		var type = stat[itemUsed]["stat"][0]
		var amout = stat[itemUsed]["stat"][1]
		
		if type == Global.itemType.atkObj:
			if health > 0:
				health -= amout;
				Elabel.text = "Health: " + str(health)
				
				item_Used_On_Enemy.emit(itemUsed)
				
				is_die()


func _on_fg_manager_spawn_enemy(copx):	
	var type : int
	match copx:
		0:
			type = Enemytype.common
		1:
			type = Enemytype.unordinary
		3:
			type = Enemytype.mythic
		_:
			type = randi_range(0, Enemytype.mythic)
	print(type)
	
	var chosenEnemy = randi_range(0,Enemies[type].size()-1);
	var node = Enemies[type][chosenEnemy][0].instantiate()
	health = Enemies[type][chosenEnemy][1]
	damage = Enemies[type][chosenEnemy][2]
	
	Elabel.text = "Health: " + str(health)
	manager.enemyDamage = damage;
	
	node.position = Vector2(0, -70)
	node.name = "enemySprite"
	add_child(node)
