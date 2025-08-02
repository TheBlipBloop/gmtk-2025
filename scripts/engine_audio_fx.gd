# this is a terrible thing to do sorry future people who can read code :|
extends AudioStreamPlayer3D


@export var drift_audio : AudioStreamPlayer3D

@export var drift_start_audio : AudioStreamPlayer3D
@export var drift_stop_audio : AudioStreamPlayer3D

var m_movement: CarMovement;
var m_prev_drift_state: bool;


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if m_movement == null:
		m_movement = Game.player_movement
		return
		
	pitch_scale = (m_movement.velocity.length() / 12.0) + 0.4
	volume_linear = clamp(m_movement.velocity.length() * 4.0, 0.7, 1.25)
	
	if m_movement.m_drift_speed_boost > 1.25:
		drift_audio.volume_linear = (m_movement.m_drift_speed_boost - 1.1) / 3.0
		
	if m_movement.external_is_drift_valid() != m_prev_drift_state:
		m_prev_drift_state = m_movement.external_is_drift_valid()
		
		#if m_prev_drift_state:
			#drift_start_audio.play()
		#else:
			#drift_stop_audio.play()
		
