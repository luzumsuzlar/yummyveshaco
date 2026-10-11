extends Node

signal effect_played(effect: String)

const SAMPLE_RATE := 22050
const SETTINGS_PATH := "user://audio_settings.cfg"
const DURATIONS := {"launch": 0.16, "bounce": 0.09, "paw": 0.22, "unlock": 0.65, "purr": 0.90}

var muted := false
var settings_path := SETTINGS_PATH
var streams: Dictionary = {}
var voices: Array[AudioStreamPlayer] = []
var next_voice := 0
var purr_voice: AudioStreamPlayer
var sleep_active := false
var purr_wait := 2.0


func _ready() -> void:
	var settings := ConfigFile.new()
	if settings.load(settings_path) == OK:
		muted = bool(settings.get_value("audio", "muted", false))
	for effect in DURATIONS:
		streams[effect] = synthesize(effect)
	for index in range(6):
		var voice := AudioStreamPlayer.new()
		voice.volume_db = -9.0
		add_child(voice)
		voices.append(voice)
	purr_voice = AudioStreamPlayer.new()
	purr_voice.volume_db = -10.0
	purr_voice.stream = streams["purr"]
	add_child(purr_voice)


func _exit_tree() -> void:
	stop_all()


func set_muted(value: bool, persist: bool = true) -> void:
	muted = value
	if muted:
		stop_all()
	if persist:
		var settings := ConfigFile.new()
		settings.set_value("audio", "muted", muted)
		var result := settings.save(settings_path)
		if result != OK:
			push_warning("Ses tercihi kaydedilemedi: %s" % result)


func stop_all() -> void:
	for voice in voices:
		voice.stop()
	if is_instance_valid(purr_voice):
		purr_voice.stop()
	sleep_active = false
	purr_wait = 2.0


func update_sleep(sleeping: bool, delta: float) -> void:
	if not sleeping or muted:
		if is_instance_valid(purr_voice):
			purr_voice.stop()
		sleep_active = false
		purr_wait = 2.0
		return
	sleep_active = true
	purr_wait -= maxf(0.0, delta)
	if purr_wait <= 0.0:
		purr_wait = 7.5
		if DisplayServer.get_name() != "headless":
			purr_voice.play()
		effect_played.emit("purr")


func play_effect(effect: String) -> void:
	if muted or not streams.has(effect) or voices.is_empty():
		return
	var voice := voices[next_voice]
	next_voice = (next_voice + 1) % voices.size()
	voice.stream = streams[effect]
	# Headless validation has no speaker; avoid queuing Dummy-driver playback.
	if DisplayServer.get_name() != "headless":
		voice.play()
	effect_played.emit(effect)


func synthesize(effect: String) -> AudioStreamWAV:
	# Original synthesized cartoon cues, generated once; no downloaded/licensed clips.
	var duration: float = DURATIONS[effect]
	var samples := int(ceil(duration * SAMPLE_RATE))
	var pcm := PackedByteArray()
	pcm.resize(samples * 2)
	var noise := RandomNumberGenerator.new()
	noise.seed = 74523
	for index in range(samples):
		var t := float(index) / SAMPLE_RATE
		var progress := t / duration
		var sample := 0.0
		var edge := minf(t / 0.005, 1.0) * minf((duration - t) / 0.012, 1.0)
		match effect:
			"launch":
				var phase := TAU * (420.0 * t - 950.0 * t * t)
				sample = (sin(phase) * 0.42 + noise.randf_range(-1, 1) * 0.08) * pow(1.0 - progress, 1.7)
			"bounce":
				sample = (sin(TAU * 310 * t) * 0.35 + sin(TAU * 730 * t) * 0.12 + noise.randf_range(-1, 1) * 0.1) * exp(-t * 42)
			"paw":
				var swoosh := noise.randf_range(-1, 1) * 0.12 * exp(-t * 18)
				sample = swoosh + sin(TAU * (190 * t - 160 * t * t)) * 0.42 * exp(-t * 15)
			"unlock":
				var notes := [659.25, 783.99, 987.77, 1318.51]
				for note in range(4):
					var note_time := t - note * 0.10
					if note_time >= 0.0:
						var attack := minf(note_time / 0.006, 1.0)
						var frequency: float = notes[note]
						sample += (sin(TAU * frequency * note_time) + 0.16 * sin(TAU * frequency * 2 * note_time)) * 0.16 * exp(-note_time * 11) * attack
			"purr":
				# Raise the rumble into a phone-friendly band without changing other cues.
				var pulse := 0.65 + 0.35 * sin(TAU * 25.0 * t)
				var breath := pow(maxf(0.0, sin(PI * progress)), 0.65)
				var rumble := sin(TAU * 180 * t) * 0.20 + sin(TAU * 360 * t) * 0.16 + sin(TAU * 540 * t) * 0.08 + sin(TAU * 720 * t) * 0.03
				sample = (rumble * pulse + noise.randf_range(-1, 1) * 0.012) * breath
		pcm.encode_s16(index * 2, int(clampf(sample * edge, -0.65, 0.65) * 32767))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = pcm
	return stream
