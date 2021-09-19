#####################################################################
#
# CSCB58 Summer 2021 Assembly Final Project
# University of Toronto, Scarborough
#
# Student: Zhao Ji Wang, Student Number: 1005915529, UTorID: wangz725
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 (update this as needed)
# - Unit height in pixels: 8 (update this as needed)
# - Display width in pixels: 512 (update this as needed)
# - Display height in pixels: 256 (update this as needed)
# - Base Address for Display: 0x10008000 ($gp)
#
# Which milestones have been reached in this submission?
# (See the assignment handout for descriptions of the milestones)
# - Milestone 3 (choose the one that applies)
#
# Which approved features have been implemented for milestone 3?
# (See the assignment handout for the list of additional features)
# 1. Score Keeping System
# 2. Increasing in difficulty as game progresses (By Making them Move Faster)
# 3. Powerups(2 types of powerups, pink one regenerates player health, Green one slows the enemy down)
# 4. Grazing(Player loses health in proportion to how long and how many pixels the ship gets hit by obstacle)
#
# Link to video demonstration for final submission:
# - https://youtu.be/k5wtSwFGKk0
#
# Are you OK with us sharing the video with people outside course staff?
# - Yes
#
# Any additional information that the TA needs to know:
# - When in main menu, press 'f' to start the game, and press 'p' at any time after that to restart the game. 
# - You cannot use two Green Powerups in a row, you have to wait for the first green powerup's effect to end in order to use the second one. 
#####################################################################
# Bitmap display starter code
#
# Bitmap Display Configuration:
# - Unit width in pixels: 8 
# - Unit height in pixels: 8
# - Display width in pixels: 512
# - Display height in pixels: 256
# - Base Address for Display: 0x10008000 ($gp)
#
# Base Address of the Screen
.eqv BASE_ADDRESS 0x10008000

#Color of the Background
.eqv Dark_Blue_Color 0x00008b

# Colors of the plane
.eqv Brown_Color 0x808000
.eqv Orange_Color 0xffa500

# Colors of Obstacles
.eqv Gray_Color 0x808080
.eqv Deep_Gray_Color 0x222222
.eqv Pink_Color 0xffc0cb

# Colors of Collisions
.eqv Deep_Red_Color 0x850101
.eqv Deep_Orange_Color 0xdd6e0f

# Colors of Game Over Screens
.eqv Red_Color 0xff0000
.eqv Yellow_Color 0xffff00
.eqv Green_Color 0x00ff00
.eqv Blue_Color 0x0000ff
.eqv Black_Color 0x000000
.eqv White_Color 0xffffff

# Essential Data for the Game to Function
.data
player_array: .space 120 # Main player array
enemy_array: .space 360 # First Column of Enemy
enemy_array2: .space 360 # Second COlumn of Enemy
player_health: .word 256 # Player's Health
prompt: .asciiz ", " # Strings for debugging
prompt2: .asciiz "1. " # Strings for debugging
player_score: .word 0 # Score of the player
enemy_slowed: .word 0 # a boolean value that indicates whether enemies are slowed down by powerup

enemy_velocity_ratio: .word 4 # Ratio controlling how fast enemies are moving
should_spawn_enemy2: .word 0 # Boolean value for controlling whether it is time to spawn the second enemy
enemy2_spawned: .word 0 # Boolean value indicating whether

.text
	# Display the Main Menu when the Game is Ran
	li $t0, BASE_ADDRESS 
	j Draw_Menu_Screen
