# Inventory.gd
extends Node
class_name Inventory

var items: Array[String] = []

signal item_added(item_id: String)
signal item_removed(item_id: String)

func add_item(item_id: String):
	if not has_item(item_id):
		items.append(item_id)
		item_added.emit(item_id)
		print("Agregado al inventario: " + item_id)
	else:
		print("Ya tienes: " + item_id)

func remove_item(item_id: String):
	if has_item(item_id):
		items.erase(item_id)
		item_removed.emit(item_id)
		print("Removido del inventario: " + item_id)

func has_item(item_id: String) -> bool:
	return item_id in items

func get_all_items() -> Array[String]:
	return items.duplicate()

func clear_inventory():
	items.clear()
	print("Inventario limpiado")
