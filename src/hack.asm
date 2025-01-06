.psx

.open "../build/SLPS_006_VANILLA.30", "../build/SLPS_006.30", 0x800C0000-0x800


; these areas are places in RAM, past the end of the SLPS file (at 0x925D0 in HxD/0x151D70 in debugger), where the game doesn't appear to employ these RAM spaces. if things start crashing, check these areas first to see if the game is overwriting them
; remember that the game seemingly loads ROM into RAM at first, then may freely overwrite it later 

AREA1 equ 0x80153700
AREA2 equ 0x80153730
AREA3 equ 0x80153780
AREA4 equ 0x80154300
AREA5 equ 0x80154150
AREA6 equ 0x80154380
; 1543F0 starts area where Forte battle uses RAM

ID_INTRO equ 0x00
ID_FROST equ 0x01
ID_CLOWN equ 0x02
ID_TENGU equ 0x03
ID_GRENADE equ 0x04
ID_SWORD equ 0x05
ID_AQUA equ 0x06
ID_ASTRO equ 0x07
ID_SEARCH equ 0x08
ID_DUO equ 0x09
ID_WILY equ 0x0A



; at 001B...
RM_GET_MEGA_BALL equ 0x1304
RM_DEFEATED_GRENADE equ 0x1308
RM_DEFEATED_CLOWN equ 0x130C
RM_DEFEATED_FROST equ 0x1310
RM_DEFEATED_TENGU equ 0x1314
RM_DEFEATED_AQUA equ 0x1318
RM_DEFEATED_SWORD equ 0x131C
RM_DEFEATED_SEARCH equ 0x1320
RM_DEFEATED_ASTRO equ 0x1324

;0016
HYPER_SLIDER equ 0xC746 
RUSH_BIKE equ 0xC754
RUSH_QUESTION equ 0xC755
RUSH_BOMBER equ 0xC756
RUSH_CHARGER equ 0xC757

; Macros for replacing existing code and then jumping back to cave org
.macro replace,dest
	.org dest
.endmacro
.macro endreplace,nextlabel
	.org org(nextlabel)
.endmacro

; Stack macros
.macro push,reg
	addiu sp,sp,-4
	sw reg,(sp)
.endmacro
.macro pop,reg
	lw reg,(sp)
	addiu sp,sp,4
.endmacro

; new macro
.macro addw,address
    ori v1,$zero, 0x0001
    lui at, 0x801B
    sb v1, address(at)
.endmacro
.macro remw,address
    ori v1,$zero, 0x0000
    lui at, 0x801B
    sb v1, address(at)
.endmacro

;slider is actually always setting 0x04 for exit part functionality
.macro addslider
    push at
    push v1
    lui at, 0x8017
    ori v1,$zero, 0x000F
    sb v1, HYPER_SLIDER(at)
    pop v1
    pop at
.endmacro
.macro removeslider
    push at
    push v1
    lui at, 0x8017
    ori v1,$zero, 0x0004
    sb v1, HYPER_SLIDER(at)
    pop v1
    pop at
.endmacro


.macro addrush,address
    lui at, 0x8017
    ori v1,$zero, 0x0001
    sb v1, address(at)
.endmacro
.macro removerush,address
    lui at, 0x8017
    ori v1,$zero, 0x0000
    sb v1, address(at)
.endmacro



.macro setpostduo
lui at, 0x801c
ori v0,$zero, 0x0005
sb v0, 0x27c0(at)
.endmacro

.macro setatduo
lui at, 0x801c
ori v0,$zero, 0x0003
sb v0, 0x27c0(at)
.endmacro

@inf_hp:
replace 0x8010742C
nop
endreplace @inf_hp

@inf_lives:
replace 0x80101098
nop
endreplace @inf_lives

@always_exit:
replace 0x80112970
lbu t1,0x01

endreplace @always_exit

; this skips checking if the boss is completed or not
@allow_exit_hook:
replace 0x80113654
j AREA4
nop
endreplace @allow_exit_hook

@allow_exit_return:
replace AREA4
setpostduo
remw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
remw RM_DEFEATED_FROST
remw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j 0x8011368C
nop
endreplace @allow_exit_return


@skip_rm_intro:
replace 0x800FFE0C
j 0x800FFE20
endreplace @skip_rm_intro


@skip_weapon_get:
replace 0x80101338
j 0x80101370
endreplace @skip_weapon_get






@allow_leaving_duo_stage:
replace 0x80113680
nop
endreplace @allow_leaving_duo_stage

@allow_leaving_wily_stage_hook:
replace 0x80113668
j AREA2
nop
endreplace @allow_leaving_wily_stage_hook

@allow_leaving_wily_stage_return:
replace AREA2
; this extra code ensures that wily 4 doesn't load the credits
lui at, 0x801c
ori v0,$zero, 0x0000
sb v0, 0x27c2(at)
; jump back to regular stage select
j 0x80113654
endreplace @allow_leaving_wily_stage_return


@disable_wily_stage_increment_on_exit:
replace 0x801014CC
nop
endreplace @go_to_stage_select_on_game_start