main: 

	# Set Player to Full Health
	addi $t1, $zero, 256
	sw $t1, player_health
	
	# Initialize some miscellaneous variables
	sw $zero, enemy_slowed 
	sw $zero, enemy2_spawned
	sw $zero, should_spawn_enemy2
	
	# Set Player Score to 0
	addi $t1, $zero, 0
	sw $t1, player_score
	
	# Set Enemy Velocity Ratio to 4
	addi $t1, $zero, 4
	sw $t1, enemy_velocity_ratio

	li $t0, BASE_ADDRESS # $t0 stores the base address for display
	li $t1, 0x808000 # $t1 stores the brown colour code
	li $t2, 0xffa500 # $t2 stores the orange colour code
	li $t5, 0x00008b # $t3 stores dark blue colour code
	
	# Innitialize player array player_array[even number] stores location
	# player_array[Odd number] stores color
	la $t3, player_array # $t3 holds the pointer to one location of the array
	
	#tail
	addi $t4, $t0, 3840
	sw $t4, 0($t3)
	add $t4, $zero, $t1
	sw $t4, 4($t3)
	
	addi $t4, $t0, 3844
	sw $t4, 8($t3)
	add $t4, $zero, $t1
	sw $t4, 12($t3)
	
	# Tail Upper
	addi $t4, $t0, 3584
	sw $t4, 16($t3)
	add $t4, $zero, $t1
	sw $t4, 20($t3)
	
	addi $t4, $t0, 4096
	sw $t4, 24($t3)
	add $t4, $zero, $t1
	sw $t4, 28($t3)
	
	# Wings
	addi $t4, $t0, 3848
	sw $t4, 32($t3)
	add $t4, $zero, $t1
	sw $t4, 36($t3)
	
	#Upper Wing
	addi $t4, $t0, 3340
	sw $t4, 40($t3)
	add $t4, $zero, $t2
	sw $t4, 44($t3)
	
	addi $t4, $t0, 3596
	sw $t4, 48($t3)
	add $t4, $zero, $t1
	sw $t4, 52($t3)
	
	#Upper Left Wing
	addi $t4, $t0, 3336
	sw $t4, 56($t3)
	add $t4, $zero, $t1
	sw $t4, 60($t3)
	
	addi $t4, $t0, 3592
	sw $t4, 64($t3)
	add $t4, $zero, $t1
	sw $t4, 68($t3)
	
	#Lower
	addi $t4, $t0, 4108
	sw $t4, 72($t3)
	add $t4, $zero, $t1
	sw $t4, 76($t3)
	
	addi $t4, $t0, 4364
	sw $t4, 80($t3)
	add $t4, $zero, $t2
	sw $t4, 84($t3)
	
	#Lower Left
	addi $t4, $t0, 4104
	sw $t4, 88($t3)
	add $t4, $zero, $t1
	sw $t4, 92($t3)
	
	addi $t4, $t0, 4360
	sw $t4, 96($t3)
	add $t4, $zero, $t1
	sw $t4, 100($t3)
	
	# Other
	addi $t4, $t0, 3852
	sw $t4, 104($t3)
	add $t4, $zero, $t1
	sw $t4, 108($t3)
	
	# Front
	addi $t4, $t0, 3856
	sw $t4, 112($t3)
	add $t4, $zero, $t1 
	sw $t4, 116($t3)
	
	# Generate the First Column of Enemies
	la $t4, enemy_array
	addi $sp, $sp, 4
	sw $t4, 0($sp)
	jal Generate_Enemies
	
	# Main Game Loop
	GAMELOOPHEAD: 
	
		# Redraw the background
		jal Draw_Background
		
		# Drawing the Enemies
		addi $t4, $zero, 356
		addi $sp, $sp, 4 
		sw $t4, 0($sp) # Passing size of the enemy array as arguments
		la $t4, enemy_array
		addi $sp, $sp, 4
		sw $t4, 0($sp) # Passing the address of the enemy array as arguments
		jal Draw
		
		# Draw the Second Column of Enemies if they have been spawned
		lw $t4, enemy2_spawned
		beqz $t4, End_of_Drawing_Second_Enemies
		addi $t4, $zero, 356
		addi $sp, $sp, 4 
		sw $t4, 0($sp) # Passing size of the enemy array as arguments
		la $t4, enemy_array2
		addi $sp, $sp, 4
		sw $t4, 0($sp) # Passing the address of the enemy array as arguments
		jal Draw
		End_of_Drawing_Second_Enemies: 
		
		#Drawing the Player
		addi $t4, $zero, 116
		addi $sp, $sp, 4 
		sw $t4, 0($sp) # Passing size of the player array as arguments
		la $t4, player_array
		addi $sp, $sp, 4
		sw $t4, 0($sp) # Passing the address of the player array as arguments
		jal Draw
		
		jal Get_Key_and_Respond
		
		# Moving the enemies
		addi $sp, $sp, 4 
		la $t4, enemy_array
		sw $t4, 0($sp)
		jal Move_Enemies
		
		# Move the second Column of enemies if they have been spawned
		addi $sp, $sp, 4 
		la $t4, enemy_array2
		sw $t4, 0($sp)
		jal Move_Enemies
		
		# If the second Column of enemies has not been spawned but should be spawned, spawn them
		lw $t4, should_spawn_enemy2
		beqz $t4, End_of_Spawning_Enemy2
		sw $zero, should_spawn_enemy2 # Turn off the boolean value after deciding to spawn them
		addi $sp, $sp, 4 
		la $t4, enemy_array2
		sw $t4, 0($sp)
		jal Generate_Enemies
		End_of_Spawning_Enemy2: 
		
		# Updating Player Score
		lw $t4, player_score
		addi $t4, $t4, 1 # Increase Player Score by 1
		sw $t4, player_score
		
		# Draw the Health Bar and Scores onto the Screen
		jal Draw_Health_Bar
		jal Draw_Score
		
		li $v0, 32
		li $a0, 17 # Wait 67 milisecond
		syscall
		
		j GAMELOOPHEAD
		
	GAMELOOPEND: 

