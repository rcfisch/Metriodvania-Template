# Metriodvania-Template
A template for making metroidvanias in godot.


Art Design:
Viewport Resolution: 480x270

Characters: 16x16 (outline 1 thick)
# Items: 8x8 (outline 1 thick)

Small enemy: 16x16 (run of the mill enemies) (outline 1 thick)
Medium enemy: 32x32 (run of the mill enemies) (outline 1 thick)
Large enemy: 64x64 (bosses/few and far) (outline 1 thick)

Tiles: 8x8

Programming Design:
Snake Case
gdscript

COLLISION LAYERS:
	Player and tiles = 1
	Player attack (anything pogoable) = 2
	Floor tiles (anything that collides with the floor but not the player, so most entities) = 3
	Player Hurtbox (anything that hurts the player) = 4
	Player Hitbox (I dont remember why we did this) = 5
