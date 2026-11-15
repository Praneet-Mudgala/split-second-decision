extends CPUParticles2D

func burst(particle_color: Color) -> void:
	color = particle_color
	emitting = true
	await finished
	queue_free()