j End_of_Program
# Code Below this are Functions/Methods

# Method for Drawing Game Over Screen
Draw_Menu_Screen: 
	
	# Drawing the black background
	li $t3, 0 # Set Value for T3
	li $t5, Black_Color
	Draw_Menu_Background_LOOPHEAD: slti $t4, $t3, 8192
	beq $t4, $zero, Draw_Menu_Background_LOOPEND # Exit Condition
	add $t6, $t3, $t0 # Calculate the new Location by adding $t3(Offset) and $t6(Starting Index)
	sw $t5, 0($t6) # Load Dark Blue Color Value into the index
	addi $t3, $t3, 4 # Increment $t3 by 1
	
	j Draw_Menu_Background_LOOPHEAD 
	
	Draw_Menu_Background_LOOPEND: 
	
	addi $t3, $t0, 1096 #$t3 is the Starting position of the Text
	
	#Draw S
	li $t5, White_Color
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	
	# Drawing T
	addi $t3, $t3, 28
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 12
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing R
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, -16
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	
	# Drawing I
	addi $t3, $t3, 32
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 512
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	
	# Drawing K
	addi $t3, $t3, 16
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 772
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 1016
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	
	# Drawing E
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 768
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 1024
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing F
	addi $t3, $t3, 512
	addi $t3, $t3, -132
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	
	# Drawing O
	addi $t3, $t3, -236
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing Smaller R
	addi $t3, $t3, 12
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 16
	sw $t5, 0($t3)
	
	#Drawing C
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -272
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing Smaller E
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 240
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 240
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing B
	addi $t3, $t3, 412
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 12
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 248
	sw $t5, 0($t3)
	addi $t3, $t3, 12
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing Dash
	addi $t3, $t3, -500
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing 5
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 504
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	
	# Drawing 8
	addi $t3, $t3, 20
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -512
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	
	# Start when 'f' is pressed
	li $t9, 0xffff0000
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
	# Reset Keyboard input
	addi $t3, $zero, 0
	sw $t3, 4($t9) 
	
	li $v0, 32
	li $a0, 63 # Wait 63 milisecond
	syscall
	
	bne $t2, 102, Draw_Menu_Screen # if 'f' is not pressed, we run the loop over and over again
	j main

Draw_Score: 
	# Initialize the player scores in some registers as well as the colors
	addi $t6, $t0, 7156
	lw $t3, player_score
	li $t5, White_Color
	
	# Main Loop for Drawing the Score
	Draw_Score_Loop_Head: 
	
	addi $t2, $zero, 10 # $t2 will now hold the value of 10
	div $t3, $t2
	
	mflo $t3 # $t3 now holds the quotient
	mfhi $t4 # $t4 now holds the remainder
	
	# Depending on what the remainder is, draw the number on the screen accordingly
	beq $t4, 0, Draw_Zero
	j End_of_Draw_Zero
	Draw_Zero: 
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 260
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 252
	sw $t5, 0($t6)
	addi $t6, $t6, -260
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	End_of_Draw_Zero: 
	
	beq $t4, 1, Draw_One
	j End_of_Draw_One
	Draw_One: 
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -1028
	End_of_Draw_One: 
	
	beq $t4, 2, Draw_Two
	j End_of_Draw_Two
	Draw_Two: 
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -252
	sw $t5, 0($t6)
	addi $t6, $t6, 260
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 252
	sw $t5, 0($t6)
	addi $t6, $t6, 252
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, -1032
	End_of_Draw_Two: 
	
	beq $t4, 3, Draw_Three
	j End_of_Draw_Three
	Draw_Three: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	sw $t5, 0($t6)
	addi $t6, $t6, -776
	End_of_Draw_Three: 
	
	beq $t4, 4, Draw_Four
	j End_of_Drawing_Four
	Draw_Four: 
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -768
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	sw $t5, 0($t6)
	addi $t6, $t6, -8
	End_of_Drawing_Four: 
	
	beq $t4, 5, Draw_Five
	j End_of_Drawing_Five
	Draw_Five: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, -1024
	
	End_of_Drawing_Five: 
	
	beq $t4, 6, Draw_Six
	j End_of_Drawing_Six
	Draw_Six: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, -4
	sw $t5, 0($t6)
	addi $t6, $t6, -256
	sw $t5, 0($t6)
	addi $t6, $t6, -768
	
	End_of_Drawing_Six: 
	
	beq $t4, 7, Draw_Seven
	j End_of_Drawing_Seven
	Draw_Seven: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -1032
	sw $t5, 0($t6)
	
	End_of_Drawing_Seven: 
	
	beq $t4, 8, Draw_Eight
	j End_of_Drawing_Eight
	Draw_Eight: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 8
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 8
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, -1032
	
	End_of_Drawing_Eight: 
	
	beq $t4, 9, Draw_Nine
	j End_of_Drawing_Nine
	Draw_Nine: 
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 8
	sw $t5, 0($t6)
	addi $t6, $t6, 248
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 4
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, 256
	sw $t5, 0($t6)
	addi $t6, $t6, -1032
	
	End_of_Drawing_Nine: 
	
	addi $t6, $t6, -16 # Move onto the spot to draw the next Digit
	
	# As long as the quotient is not zero, we keep this loop running
	Draw_Score_Loop_End: bnez $t3 Draw_Score_Loop_Head
	jr $ra

