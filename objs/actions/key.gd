extends "res://objs/actionable.gd"

var is_player_near = false

func get_action_name():
  return "pickup key"

func can_perform():
  print('>>> key can_perform ', is_player_near)
  return is_player_near

func perform():
  var player = get_node('/root/main/player')
  player.inventory_keys += 1
  self.queue_free()
  print('>>> picked up key!')
  Action.update_inventory_gui()

func _on_area_body_entered(body):
  if body.name == "player":
    is_player_near = true
    Action.set_node(self)

func _on_area_body_exited(body: Node3D):
  if body.name == "player":
    is_player_near = false
    Action.set_node(null)