@disallow_duo_stage_fmv:
replace 0x80100AF4
nop
endreplace @disallow_duo_stage_fmv


@stage_select_allow_second_page_hook:
replace 0x80100A98
j AREA1
endreplace @stage_select_allow_second_page_hook


@stage_select_allow_second_page_return:
replace AREA1
addw RM_GET_MEGA_BALL
setpostduo
ori v0,$zero, 0x0002
j 0x80100A9C
nop
endreplace @stage_select_allow_second_page_return



@go_to_stage_select_on_game_start:
replace 0x80100AF0
j 0x80100B88
nop
endreplace @go_to_stage_select_on_game_start


@stage_hook:
replace 0x800FFD44
j AREA3
nop
endreplace @stage_hook

@stage_return:
replace AREA3

push t1
push t2
push at

; check if select is held, used for stage part 1 or 2
lui at, 0x801C
lbu t1,0x7572
ori t2, $zero, 0xFE
beq t1,t2,@@set_stage_part2
nop
; if select not set, force to 0x00
ori v1,$zero, 0x00
sb v1, 0x27C8(at)
j @@continue_stage1
nop

; if select set, force to 0x01
@@set_stage_part2:
ori v1,$zero, 0x01
sb v1, 0x27C8(at)

@@continue_stage1:

; set up loadout
lui at, 0x8017
lbu t2, 0xF9A4(at)

; set up button check
lui at, 0x801C
lbu t1,0x7573

; loadout
ori v1,$zero, ID_INTRO
beq t2,v1,@@setup_intro
nop
ori v1,$zero, ID_GRENADE
beq t2,v1,@@setup_grenade
nop
ori v1,$zero, ID_CLOWN
beq t2,v1,@@setup_clown
nop
ori v1,$zero, ID_DUO
beq t2,v1,@@setup_duo
nop
ori v1,$zero, ID_FROST
beq t2,v1,@@setup_frost
nop
ori v1,$zero, ID_TENGU
beq t2,v1,@@setup_tengu
nop
ori v1,$zero, ID_AQUA
beq t2,v1,@@setup_aqua
nop
ori v1,$zero, ID_SWORD
beq t2,v1,@@setup_sword
nop
ori v1,$zero, ID_SEARCH
beq t2,v1,@@setup_search
nop
ori v1,$zero, ID_ASTRO
beq t2,v1,@@setup_astro
nop
ori v1,$zero, ID_WILY
beq t2,v1,@@setup_wily
nop
j @@start_wily_button_checks ; fail case
nop


;intro
@@setup_intro:
removeslider
removerush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
remw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
remw RM_DEFEATED_FROST
remw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;grenade
@@setup_grenade:
removeslider
removerush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
remw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
remw RM_DEFEATED_FROST
remw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;clown
@@setup_clown:
removeslider
addrush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;frost
@@setup_frost:
removeslider
addrush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
remw RM_DEFEATED_FROST
remw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;tengu
@@setup_tengu:
removeslider
addrush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
remw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;duo
@@setup_duo:
; setatduo
removeslider
addrush RUSH_BIKE
removerush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
remw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;aqua
@@setup_aqua:
addslider
addrush RUSH_BIKE
addrush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
addw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
addw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;sword
@@setup_sword:
addslider
addrush RUSH_BIKE
addrush RUSH_QUESTION
removerush RUSH_BOMBER
addrush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
addw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
addw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
addw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;search
@@setup_search:
addslider
addrush RUSH_BIKE
addrush RUSH_QUESTION
addrush RUSH_BOMBER
addrush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
addw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
addw RM_DEFEATED_AQUA
addw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
addw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;astro
@@setup_astro:
addslider
addrush RUSH_BIKE
addrush RUSH_QUESTION
removerush RUSH_BOMBER
removerush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
addw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
remw RM_DEFEATED_AQUA
remw RM_DEFEATED_SWORD
remw RM_DEFEATED_SEARCH
remw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop
;wily
@@setup_wily:
addslider
addrush RUSH_BIKE
addrush RUSH_QUESTION
addrush RUSH_BOMBER
addrush RUSH_CHARGER
addw RM_DEFEATED_GRENADE
addw RM_DEFEATED_CLOWN
addw RM_DEFEATED_FROST
addw RM_DEFEATED_TENGU
addw RM_DEFEATED_AQUA
addw RM_DEFEATED_SWORD
addw RM_DEFEATED_SEARCH
addw RM_DEFEATED_ASTRO
j @@start_wily_button_checks
nop



@@start_wily_button_checks:
; wily stage button check
ori v1,$zero, 0x00D7
beq t1,v1,@@press_L1 ; Check if pressing R1 - wily 2
ori v1,$zero, 0x00DE
beq t1,v1,@@press_R1 ; Check if pressing L2 - wily 3
ori v1,$zero, 0x00DD
beq t1,v1,@@press_R2 ; Check if pressing R2 - wily 4
nop
ori v1, $zero, 0x0000
j @@stage_finish
nop
@@press_L1:
ori v1, $zero, 0x0001
j @@stage_finish
nop
@@press_R1:
ori v1, $zero, 0x0002
j @@stage_finish
nop
@@press_R2:
ori v1, $zero, 0x0003


