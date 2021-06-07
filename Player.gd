extends Area2D

signal hit
export var speed = 400  # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.
var event_position  

func _ready():
    screen_size = get_viewport_rect().size
    hide()
    
func _input(event):
    if event is InputEventScreenTouch:
        if event.is_pressed():
            event_position = event.position
    if event is InputEventScreenDrag:
        event_position = event.position
        
func _process(delta):
    var velocity = Vector2()  # The player's movement vector.
    if Input.is_mouse_button_pressed(BUTTON_LEFT):
        if event_position.x - position.x > 0:
            velocity.x += 1
        else:
            velocity.x -= 1
        if event_position.y - position.y > 0:
            velocity.y += 1
        else:
            velocity.y -= 1
    if velocity.length() > 0:
        velocity = velocity.normalized() * speed
        $AnimatedSprite.play()
    else:
        $AnimatedSprite.stop()
        
    position += velocity * delta
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)
    
    if velocity.x != 0:
        $AnimatedSprite.animation = "walk"
        $AnimatedSprite.flip_v = false
        # See the note below about boolean assignment
        $AnimatedSprite.flip_h = velocity.x < 0
    elif velocity.y != 0:
        $AnimatedSprite.animation = "up"
        $AnimatedSprite.flip_v = velocity.y > 0

func _on_Player_body_entered(body):
    hide()  # Player disappears after being hit.
    emit_signal("hit")
    $CollisionShape2D.set_deferred("disabled", true)

func start(pos):
    position = pos
    show()
    $CollisionShape2D.disabled = false
