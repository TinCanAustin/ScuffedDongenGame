extends Node2D

signal on_attack(option: int)
signal player_is_dead()
signal player_item_used(itemUsed: String)

@export var health : int:
	set(value):
		health = clamp(value, 0, 1000)
		
var currentMaxHealth = 100

@export var damage : int

@onready var manager = %fgManager
@onready var Plabel = $Label


var is_buff = false
var buff_count = 0

func take_damage():
	health -= manager.enemyDamage;
	Plabel.text = "Health: " + str(health)
	if health <= 0:
		get_node("AnimatedSprite2D").play("die")
		player_is_dead.emit()
	
func heal(amount : int):
	health += amount;
	if(health > currentMaxHealth):
		health = currentMaxHealth
	Plabel.text = "Health: " + str(health)
	
func attack(option: int):
	if manager.state == 0:
		if is_buff == true:
			buff_count+= 1
			if buff_count == 5:
				manager.playerDamage = damage;
				is_buff = false
		on_attack.emit(option);

func _on_rock_pressed():
	attack(Global.rpc.rock);

func _on_paper_pressed():
	attack(Global.rpc.paper);

func _on_scissors_pressed():
	attack(Global.rpc.scissors);

func _on_enemy_enemy_action_complete(action):
	if action == int(Global.compAction.received):
		take_damage()


func _on_fg_manager_item_used(itemUsed):
	var stat = manager.player_stat.items
	
	if stat[itemUsed]["amount"] > 0:
		var type = stat[itemUsed]["stat"][0]
		var amout = stat[itemUsed]["stat"][1]
		
		match type:
			Global.itemType.heal:
				if(health < currentMaxHealth):
					heal(amout)
					player_item_used.emit(itemUsed)
			
			Global.itemType.atkBuff:
				if is_buff == false:
					is_buff = true
					buff_count = 0
					manager.playerDamage = damage + amout;
					player_item_used.emit(itemUsed)


func _on_fg_manager_save_player_health():
	Global.playerHealth = health

func _on_fg_manager_cal_player_damage(copx):
	damage = damage + (10 * copx)
	
	currentMaxHealth = currentMaxHealth + (100 * copx);
	
	if Global.level > 1:
		health = Global.playerHealth
	else:
		health = currentMaxHealth
		Global.remeberHealth = health
		Global.playerHealth = health
	
	Plabel.text = "Health: " + str(health)
	manager.playerDamage = damage;