# Method for Displaying the Health Bar
Draw_Health_Bar: 
	add $t3, $zero, 0 # Initialize $t3
	li $t5, Red_Color
	lw $t6, player_health
	blez $t6, Draw_Game_Over_Screen # If player health <= zero, we draw the game over screen
	Draw_Health_Bar_Loop_Head: slt $t4, $t3, $t6
	beq $t4, $zero, Draw_Health_Bar_Loop_End # Exit Condition
	add $t7, $t3, $t0 # Calculate the new Location by adding $t3(Offset) and $t6(Starting Index)
	sw $t5, 0($t7) # Load Dark Blue Color Value into the index
	addi $t3, $t3, 4 # Increment $t3 by 1
	
	j Draw_Health_Bar_Loop_Head
	
	Draw_Health_Bar_Loop_End: jr $ra

# Method for Drawing Game Over Screen
Draw_Game_Over_Screen: 
	
	# Drawing the black background for the Game Over Screen
	li $t3, 0 # Set Value for T3
	li $t5, Black_Color
	Draw_Game_Over_Background_LOOPHEAD: slti $t4, $t3, 8192
	beq $t4, $zero, Draw_Game_Over_Background_LOOPEND # Exit Condition
	add $t6, $t3, $t0 # Calculate the new Location by adding $t3(Offset) and $t6(Starting Index)
	sw $t5, 0($t6) # Load Dark Blue Color Value into the index
	addi $t3, $t3, 4 # Increment $t3 by 1
	
	j Draw_Game_Over_Background_LOOPHEAD 
	
	Draw_Game_Over_Background_LOOPEND: 
	
	addi $t3, $t0, 1096 #$t3 is the Starting position of the Text
	
	# Then we draw text on the screen. 
	#Draw G
	li $t5, Yellow_Color
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 244
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	
	#Draw A
	li $t5, Red_Color
	addi $t3, $t3, 12
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -768
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -516
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	
	# Drawing M
	li $t5, Green_Color
	addi $t3, $t3, 20
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -768
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	
	# Drawing E
	li $t5, Blue_Color
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 768
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 512
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing R
	li $t5, Green_Color
	addi $t3, $t3, 768
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, -8
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	
	# Drawing E
	li $t5, Blue_Color
	addi $t3, $t3, -20
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -516
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	
	#Drawing V
	li $t5, Yellow_Color
	addi $t3, $t3, -12
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -16
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	
	# Drawing O
	li $t5, Red_Color
	addi $t3, $t3, -24
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, -4
	sw $t5, 0($t3)
	addi $t3, $t3, -260
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -252
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	
	#Drawing Skull
	addi $t3, $t3, 1052
	sw $t5, 0($t3)
	addi $t3, $t3, 4 
	sw $t5, 0($t3)
	addi $t3, $t3, 4 
	sw $t5, 0($t3)
	addi $t3, $t3, 4 
	sw $t5, 0($t3)
	addi $t3, $t3, 256 
	sw $t5, 0($t3)
	addi $t3, $t3, 4 
	sw $t5, 0($t3)
	addi $t3, $t3, 256 
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, 256
	sw $t5, 0($t3)
	addi $t3, $t3, -4 
	sw $t5, 0($t3)
	addi $t3, $t3, 256 
	sw $t5, 0($t3)
	addi $t3, $t3, -260
	sw $t5, 0($t3)
	addi $t3, $t3, -4 
	sw $t5, 0($t3)
	addi $t3, $t3, 256 
	sw $t5, 0($t3)
	addi $t3, $t3, -260
	sw $t5, 0($t3)
	addi $t3, $t3, -4 
	sw $t5, 0($t3)
	addi $t3, $t3, 256 
	sw $t5, 0($t3)
	addi $t3, $t3, -260
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, -256
	sw $t5, 0($t3)
	addi $t3, $t3, 260
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 4
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, 252
	sw $t5, 0($t3)
	addi $t3, $t3, 8
	sw $t5, 0($t3)
	
	jal Draw_Score
	
	# Getting Keyboard Input from the User
	li $t9, 0xffff0000
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
	# Reset Keyboard input
	addi $t3, $zero, 0
	sw $t3, 4($t9) 
	
	li $v0, 32
	li $a0, 63 # Wait 63 milisecond
	syscall
	
	bne $t2, 112, Draw_Game_Over_Screen # Restart the Game when 'p' is pressed
	j main
	