@@stage_finish:
lui at, 0x801C
sb v1, 0x27C1(at)
lui at, 0x801C
; return
pop at
pop t2
pop t1

    lbu v1, 0x4(s0)
nop
sltiu a2, v1, 10
j 0x800FFD4C
nop

endreplace @stage_return





@button_checks_hook:
replace 0x8011554C
j AREA5
nop
endreplace @button_checks_hook

@button_checks_return:
replace AREA5

push t1
push v0
push v1

lui at, 0x801C
lbu t1,0x7572
; first check 

ori v1,$zero, 0x00EE
beq t1,v1,@@press_select_and_up ; check for select and up
nop
ori v1,$zero, 0x00FE
beq t1,v1,@@press_select ; check for select
nop
j @@finish_hp_hook

@@press_select_and_up:
ori v0,$zero, 0x0004
j @@continue_select_hack
nop
@@press_select:
ori v0,$zero, 0x0000
@@continue_select_hack:
lbu t1,0x7573
ori v1,$zero, 0x007F
beq t1,v1,@@press_select_and_square ; check for select + square
nop
ori v1,$zero, 0x00EF
beq t1,v1,@@press_select_and_triangle ; check for select + triangle
nop
ori v1,$zero, 0x00BF
beq t1,v1,@@press_select_and_cross ; check for select + cross
nop
ori v1,$zero, 0x00DF
beq t1,v1,@@press_select_and_circle ; check for select + circle
nop
ori v1,$zero, 0x00FB
beq t1,v1,@@press_select_and_L1 ; check for select + L1
nop
ori v1,$zero, 0x00F7
beq t1,v1,@@press_select_and_R1 ; check for select + R1
nop
ori v1,$zero, 0x00FE
beq t1,v1,@@press_select_and_L2 ; check for select + L2
nop
ori v1,$zero, 0x00FD
beq t1,v1,@@press_select_and_R2 ; check for select + R2
nop
j @@finish_hp_hook
nop

; heal
@@press_select_and_square:
ori v1,$zero, 0x0028
lui at, 0x8016
sb v1, 0xD6D7(at)
j @@finish_hp_hook
nop

; instant death
@@press_select_and_triangle:
ori v1,$zero, 0x0000
lui at, 0x8016
sb v1, 0xD6D7(at)
j @@finish_hp_hook
nop

; instant death + reload stage
@@press_select_and_cross:
; set hp to zero
ori v1,$zero, 0x0000
lui at, 0x8016
sb v1, 0xD6D7(at)
; set lives to zero
ori v1,$zero, 0x0000
lui at, 0x801C
sb v1, 0x27C4(at)

j @@finish_hp_hook
nop

; boss hp to 1
@@press_select_and_circle:
ori v1,$zero, 0x0001
lui at, 0x8016
sb v1, 0xA60F(at)
j @@finish_hp_hook
nop

; set checkpoint 0
@@press_select_and_L1:
ori v1,$zero, 0x0000
j @@set_checkpoint
nop

; set checkpoint 1
@@press_select_and_R1:
ori v1,$zero, 0x0001
j @@set_checkpoint
nop

; set checkpoint 2
@@press_select_and_L2:
ori v1,$zero, 0x0002
j @@set_checkpoint
nop

; set checkpoint 3
@@press_select_and_R2:
ori v1,$zero, 0x0003
j @@set_checkpoint
nop

@@set_checkpoint:
add v1, v0, v1 ; this will add 0x04 depending if up was pressed
lui at, 0x801C
sb v1, 0x27C5(at)
j @@finish_hp_hook
nop


@@finish_hp_hook:
pop v1
pop v0
pop t1
; return
lbu a0, -0x2929(a0)
lui at, 0x801c
j 0x80115554
nop
endreplace @button_checks_return



@set_capsule_respawn_x_coord_hook:
replace 0x80134674
j AREA6
nop
endreplace @set_capsule_respawn_x_coord_hook

@set_capsule_respawn_x_coord_return:
replace AREA6
; this code conveniently uses the function to reset the capsules to never respawn
lui at, 0x801C
ori v0,$zero, 0x00
sb v0, 0x27CC(at)
lhu v0, 0x0(s1)
lui at, 0x8016
slti v0, v0, 0x0600 
beq v0,$zero,@@set_rockman_right_side

; left side
ori v0,$zero, 0x0590
j @@finish_rockman_capsule_x
nop

; right side
@@set_rockman_right_side:
ori v0,$zero, 0x0652
j @@finish_rockman_capsule_x
nop

@@finish_rockman_capsule_x:


j 0x8013467C
nop
endreplace @set_capsule_respawn_x_coord_return


@set_capsule_respawn_y_coord:
replace 0x8013469C
ori v0,$zero, 0x0E79
endreplace @set_capsule_respawn_y_coord


@disable_stage_part_set_to_zero:
replace 0x80100BD8
nop
endreplace @disable_stage_part_set_to_zero

.close
