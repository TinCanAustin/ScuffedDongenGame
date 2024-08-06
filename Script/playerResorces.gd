class_name playerStat
extends Resource

@export var levelCompleted = 0;
@export var itemsRecieved = 2;
@export var items = {
	"Small Med": {"stat": [Global.itemType.heal, 5], "amount": 10},
	"Small+ Med": {"stat": [Global.itemType.heal, 10], "amount": 0},
	"Medium Med": {"stat": [Global.itemType.heal, 20], "amount": 0},
	"Medium+ Med": {"stat": [Global.itemType.heal, 25], "amount": 0},
	"Large Med": {"stat": [Global.itemType.heal, 50], "amount": 0},
	"Large+ Med": {"stat": [Global.itemType.heal, 100], "amount": 0},
	"ATK UP": {"stat": [Global.itemType.atkBuff, 10], "amount": 5},
	"ATK+ UP": {"stat": [Global.itemType.atkBuff, 30], "amount": 0},
	"ATK++ UP": {"stat": [Global.itemType.atkBuff, 50], "amount": 0},
	"GOD PILL": {"stat": [Global.itemType.atkBuff, 100], "amount": 0},
	"Bombs": {"stat": [Global.itemType.atkObj, 30], "amount": 0},
	"Darts": {"stat": [Global.itemType.atkObj, 5], "amount": 5},
	"NUKE": {"stat": [Global.itemType.atkObj, 1000], "amount": 0},
}

func reduceAmount(item : String):
	items[item]["amount"] -= 1;