# Method Controlling Enemies Movements
Move_Enemies: 
	lw $t7, 0($sp)
	addi $sp, $sp, -4
	
	#Checking whether the current enemy array is on the left most edge
	lw $t9, 0($t7)
	addi $t9, $t9, -4
	addi $t2, $zero, 256
	div $t9, $t2
	mfhi $t9 
	
	#If the Enemy is indeed on the left most edge, we redraw the enemies
	bnez $t9, End_of_Regenerating_Enemies
	addi $sp, $sp, 4
	sw $t7, 0($sp)
	j Generate_Enemies 
	End_of_Regenerating_Enemies: 
	
	#Checking whether the current enemy array is in the middle of the screen
	lw $t9, 0($t7)
	addi $t9, $t9, -4
	addi $t2, $zero, 128
	div $t9, $t2
	mfhi $t9 
	
	# If the Current Enemy Array is on the right position, we can spawn the second enemy array
	bnez $t9, End_of_Updating_Should_Spawn_Enemy2
	lw $t9, enemy2_spawned
	bnez $t9, End_of_Updating_Should_Spawn_Enemy2
	addi $t9, $zero, 1
	sw $t9, enemy2_spawned # Updating the enemy2_spawned boolean Value to 1
	sw $t9, should_spawn_enemy2 # Updating the should_spawn_enemy2 to 1
	End_of_Updating_Should_Spawn_Enemy2: 
	
	addi $t9, $zero, 0 # $t9 holds the boolean value of whether speed has been updated or not. 
	
	add $t2, $t7, 360
	Move_Enemies_Loop_Head: slt $t8, $t7, $t2
	beqz $t8, Move_Enemies_Loop_End
	
	#Update the enemy_Velocity_ratio whenever player hits another score of 1000
	lw $t5, player_score
	addi $t4, $zero, 1000
	div $t5, $t4
	mfhi $t5
	bnez $t5, End_of_Updating_Velocity_Ratio # Do not Update the Velocity Ratio if player_score is not divisible by 1000
	mflo $t5
	beqz $t5, End_of_Updating_Velocity_Ratio # Do not Update when player_score is zero
	lw $t5, enemy_velocity_ratio
	
	# The Process of updating the enemy_velocity_ratio
	beq $t9, 1, End_of_Updating_Velocity_Ratio # Do not Update when it has already been updated in this round of collision
	beq $t5, 1, End_of_Updating_Velocity_Ratio # Do not update when the ratio is 1(the same speed as refresh rate)
	addi $t5, $t5, -1 # Decreament the Velocity Ratio by 1
	sw $t5, enemy_velocity_ratio
	lw $t5, player_score # Give player bonus points
	addi $t5, $t5, 4
	sw $t5, player_score
	addi $t9, $zero, 1
	sw $zero, enemy_slowed # Change the Enemy Slowed Boolean Value back to zero
	End_of_Updating_Velocity_Ratio: 
	
	lw $t5, player_score
	lw $t4, enemy_velocity_ratio # Using the enemy_velocity_ratio to decide whether we should update the enemy velocity
	
	div $t5, $t4
	mfhi $t5
	bnez $t5, Move_Enemies_Loop_End # Do not update the enemy position if player_score mod enemy_velocity_ratio != 0
	
	lw $t4, player_score # $t4 now holds the player score
	addi $t5, $zero, 50
	div $t4, $t5
	mflo $t4
	
	lw $t4, 0($t7)
	add $t4, $t4, -4 # Moving the Current Enemy Pixel
	sw $t4, 0($t7)
	
	addi $t7, $t7, 8 # Increment to the next pixel
	j Move_Enemies_Loop_Head
	Move_Enemies_Loop_End: 

