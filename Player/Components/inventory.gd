class_name Inventory extends Resource

@export var coins : int = 0 :
    set(value):
        coins = value
        print_debug("[Inventory] COINS: " + str(coins))

@export var keys : int = 0 :
    set(value):
        keys = value
        print_debug("[Inventory] KEYS: " + str(keys))

#region Coin & Key Functions
func add_coin(value: int = 1) -> void:
    # print_debug("[Inventory] adding " + str(value) + " coins")
    coins += value

func add_key() -> void:
    keys += 1
#endregion