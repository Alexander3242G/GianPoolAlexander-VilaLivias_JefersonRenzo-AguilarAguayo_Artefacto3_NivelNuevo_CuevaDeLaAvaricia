extends RigidBody2D
## Clase que controla animación y configuración del objeto cañón
##
## Setea la animación del objeto 
## Cambia animación de idle a disparado, elimina la bala de la escena


# Definimos la escena de destrucción del objeto
@onready var _cannon_animation = $AnimatedSprite2D
# Definimos el sprite animado de efectos
@onready var _animated_sprite_effects = $AnimatedSprite2D/AnimatedSprite2DEffects
# Definimos la bala de cañón
var new_ball: RigidBody2D

# Variables exportadas para poder modificar en el editor
@export var ball_mass: float = 0.1  # Masa predeterminada de la bala
@export var ball_gravity_scale: float = 0.5  # Escala de gravedad predeterminada de la bala
@export var ball_position_x: float = -20 # Masa predeterminada de la bala
@export var ball_position_y: float = 0 # Escala de gravedad predeterminada de la bala
@export var ball_linear_velocity: Vector2 = Vector2(-500, 20)  # Velocidad lineal inicial de la bala

@export var animated_scale_x: float = 1.0
@export var animated_scale_y: float = 1.0

@export var frecuencia: float = 0.2

# Called when the node enters the scene tree for the first time.
func _ready():
	# Ajustamos la direccion del cañon
	_cannon_animation.scale.x = animated_scale_x
	_cannon_animation.scale.y = animated_scale_y
	# Disparamos
	fire()
	
	
func fire():
	# Reproducimos la animación de disparo
	_cannon_animation.play("fire")


func _on_animated_sprite_2d_frame_changed():
	# Validamos si el frame de animación es 3
	if _cannon_animation.frame == 3:
		# Cargamos la escena de bala
		var ball = "scenes/game/levels/objects/damage_object/cannon/cannon_ball.tscn"
		new_ball = load(ball).instantiate()
		
		# Ajustamos la posición inicial del proyectil
		new_ball.position.x = ball_position_x
		new_ball.position.y = ball_position_y
		# Aplica la velocidad inicial
		new_ball.linear_velocity = ball_linear_velocity
		# Ajustamos la masa del proyectil
		new_ball.mass = ball_mass
		# Ajustamos la gravedad del proyectil
		new_ball.gravity_scale = ball_gravity_scale
		# Agregamos la bala a la escena
		self.add_child(new_ball)
		# Agregamos la animación de humo
		_animated_sprite_effects.play("fire_effect")


func _on_animated_sprite_2d_animation_finished():
	# Validamos si la animación es de fuego
	if _cannon_animation.get_animation() == 'fire':
		# Esperamos un segundo
		await get_tree().create_timer(frecuencia).timeout
		# Eliminamos la bala
		new_ball.queue_free()
		# Disparamos otra vez
		fire()
		