# This Part of the code is a function called to draw any object onto the screen
Draw: lw $t4, 0($sp) # $t4 is now holding the start of the array indices
addi $sp, $sp, -4 

lw $t3, 0($sp) # $t3 is now holding the size of the array
addi $sp, $sp, -4

addi $t6, $zero, 0 # $t6 now holds the number of pixel level collisions occurred. 
addi $t1, $zero, 1 # $t1 now holds the boolean value of whether collision with Green Powerup occurred. 

add $t7, $t4, $t3
	# Loop Through every entry in the array and draw the color onto the screen accordingly
	Drawing_Loop_Head: slt $t8, $t4, $t7
	beqz $t8 Jump_Out_of_Drawing
	lw $t8, 0($t4)
	addi $t4, $t4, 4
	
	lw $t9, 0($t4)
	addi $t4, $t4, 4
	
	# The following Loop Body Will Check for Collision if object being drawn is the player plane
	beq $t3, 116, Check_Collision_Head
	j End_of_Check_Collision
	Check_Collision_Head: lw $t5, 0($t8) #$t5 now holds the color of the screen before drawing
	# Do not Check Collision if it is any of these Colors
	beq $t5, 0x00008b, End_of_Check_Collision
	beq $t5, 0xffa500, End_of_Check_Collision
	beq $t5, 0x808000, End_of_Check_Collision
	beq $t5, 0xff0000, End_of_Check_Collision
	beq $t5, 0xdd6e0f, End_of_Check_Collision
	beq $t5, 0x850101, End_of_Check_Collision
	
	# If the Color is Pink, We let the Player Regenerate Health
	bne $t5, 0xffc0cb, End_of_Increasing_Player_Health
	# Increase Player Health if player is not full health
	lw $t5, player_health
	beq $t5, 256, End_of_Check_Collision
	addi $t5, $t5, 4
	sw $t5, player_health
	j End_of_Check_Collision
	End_of_Increasing_Player_Health: 
	
	# Decrease Enemy Speed if Color is Green 
	bne $t5, 0x00ff00, End_of_Decreasing_Enemy_Speed
	lw $t5, enemy_slowed
	bnez $t5, End_of_Check_Collision # Check whether enemies have been slowed already
	addi $t5, $zero, 1
	sw $t5, enemy_slowed # Update that enemies have been slowed
	lw $t5, enemy_velocity_ratio
	addi $t5, $t5, 1
	sw $t5, enemy_velocity_ratio
	j End_of_Check_Collision
	End_of_Decreasing_Enemy_Speed: 
	
	# Decrease Player Health
	lw $t5, player_health
	addi $t5, $t5, -4
	sw $t5, player_health
	
	addi $t6, $t6, 1 # Increment the number of collisions Occurred
	End_of_Check_Collision: 
	
	# Depending on how many Collisions Happened, paint the Player Plane in Different Colors Accordingly
	beqz $t6, No_Collision_Detected # Change the Color of the Ship to Red if Collision is detected
	bgt $t6, 6, Severe_Collision
	bgt $t6, 3, Medium_Collision
	bgt $t6, 0, Small_Collision
	
	Small_Collision: li $t9, Deep_Orange_Color
	j No_Collision_Detected
	
	Medium_Collision: li $t9, Red_Color 
	j No_Collision_Detected
	
	Severe_Collision: li $t9, Deep_Red_Color
	j No_Collision_Detected
	
	No_Collision_Detected: 
	
	sw $t9, 0($t8)# Drawing the Color
	
	j Drawing_Loop_Head

	Jump_Out_of_Drawing: jr $ra

