extends Node

var node

func get_display() -> String:
  if not node or not node.has_method("get_action_name"):
    return " "

  return "Press [E] to " + node.get_action_name()

func set_node(n):
  node = n
  update_gui()

# TODO: maybe move this to a GUI helper
func update_gui():
  var label = get_node('/root/main/gui/margin/hbox/vbox/action_label')
  label.text = get_display()

# TODO: move this to an inventory / GUI helper
func update_inventory_gui():
  var label = get_node('/root/main/gui/margin/hbox/vbox/inventory_label')
  var player = get_node('/root/main/player')

  label.text = "keys: %d" % player.inventory_keys if player.inventory_keys > 0 else ""

func can_perform() -> bool:
  print('>>> action can_perform has method? ', node and node.has_method("can_perform"))
  if not node or not node.has_method("can_perform"):
    return false

  return node.can_perform()

func perform():
  print('>>> action perform has method? ', node and node.has_method("perform"), ' can_perform? ', can_perform())
  if not node or not node.has_method("perform") or not can_perform():
    return

  return node.perform()
