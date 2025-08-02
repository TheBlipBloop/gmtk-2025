extends AudioStreamPlayer3D
class_name RandomizedAudioPlayer3D
# horrid design ,sorry
# really should be a reousrce thing ah well 

@export var pitch_max = 1.3
@export var pitch_min = 0.8
@export var sound_pool: Array[AudioStream] = []

func play_audio_randomized():
	if sound_pool.size() > 0:
		stream = sound_pool[Random.get_rng().randi_range(0, sound_pool.size() - 1)]
	pitch_scale = Random.get_rng().randf_range(pitch_min, pitch_max)
	play()

# inconsistent signals lets fucking GOOO
func play_audio_randomized_1param(_dummy):
	play_audio_randomized()