# Method for Spawning Enemies
Generate_Enemies: 
	lw $t7, 0($sp)
	addi $sp, $sp, -4 # Taking the Enemy Array from the Stack

	# Reset the Enemies Colors and Locations before Generating new ones
	addi $t3, $zero, 0
	Reset_Enemy_Array_LOOPHEAD: slti $t4, $t3, 360
	beq $t4, $zero, Reset_Enemy_Array_LOOPEND # Exit Condition
	add $t6, $t3, $t7 # Calculate the new Location by adding $t3(Offset) and $t7(Starting Index)
	sw $t0, 0($t6)
	addi $t6, $t6, 4
	li $t5, Dark_Blue_Color
	sw $t5, 0($t6) # Load Dark Blue Color Value into the index
	addi $t6, $t6, 4 # Increment $t3 by 1
	
	addi $t3, $t3, 8
	
	j Reset_Enemy_Array_LOOPHEAD
	Reset_Enemy_Array_LOOPEND: 

	# Generate the Number of Enemies
	li $v0, 42
	li $a0, 0
	li $a1, 3 
	syscall
	
	add $t3, $zero, $a0 # $t3 now holds the number of enemies to generate
	
	#Generate the Random Vertical locations for the Enemies
	addi $t4, $zero, 0 # $t4 now holds the current index of the enemy to generate
	# Loop that loops though each enemy
	Generating_Enemies_Location_Loop_Head: blt $t3, $t4, End_of_Generating_Enemies_Location_Loop # break if $t4 > $t3
	li $v0, 42
	li $a0, 0
	li $a1, 32
	syscall
	add $t2, $zero, $a0 #$t2 now holds the position value of the obstacle
	
	li $v0, 42
	li $a0, 0
	li $a1, 32
	syscall
	add $t8, $zero, $a0 #$t8 now holds the random number to generate a pink powerup
	
	li $v0, 42
	li $a0, 0
	li $a1, 64
	syscall
	add $t9, $zero, $a0 #$t9 now holds the random number to generate a green powerup
	
	
	#
	addi $t5, $zero, 256
	mult $t2, $t5
	mflo $t2 
	addi $t2, $t2, 248 # $t2 now holds the value of the location of this enemy
	add $t2, $t2, $t0 # Offset $t2 to the array
	
	# Input the corresponding information into the enemy array
	addi $t5, $zero, 72
	mult $t4, $t5 
	mflo $t5 
	add $t5, $t5, $t7 # $t5 now holds the pointer to the enemy array in which should be the center of this enemy
	
	# Initializing the Enemy Array
	# Center
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	bne $t8, 16, End_of_Get_Pink_Color # Do not Get the Pink Color if powerup not spawned
	li $t6, Pink_Color
	j End_of_Getting_Deep_Gray_Color
	End_of_Get_Pink_Color: 
	bne $t9, 16, End_of_Get_Green_Color # Do not Get the Green Color if powerup is not spawned
	li $t6, Green_Color
	j End_of_Getting_Deep_Gray_Color
	End_of_Get_Green_Color: 
	li $t6, Deep_Gray_Color # Color
	End_of_Getting_Deep_Gray_Color: 
	sw $t6, 0($t5)
	
	# Top 3
	addi $t2, $t2, -256
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	bne $t8, 16, End_of_Get_Another_Pink_Color
	li $t6, Pink_Color #Pink Color
	j End_of_Getting_Gray_Color
	End_of_Get_Another_Pink_Color: 
	bne $t9, 16, End_of_Get_Another_Green_Color # Green Color
	li $t6, Green_Color
	j End_of_Getting_Gray_Color
	End_of_Get_Another_Green_Color: 
	li $t6, Gray_Color # Gray Color
	End_of_Getting_Gray_Color: 
	sw $t6, 0($t5)
	
	addi $t2, $t2, -4
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	addi $t2, $t2, 8
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	# Middle 2
	addi $t2, $t2, 248
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	addi $t2, $t2, 8
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	# Bottom 3
	addi $t2, $t2, 248
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	addi $t2, $t2, 4
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	addi $t2, $t2, 4
	addi $t5, $t5, 4
	sw $t2, 0($t5) # Location
	addi $t5, $t5, 4
	sw $t6, 0($t5)
	
	#
	addi $t4, $t4, 1
	j Generating_Enemies_Location_Loop_Head
	End_of_Generating_Enemies_Location_Loop: 
	
	End_of_Generating_Enemies: jr $ra

# A for loop used to draw the background for the aircraft
	# It loops value of $t3(serves as an offset) from 0 to 4095, and fills dark blue 
	#color at the $t4 index of the Bitmap Respectively. 
