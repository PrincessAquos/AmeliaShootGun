extends Node

const CastleDB = preload("res://addons/thejustinwalsh.castledb/castledb_types.gd")

class ItemIndex:

	const notepad := "notepad"
	const badge := "badge"
	const gear_case := "gear_case"
	const gun := "gun"
	const scroll := "scroll"

	class ItemIndexRow:
		var id := ""
		var iname := ""
		var img_path := ""
		var slot := 0
		var equippable := false
		var menu_use := false
		var have_multiple := false
		
		func _init(id = "", iname = "", img_path = "", slot = 0, equippable = false, menu_use = false, have_multiple = false):
			self.id = id
			self.iname = iname
			self.img_path = img_path
			self.slot = slot
			self.equippable = equippable
			self.menu_use = menu_use
			self.have_multiple = have_multiple
	
	var all = [ItemIndexRow.new(notepad, "Notepad", "res://Sprite/Items/Notepad.png", 0, false, true, false), ItemIndexRow.new(badge, "Badge", "res://Sprite/Items/Badge.png", 1, false, true, false), ItemIndexRow.new(gear_case, "Gear Part Case", "res://Sprite/Items/GearPartCase.png", 2, false, false, false), ItemIndexRow.new(gun, "Gun", "res://Sprite/Items/Gun.png", 3, false, false, false), ItemIndexRow.new(scroll, "Counter Spell", "res://Sprite/Items/Scroll.png", 4, false, false, true)]
	var index = {notepad: 0, badge: 1, gear_case: 2, gun: 3, scroll: 4}
	
	func get(id:String) -> ItemIndexRow:
		if index.has(id):
			return all[index[id]]
		return null

	func get_index(idx:int) -> ItemIndexRow:
		if idx < all.size():
			return all[idx]
		return null

var itemindex := ItemIndex.new()