Draw_Background: li $t3, 0 # Set Value for T3
	li $t5, Dark_Blue_Color
	Draw_Background_LOOPHEAD: slti $t4, $t3, 8192
	beq $t4, $zero, Draw_Background_LOOPEND # Exit Condition
	add $t6, $t3, $t0 # Calculate the new Location by adding $t3(Offset) and $t6(Starting Index)
	sw $t5, 0($t6) # Load Dark Blue Color Value into the index
	addi $t3, $t3, 4 # Increment $t3 by 1
	j Draw_Background_LOOPHEAD 
	Draw_Background_LOOPEND: jr $ra

# Method in Charge of Reacting based on Player's Keyboard input in game. 
Get_Key_and_Respond: li $t9, 0xffff0000
	lw $t2, 4($t9) # this assumes $t9 is set to 0xfff0000 from before
	
	# Reset Keyboard input
	addi $t3, $zero, 0
	sw $t3, 4($t9) 
	
	beq $t2, 0x61, move_left # ASCII code of 'a' is 0x61 or 97 in decimal
	beq $t2, 100, move_right
	beq $t2, 119, move_up
	beq $t2, 115, move_down
	beq $t2, 112, main # Restart the program if 'p' was pressed
	
	j End_of_Get_Key_and_Respond # Prevent From Running the following code if 
	#no Key was pressed
	
	# 4 Conditions to move
	move_left: addi $t8, $zero, -4
	j Getting_Key_and_Move_Pushing_to_Stack
	
	move_right: addi $t8, $zero, 4
	j Getting_Key_and_Move_Pushing_to_Stack
	
	move_up: addi $t8, $zero, -256
	j Getting_Key_and_Move_Pushing_to_Stack
	
	move_down: addi $t8, $zero, 256
	j Getting_Key_and_Move_Pushing_to_Stack
	
	# Pushing Current Register Information Onto the Stack
	Getting_Key_and_Move_Pushing_to_Stack: addi $sp, $sp, 4
	sw $ra, 0($sp)
	#Jump
	jal Move_Player
	#Poping $ra back out
	lw $ra, 0($sp)
	addi $sp, $sp, -4
	
	End_of_Get_Key_and_Respond: jr $ra
	
# Method for handling player's movements
Move_Player: 
	la $t7, player_array
	addi $t6, $t7, 116
	
	#Check whether location is out of bounds
	
	#Checking left
	bne $t8, -4, Do_Not_Check_Left
	addi $t1, $zero, 256
	la $t4, player_array
	lw $t4, 0($t4)
	div $t4, $t1
	mfhi $t3
	beqz $t3, End_of_Move_Player_Loop
	Do_Not_Check_Left: 
	
	#Checking right
	bne $t8, 4, Do_Not_Check_Right
	la $t1, player_array # Loading the Front Coordinate of the Plane
	addi $t1,  $t1, 112 # Getting the Front Coordinate by incrementing 112
	lw $t1, 0($t1) # $t1 now has the right most coordinate of the plane
	addi $t1, $t1, 4
	div $t3, $t1, 256
	mfhi $t3
	beqz $t3, End_of_Move_Player_Loop
	Do_Not_Check_Right: 
	
	#Checking up
	bne $t8, -256, Do_Not_Check_Up
	la $t1, player_array # Loading the Top Most Coordinate of the Plane
	addi $t1, $t1, 40 # Getting the Top Coordinate by incrementing 40
	lw $t1, 0($t1) # $t1 now holds the top most coordinate of the plane
	addi $t1, $t1, -256
	bgt $t0, $t1, End_of_Move_Player_Loop
	Do_Not_Check_Up: 
	
	#Checking down
	bne $t8, 256, Do_Not_Check_Down
	la $t1, player_array
	addi $t1, $t1, 80
	lw $t1, 0($t1) # $t1 now holds the bottom most coordinate of the plane
	addi $t1, $t1, 256
	addi $t3, $t0, 8192 # Largest Address of the Screen is stored in $t2
	bgt $t1, $t3, End_of_Move_Player_Loop
	Do_Not_Check_Down: 
	
	#The loop that loops through the player array to move the player
	Move_Player_Loop_Head: slt $t3, $t7, $t6
	beqz $t3, End_of_Move_Player_Loop
	
	# Calculate new Coordinates
	lw $t4, 0($t7)
	add $t4, $t4, $t8
	
	# Update the array with new coordinates
	sw $t4, 0($t7)
	
	addi $t7, $t7, 8
	j Move_Player_Loop_Head
	
	
	
	End_of_Move_Player_Loop: jr $ra
	

	
End_of_Program: 
li $v0, 10 # terminate the program gracefully
syscall
