org 100h
jmp start

;data Segment

;Frequency for beep is 377

speed: dw 70
endingtext_1:	db "               ", 0
endingtext_2:	db "   !GAME IS OVER!   ", 0
endingtext_3:	db "   Better Luck Next Time! :)   ", 0
counters1: dw 500
;buffer: dw 0
counters2: dw 660
speedTicks: dw 0
row: dw 1
col: dw 10
star1: dw 40
star2: dw 122
restorePos: dw 500,498,496,494,492,490
snakePos: dw 500,498,496,494,492,490
PoisonousFlag: dw 0
snakePosRest: times 100 dw 0
snakeLen: dw 6					; 4 at start
head: dw 3						; 3 for right, 5 for up, 1 for left, 2 for down
movSnekCont: dw 0
movSnekFlag: dw 0
gameOver: dw 0
gameOverCount: dw 3
overStr: db 'The Game has been over!'
overStrL: dw 23
overStr2: db 'Press any key to continue!'
overStr2L: dw 26
foodFlag: dw 0
foodPos: dw 0
foodTick: dw 0
PoisonPos: dw 0
min: dw 3
sec: dw 59
hrs: dw 0
tickCount: dw 0
livesCount: dw 3
livesCountMsg: db 'Lives: ',0
livesCountHeart: dw 3
delayCount1: dw 0x8
delayCount2: dw 0x4eff
delayCount3: dw 0x4eff
buffer: times 2000 db 0
screenAttribute: db 0x32
;This Contains Positions at Which Snake Logo is to be Printed 
titleSnake:
		dw 0342, 0341, 0340, 0339, 0338, 0337, 0336, 0335, 0415, 0495
		dw 0575, 0655, 0656, 0657, 0658, 0659, 0660, 0661, 0662, 0742
		dw 0822, 0902, 0982, 0981, 0980, 0979, 0978, 0977, 0976, 0975
		dw 0985, 0905, 0825, 0745, 0665, 0585, 0505, 0425, 0345, 0426
		dw 0507, 0587, 0668, 0669, 0750, 0830, 0911, 0992, 0912, 0832
		dw 0752, 0672, 0592, 0512, 0432, 0352, 0995, 0915, 0835, 0755
		dw 0675, 0595, 0515, 0435, 0355, 0356, 0357, 0358, 0359, 0360
		dw 0361, 0362, 0442, 0522, 0602, 0682, 0762, 0842, 0922, 1002
		dw 0676, 0677, 0678, 0679, 0680, 0681, 0365, 0445, 0525, 0605
		dw 0685, 0765, 0845, 0925, 1005, 0372, 0451, 0530, 0609, 0608
		dw 0687, 0686, 0768, 0769, 0850, 0931, 1012, 0382, 0381, 0380
		dw 0379, 0378, 0377, 0376, 0375, 0455, 0535, 0615, 0695, 0775
		dw 0855, 0935, 1015, 1016, 1017, 1018, 1019, 1020, 1021, 1022
		dw 0696, 0697, 0698, 0699, 0700, 0701, 0702

String1: db "         Made By:", 0
String2: db "       BILAL, AHMAD & ANIQUE.", 0
String3: db "PRESS ANY KEY TO PLAY!", 0
String4: db "                      ", 0
oldTimerIsr: dd 0
oldKbsir: dd 0
score: dw 0
emergency: dw 0
stagetext_0:	db "                    ", 0
stagetext_1:	db "Press 1 for: STAGE-1", 0
stagetext_2:	db "Press 2 for: STAGE-2", 0
stagetext_3:	db "Press 3 for: STAGE-3", 0
heartFlag: dw 0 
HeartPos: dw 0
DragonPos: dw 0
dragonFlag: dw 0
tickforDragon: dw 9
speedTicksDragon: dw 0
stage3Flag: dw 0
directionStars: dw 1 
startsTick: dw 0
labelString: db "LABEL"
labelLength: dw 5
scoreString: db 'Score: ',0
;;hurdles
hudles_position: dw 1214,1278
PoisonTick: dw 0
stage2Flag: db 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;For stages
last_time: dd 0

;Subroutines
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
delay3: pusha
				mov cx, word[delayCount3]
	l19:
				loop l19
				popa 
	ret
DisplayStageSelectionPage: 
			pusha
            call clearScreen

            mov bh, 0x00
			mov bl, 0x20
            looping1:

            mov ax, 0xb800              ;PrintingBackgroundDesign
			mov es, ax
                        
			mov di, 0	
			
            call delay3
			call delay3
        againPrinting11:
            mov [es:di], bx
			add di, 10
			cmp di, 4000			
			jl againPrinting11


            cmp bh, 64
            jl lower1
			je equal1

			lower1:
			add bh, 1
			jmp looping1

			equal1:

			mov ax, 0xb800             ;Making Printing Space for Messages
			mov es, ax

			mov di, 1762
            call delay3
			call delay3
			againPrinting31:
                        mov [es:di], bx
			add di, 2
			cmp di, 2562			
			jl againPrinting31

            mov si, stagetext_0               ;Printing Messages
			mov di, 880 + 32
			call BufferPrintString
			mov si, stagetext_1
			mov di, 960 + 32
			call BufferPrintString
			mov si, stagetext_2
			mov di, 1040 + 32
			call BufferPrintString
			mov si, stagetext_3
			mov di, 1124 + 28
			call BufferPrintString
			call BufferSetter
			popa
			ret
DisplayScore:
				pusha
				mov ax, 0xb800
				mov es, ax


				mov si, 70					;position
				mov bx, scoreString			;offset
				mov ah, 0x07				;attribute
		
		;This prints Score: 
		print2:
				mov al, [bx]
				mov word[es:si], ax
				add bx, 1
				add si, 2
				cmp byte[bx], 0
				jne print2

				mov ax, word[score]
				mov di, 0
				mov bx, 10
		retains5:
				;loop to seperate digits and move them onto stack
		looper7:    mov dx, 0
          		 	div bx  
        	  		add dx, 0x30                ;to make it character
            		push dx
            		add di, 1
            		cmp ax, 0
            		jne looper7

					
					;loop to pop numbers from stack and move to screen
		looper8:	pop ax
           			mov ah, 0x07
          	  		mov [es:si], ax
           			add si, 2
            		sub di, 1
        			cmp di, 0
            		jne looper8
			
				popa
				ret
midi_note_to_freq_table:
			db 014h, 03ah, 015h, 01ah, 0e2h, 0fbh, 060h, 0dfh, 079h, 0c4h, 013h, 0abh, 01bh, 093h, 07bh, 07ch
			db 020h, 067h, 0f8h, 052h, 0f2h, 03fh, 0fdh, 02dh, 00ah, 01dh, 00ah, 00dh, 0f1h, 0fdh, 0b0h, 0efh
			db 03ch, 0e2h, 089h, 0d5h, 08dh, 0c9h, 03dh, 0beh, 090h, 0b3h, 07ch, 0a9h, 0f9h, 09fh, 0feh, 096h
			db 085h, 08eh, 085h, 086h, 0f8h, 07eh, 0d8h, 077h, 01eh, 071h, 0c4h, 06ah, 0c6h, 064h, 01eh, 05fh
			db 0c8h, 059h, 0beh, 054h, 0fch, 04fh, 07fh, 04bh, 042h, 047h, 042h, 043h, 07ch, 03fh, 0ech, 03bh
			db 08fh, 038h, 062h, 035h, 063h, 032h, 08fh, 02fh, 0e4h, 02ch, 05fh, 02ah, 0feh, 027h, 0bfh, 025h
			db 0a1h, 023h, 0a1h, 021h, 0beh, 01fh, 0f6h, 01dh, 047h, 01ch, 0b1h, 01ah, 031h, 019h, 0c7h, 017h
			db 072h, 016h, 02fh, 015h, 0ffh, 013h, 0dfh, 012h, 0d0h, 011h, 0d0h, 010h, 0dfh, 00fh, 0fbh, 00eh
			db 023h, 00eh, 058h, 00dh, 098h, 00ch, 0e3h, 00bh, 039h, 00bh, 097h, 00ah, 0ffh, 009h, 06fh, 009h
			db 0e8h, 008h, 068h, 008h, 0efh, 007h, 07dh, 007h, 011h, 007h, 0ach, 006h, 04ch, 006h, 0f1h, 005h
			db 09ch, 005h, 04bh, 005h, 0ffh, 004h, 0b7h, 004h, 074h, 004h, 034h, 004h, 0f7h, 003h, 0beh, 003h
			db 088h, 003h, 056h, 003h, 026h, 003h, 0f8h, 002h, 0ceh, 002h, 0a5h, 002h, 07fh, 002h, 05bh, 002h
			db 03ah, 002h, 01ah, 002h, 0fbh, 001h, 0dfh, 001h, 0c4h, 001h, 0abh, 001h, 093h, 001h, 07ch, 001h
			db 067h, 001h, 052h, 001h, 03fh, 001h, 02dh, 001h, 01dh, 001h, 00dh, 001h, 0fdh, 000h, 0efh, 000h
			db 0e2h, 000h, 0d5h, 000h, 0c9h, 000h, 0beh, 000h, 0b3h, 000h, 0a9h, 000h, 09fh, 000h, 096h, 000h
			db 08eh, 000h, 086h, 000h, 07eh, 000h, 077h, 000h, 071h, 000h, 06ah, 000h, 064h, 000h, 05fh, 000h

	
mario_music_size: dw 500
	
	; 0~127 -> midi note
	; 254   -> note off
	; 255   -> ignore
mario_music:
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 046h
			db 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 043h, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 04fh, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 047h
			db 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 046h
			db 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 043h, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 04fh, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 047h
			db 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 045h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h
			db 0ffh, 0feh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 054h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 054h, 0ffh, 0feh, 054h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 045h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h
			db 0ffh, 0feh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04bh, 0ffh
			db 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 045h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h
			db 0ffh, 0feh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 054h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 054h, 0ffh, 0feh, 054h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04fh, 0ffh
			db 0feh, 04eh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 04bh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 045h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h
			db 0ffh, 0feh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04bh, 0ffh
			db 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 046h
			db 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 043h, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 04fh, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 047h
			db 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 040h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 046h
			db 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 043h, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 04fh, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 047h
			db 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh
			db 051h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 04fh, 0ffh, 0feh, 0ffh, 04dh, 0ffh, 0feh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04dh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 04ah, 0ffh, 0feh, 0ffh
			db 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh
			db 051h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 04fh, 0ffh, 0feh, 0ffh, 04dh, 0ffh, 0feh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04dh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 04ah, 0ffh, 0feh, 0ffh
			db 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 04ch, 0ffh, 0feh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ah, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 048h, 0ffh, 0feh, 04ch, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 04fh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh
			db 051h, 0ffh, 0feh, 0ffh, 051h, 0ffh, 0feh, 0ffh, 04fh, 0ffh, 0feh, 0ffh, 04dh, 0ffh, 0feh, 0ffh
			db 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 045h, 0ffh, 0feh, 043h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 04ch, 0ffh, 0feh, 048h, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 043h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 044h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh
			db 045h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 04dh, 0ffh, 0feh, 045h, 0ffh, 0feh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 047h, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 0ffh
			db 0ffh, 04dh, 0ffh, 0feh, 04dh, 0ffh, 0feh, 0ffh, 04ch, 0ffh, 0feh, 0ffh, 04ah, 0ffh, 0feh, 0ffh
			db 048h, 0ffh, 0feh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
			db 0ffh, 0ffh, 0ffh, 0ffh, 0ffh, 0ffh
message: db 'Press 1 for STAGE-1..Press 2 for STAGE-2' ; string to be printed
length: dw 40 ; length of string
play_mario:
			mov si, 0
		.next_note:
			mov bh, 0
			mov bl, [mario_music + si]

			cmp bl, 255 ; ignore
			jz .ignore
			cmp bl, 254 ; note off
			jz .note_off
			
		.play_midi_note:
			shl bx, 1
			mov ax, [midi_note_to_freq_table + bx];
			call note_on
			jmp .ignore
			
		.note_off:
			call note_off
		.ignore:
		
		.delay:
			call get_current_time
			cmp eax, [last_time]
			jbe .delay
			mov [last_time], eax
		
			inc si
			cmp si, [mario_music_size]
			jb .next_note
			;cmp word[musicFlag], 1
			;jne .next_note
		.end:
			ret
			
	; ax = 1193180 / frequency		
note_on:
			; change frequency
			mov dx, ax
			mov al, 0b6h
			out 43h, al
			mov ax, dx
			out 42h, al
			mov al, ah
			out 42h, al

			; start the sound
			in al, 61h
			or al, 3h
			out 61h, al
			ret
			
	; stop the sound
note_off:
			in al, 61h
			and al, 0fch
			out 61h, al			
			ret
			
	; count = 1193180 / sampling_rate
	; sampling_rate = 25 cycles per second
	; count = 1193180 / 25 = ba6f (in hex) 
start_fast_clock:
			cli
			mov al, 36h
			out 43h, al
			mov al, 6fh ; low 
			out 40h, al
			mov al, 0bah ; high
			out 40h, al
			sti
			ret

stop_fast_clock:
			cli
			mov al, 36h
			out 43h, al
			mov al, 0h ; low 
			out 40h, al
			mov al, 0h ; high
			out 40h, al
			sti
			ret
			
	; eax = get current time
get_current_time:
			push es
			mov ax, 0
			mov es, ax
			mov eax, [es:46ch]
			pop es
			ret
moveStage3Starts:	pusha

					cmp word[directionStars], 0
					je upward
					jne downward

		downward:	
					mov ax, 0xb800
					mov es, ax

					;Place screen Attribute at old positions
					mov bh, byte[screenAttribute]
					mov bl, ' '
					mov di, word[star1]
					mov si, word[star2]
					mov word[es:si], bx
					mov word[es:di], bx

					;Place starix at new position
					mov bh, 0x07
					mov bl, '*'

					add word[star1], 160
					add word[star2], 160
					mov di, word[star1]
					mov si, word[star2]
					mov word[es:si], bx
					mov word[es:di], bx

					inc word[row]
					cmp word[row], 24
					jne endStage3
					mov word[directionStars], 0 
					jmp endStage3

		upward:	
					mov ax, 0xb800
					mov es, ax

					;Place screen Attribute at old positions
					mov bh, byte[screenAttribute]
					mov bl, ' '
					mov di, word[star1]
					mov si, word[star2]
					mov word[es:si], bx
					mov word[es:di], bx

					;Place starix at new position
					mov bh, 0x07
					mov bl, '*'

					sub word[star1], 160
					sub word[star2], 160
					mov di, word[star1]
					mov si, word[star2]
					mov word[es:si], bx
					mov word[es:di], bx

					dec word[row]
					cmp word[row], 1
					jne endStage3
					mov word[directionStars], 1 
					jmp endStage3

	endStage3:

					popa
					ret
					



;This stage has moving stars in it.
;This stage is no 4 stage
Stage3:				pusha
					call ExtendedBorder
					mov ax, 0xb800
					mov es, ax

					mov ax, 0x2020					;Attribute = Green, VAl = space
					mov si, 640						;first column
					mov di, 638						;last column
					mov cx, 5

		next1:		mov word[es:si], ax
					mov word[es:di], ax
					add si, 160
					add di, 160
					loop next1

					mov si, 2560						;first column
					mov di, 2558						;last column
					mov cx, 5

		next2:		mov word[es:si], ax
					mov word[es:di], ax
					add si, 160
					add di, 160
					loop next2				
					
					popa
					ret

buffer_clear:
			mov bx, 0
		.next:	
			mov byte [buffer + bx], ' '
			inc bx
			cmp bx, 2000
			jnz .next
			ret
clearScreenB:
					pusha
					mov ax, 0xb800
					mov es, ax
					
					cld
					mov di, 0	
					mov ah, 0x07
					mov al, 0x20			;ascii for space
					mov cx, 2000
					rep stosw
			
					popa
					ret
;This subroutine Displays the ending page
DisplayEndingPage:
            call clearScreenB

            mov bh, 0x16
			mov bl, 0x20
        looping:

            mov ax, 0xb800              ;PrintingBackground
			mov es, ax            
			mov di, 0
			call delay2
        againPrinting:
            mov [es:di], bx
			add di, 4
			cmp di, 4000			
			jl againPrinting

			mov ax, 0xb800              ;PrintingBackgroundDesign
			mov es, ax
                                                
			mov di, 0	
            call delay2
			againPrinting1:
            mov [es:di], bx
			add di, 6
			cmp di, 4000			
			jl againPrinting1

                        cmp bh, 64
                        jl lower
			je equal

			lower:
			add bh, 1
			jmp looping

			equal:

			mov ax, 0xb800             ;Making Printing Space for Messages
			mov es, ax

			mov di, 1762
                        call delay2
			againPrinting3:
                        mov [es:di], bx
			add di, 2
			cmp di, 2564			
			jl againPrinting3

                        mov si, endingtext_1                ;Printing Messages
			mov di, 880 + 32
			call BufferPrintString
			mov si, endingtext_2
			mov di, 960 + 32
			call BufferPrintString
			mov si, endingtext_1
			mov di, 1040 + 32
			call BufferPrintString
			mov si, endingtext_3
			mov di, 1120 + 28
			call BufferPrintString
			call BufferSetter
			
			ret

;This Subroutine updates the lives count and restore the timer after the game is over			
BufferPrintString:                           ;Subroutine for Printing
		printAgain:
			mov al, [si]
			cmp al, 0
			jz returnB
			mov byte [buffer + di], al
			inc di
			inc si
			jmp printAgain
		returnB:
			ret

BufferSetter:                                ;Sets Before Printing
			mov ax, 0xb800
			mov es, ax
			mov di, buffer
			mov si, 0
		nextAgain:
			mov bl, [di]
			cmp bl, 8
			jz mover
			cmp bl, 4
			jz mover
			cmp bl, 2
			jz mover
			cmp bl, 1
			jz mover
			jmp writer
		mover:
			mov bl, 219
		writer:
			mov byte [es:si], bl
			inc di
			add si, 2
			cmp si, 4000
			jnz nextAgain
			ret

;Subroutine for Printing of Title Screen Saver
DisplayTitlePage: 
                        call clearScreen

                        mov ax, 0xb800              ;Printing Blue Background
			mov es, ax
					
			cld
			mov di, 0	
			mov ah, 0x16                ;BlueAttribute
			mov al, 0x20			
			mov cx, 2000
			rep stosw

			call BufferSetter
			mov si, 18
                        call delay2 
			mov si, 0
		PrintAgain2:
			mov bx, [titleSnake + si]
			mov byte [buffer + bx], 219
			push si
			call BufferSetter
			mov si, 1
                        call delay2 
			pop si
			add si, 2
			cmp si, 274
			jl PrintAgain2
			mov si, String1
			mov di, 1626
			call BufferPrintString
			mov si, String2
			mov di, 1781
			call BufferPrintString
		KeyWait:
			mov si, String4
			mov di, 1388
			call BufferPrintString
			call BufferSetter
			mov si, 5
                        call delay2
			mov ah, 1
			int 16h
			jnz continueNext
			mov si, String3
			mov di, 1388
			call BufferPrintString
			call BufferSetter
			mov si, 10
                        call delay2
			mov ah, 1
			int 16h
			jz KeyWait

		continueNext:
                        ;mov ah, 0
			;int 16h
			ret
;This subroutine is to produce sound 
sound:				push bp
					mov bp, sp
					push ax
					
					mov     al, 182         ; Prepare the speaker for the
        			out     43h, al         ;  note.
        			mov 	ax, [bp+4]
					;mov     ax, 9121        ; Frequency number (in decimal)
                                			;  for middle C.
        			out     42h, al         ; Output low byte.
        			mov     al, ah          ; Output high byte.
        			out     42h, al 
        			in      al, 61h         ; Turn on note (get value from
                                			;  port 61h).
        			or      al, 00000011b   ; Set bits 1 and 0.
        			out     61h, al         ; Send new value.
        			mov     bx, 2          ; Pause for duration of note.
	.pause1:
       				mov     cx, 65535
	.pause2:
        			dec     cx
        			jne     .pause2
        			dec     bx
        			jne     .pause1
        			in      al, 61h         ; Turn off note (get value from
                                ;  port 61h).
        			and     al, 11111100b   ; Reset bits 1 and 0.
        			out    	61h, al         ; Send new value.
					
					pop ax
					pop 	bp
					ret     2

;This subroutine is used to restore the snake to its default position when it dies
restore:		pusha
				push ds
				push es

				call clearSnake
				push cs
				pop es
				push cs
				pop ds


				mov si, restorePos					;source
				mov di, snakePos					;destination
				mov cx, 6							;count
				mov word[snakeLen], cx
				;mov word[row], 3
				;mov word[col], 10
				mov word[head], 3
				mov word[foodFlag], 0

				rep movsw

				mov ax, 0
				mov cx, 230							;mov 0 to next 230 characters

				rep scasw		
				
				pop es
				pop ds
				popa
				ret

;this subroutine creates the delay
delay1: pusha
				mov cx, word[delayCount1]
	l17:
				call delay2
				loop l17
				popa 
	ret
delay2: pusha
				mov cx, word[delayCount2]
	l18:
				loop l18
				popa 
	ret	
;This method Extend the body of snake by 4 characters
;When snake eats the fruit, it extends its body by 4 characters
ExtendSnake:	
					
					pusha
					pushf
					cli
					mov si, word[snakeLen]
					shl si, 1
					mov bx, snakePos
					mov ax, [bx+si-2]		;last character
					sub ax, 2
					mov word[bx+si], ax
					inc word[snakeLen]
                                        ;inc score
					call moveSnake
					call updateScreen
					popf
					popa
					ret
						
;This method Shows the lives count on the upper right corner of the screen
ShowLives:		
				pusha
				mov cx, livesCount
				mov ax, 0xb800
				mov es, ax

				mov di, 300
				sub di, 160
				mov bx, livesCountMsg
				mov ah, 0x07
				mov si, 0
	nextLives:
				mov al, byte[bx+si]
				cmp al, 0
				je quitLives
				mov word[es:di], ax
				add di, 2
				inc si
				jmp nextLives

			
	quitLives:	mov al, byte[livesCountHeart]
				mov word[es:di], ax
				add di, 2
				mov al, byte[livesCount]
				add al, 48
				mov word[es:di], ax


				popa
				ret
generatePoision:	pusha

					mov ax, 0xb800
					mov es, ax

					mov si,  word[PoisonPos]
					mov al, 0x20
					mov ah, byte[screenAttribute]
					mov word[es:si], ax
		
		genP:
					
					add bx, word[PoisonTick]
					shl bx, 1
					add bx, word[0x0200]
					add bx, si
					add bx, bx
					add bx, bp
					
					mov ax, bx				;random value
					mov bx, 2000			;divisor
					mov dx, 0				;remainder
					div bx					;divisor
					mov di, dx				;remainder in di
					shl di, 1				;MULTIPLY BY 2 

					mov ax, 0xb800			;location
					mov es, ax				;es = 0xb800
					mov al, 5			;food symbol
					mov ah, 0xCD			;attribute
					mov cl, 0x20
					mov ch, byte[screenAttribute]
					;mov di, word[counters1]
					;add word[counters1], 2
					cmp cx, word[es:di]
					jne genP
					
	PassPoison:		
					mov [es:di], ax			;placing at screen
					mov word[PoisonPos], di
	retainPoison:
					
	.exit:			
					popa
					ret



;this Method Displays the clock at upper left corner
displayClock:		pusha
					push es

					mov ax, 0xb800
					mov es, ax

					mov di, 0					;counter
           			mov bx, 10					;divisor
            		mov si, 0					;screen coordinates

					mov ax, word[min]
					cmp ax, 9
					jg looper2
					mov al, '0'
					mov ah, 0x07
					mov word[es:si], ax
					add si, 2
					mov ax, word[min]

					;loop to seperate digits and move them onto stack
		looper2:    mov dx, 0
           		 	div bx  
            		add dx, 0x30                ;to make it character
            		push dx
            		add di, 1
            		cmp ax, 0
            		jne looper2

					;loop to pop numbers from stack and move to screen
		looper3:	pop ax
            		mov ah, 0x07
            		mov [es:si], ax
            		add si, 2
            		sub di, 1
            		cmp di, 0
            		jne looper3			
					
					;placing :
					mov al, ':'
					mov ah, 0x07
					mov word[es:si], ax
					add si, 2

					mov ax, word[sec]
					cmp ax, 9
					jg looper4
					mov al, '0'
					mov ah, 0x07
					mov word[es:si], ax
					add si, 2
					mov ax, word[sec]


						;loop to seperate digits and move them onto stack
		looper4:    mov dx, 0
           		 	div bx  
            		add dx, 0x30                ;to make it character
            		push dx
            		add di, 1
            		cmp ax, 0
            		jne looper4

					;loop to pop numbers from stack and move to screen
		looper5:	pop ax
            		mov ah, 0x07
            		mov [es:si], ax
            		add si, 2
            		sub di, 1
            		cmp di, 0
            		jne looper5

				pop es
				popa
				ret


;ALL the subroutines
;UpdateHead will Update the head
;3 for right
;5 for up
;1 for left
;2 for down
updateHead:			push bp
					mov bp, sp
					pusha

					mov ax, [bp+4]						;value
					mov bx, word[head]					;previous value

					cmp bx, 1							;if previous direction was left
					je one
					cmp bx, 2							;if previous direction was down
					je two
					cmp bx, 3							;if previous direction was right
					je three	
					cmp bx, 5							;if previous direction was up
					je five
					jmp quitHead

	one:			cmp ax, 3							;if left, cannot move right
					je quitHead
					jmp saveHead
	two:			cmp ax, 5							;if down, cannot move up
					je quitHead
					jmp saveHead
	three:			cmp ax, 1							;if right, cannot move left
					je quitHead
					jmp saveHead
	five:			cmp ax, 2							;if up, cannot move down
					je quitHead
					
	saveHead:		mov word[head], ax					;putting direction value in ax

	quitHead:		popa
					pop bp
					ret 2

;Move snake will check the head's direction and will move 1 step according to snekContTime
;it sets inturrupt flag
;wait for movSnekFlag to get on then it moves one step forward and return to main
moveSnake:			pusha
					
					
					call delay1

					mov cx, word[snakeLen]					;length of snake
					
					mov bx, cx
					shl bx, 1								;mul by 2
					sub bx, 2

	;Change Row and Col

					
	;putting space at previous position
					mov ax, 0xb800
					mov es, ax
					mov al, ' '
					mov ah, byte[screenAttribute]
					mov di, word[snakePos+bx]
					mov word[es:di], ax
					
	;move rest of the snake except head
	.again:			
					mov si, word[snakePos+bx-2]
					mov di, si
					mov word[snakePos+bx], di
					sub bx, 2
					jnz .again

					mov di, word[snakePos]
					mov bx, 0
	
	;mov head
	.next:			cmp word[head], 3						;move RIGHT	
					jne .nextCmp
					inc word[col]
					add di, 2								;next position
					mov word[snakePos+bx], di 				;update position
					sub di, 2								;mov to old position 
					jmp .exit

	.nextCmp:		cmp word[head], 5						;move UP
					jne .nextCmp1
					;dec word[row]
					sub di, 160								;next position
					mov word[snakePos+bx], di 				;update position
					add di, 160								;mov to old position 
					jmp .exit

	.nextCmp1:		cmp word[head], 2						;mov DOWN
					jne .nextCmp2
					;inc word[row]
					add di, 160								;next position
					mov word[snakePos+bx], di 				;update position
					sub di, 160								;mov to old position 
					jmp .exit

	.nextCmp2:		cmp word[head], 1
					jne .exit
					dec word[col]
					sub di, 2								;next position
					mov word[snakePos+bx], di 				;update position
					add di, 2								;mov to old position 
					jmp .exit
	.exit:			;call displayClock
					popa
					ret


;This method clears the screen and places snake from snakePos to Video memory
updateScreen:		pusha
					
					call Stage3
					call ShowLives
					call displayClock
					call DisplayScore
					
					cmp word[gameOver], 1
					je gameover
					
					mov ax, 0xb800
					mov es, ax

					mov bx, 0
					mov cx, word[snakeLen]							;length of snake
					mov al, '+'										;head
					mov ah, 0x7F									;attribute
					mov di, word[snakePos+bx]						;head position
					mov [es:di], ax
					mov al, '#'										;rest of snek body
					mov ah, 0xD7
					add bx, 2
					dec cx
	.next:			
					mov di, word[snakePos+bx]
					mov [es:di], ax
					add bx, 2
					loop .next
					jmp exit1

	gameover:		
					call gameOverDisplay



	exit1:			
	stay:	
					popa
					ret

;clear the screen
clearScreen:
					pusha
					mov ax, 0xb800
					mov es, ax
					
					cld
					mov di, 0	
					mov ah, byte[screenAttribute]
					mov al, 0x20			;ascii for space
					mov cx, 2000
					rep stosw
			
					popa
					ret

;This Method is to create border for the game.
;Whenever the snake will touch the border, it will die.
clearSnake:			pusha

					push es

					mov ax, 0xb800
					mov es, ax

			
					mov di, word[snakePos]					;destination
					mov cx, word[snakeLen]		
					mov bx, 2

	l12:			mov al, 0x20
					mov ah, byte[screenAttribute]
					mov word[es:di],  ax
					mov di, word[snakePos+bx]				;postion
					add bx, 2								;next
					loop l12

				pop es
				popa
				ret
isGameOver:			pusha

					mov ax, [snakePos]					;head in ax
					mov cx, [snakeLen]					;length of snake
					
					mov bx, 2
	nextOver:			
					cmp ax, [snakePos+bx]
					je trueOver1
					add bx, 2
					loop nextOver
					
					;here we have to check for borders
					
					mov ax, 0xb800
					mov es, ax
					mov ax, 0x4c20					;borders attribure
					mov di, word[snakePos]
					cmp word[es:di], ax
					je trueOver1
		
		retains4:			
					;here checking for clock and lives and score
					mov ah, 0x07
					mov bx, word[es:di]
					cmp bh, ah
					je trueOver

					;Here we have to check for stars overlapping
					mov bx, 0
					mov cx, word[snakeLen]
		next3:
					mov ax, word[snakePos+bx]
					cmp ax, word[star1]
					je trueOver
					cmp ax, word[star2]
					je trueOver
					add bx, 2
					loop next3
					;jmp nextCmpOver
					;Here i am checking for extra hurdles
					jmp next4
		;Long Jumper
		trueOver1:
					jmp trueOver

		next4:		mov di, word[snakePos]	
					mov ax, 0x872A
					cmp ax, word[es:di]
					jne next5
					mov word[es:di], ax
					jmp trueOver
		next5:
					mov ax, 0x822A
					cmp ax, word[es:di]
					jne next6
					mov word[es:di], ax
					jmp trueOver
		next6:
					mov ax, 0x832A
					cmp ax, word[es:di]
					jne next7
					mov word[es:di], ax
					jmp trueOver			
		next7:			
					mov ax, 0x842A
					cmp ax, word[es:di]
					jne next8
					mov word[es:di], ax
					jmp trueOver
		next8:	
					mov ax, 0x862A	
					cmp ax, word[es:di]
					jne nextCmpOver
					mov word[es:di], ax
					jmp trueOver

					jmp nextCmpOver

	trueOver:		dec word[gameOverCount]
					dec word[livesCount]
					push 558
					call sound
					push 558
					call sound
					push 558
					call sound
					push 558
					call sound
					call restore					;restore the snake to its default pos
					cmp word[stage2Flag], 1
					jne nextCmpOver
					call createHurdles1
                    call createHurdles2
                    call createHurdles3
                    call createHurdles4
                    call createHurdles5

	nextCmpOver:	popa
					ret			
ExtendedBorder:		pusha
					
					mov ax, 0xb800
					mov es, ax

					mov di, 0

					mov al, ' '
					mov ah, 0x4C
					mov cx, 80

					rep stosw						;Horizontal Line at 0th row
				
					mov di, 3840
					mov cx, 80
					rep stosw						;Horizontal Line at 25th row

					mov di, 0
					mov si, 158
					mov cx, 25
		.next:		mov word[es:di], ax				;vertical Line at 0th column
					mov word[es:si], ax				;vertical Line at 79th column
					sub si, 2
					add di, 2
					
					sub si, 2
					add di, 2
				
					add di, 156	
					add si, 164
					dec cx
					jnz .next

								

					popa
					ret

;This method Displays that game is over
gameOverDisplay:	pusha
					push es
					push ds

					call clearScreen
					mov ax, 0xb800
					mov es, ax
					push cs
					pop ds
					mov si, overStr					;String Address
					
					push 0x0D0D						;col = 35, row = 13
					call findPosition
					pop di							;di have position
					mov cx, word[overStrL]			;String Length
					mov ah, 0x07					;attribute
	.next:			mov al, byte[ds:si]
					mov word[es:di], ax
					inc si
					add di, 2
					loop .next

					push 0x1717						;row = 23, col = 35
					call findPosition				
					pop di							;di have position
					mov si, overStr2				;Stirng address
					mov cx, word[overStr2L]			;String Length
	.next1:	
					mov al, byte[ds:si]
					mov word[es:di], ax
					inc si
					add di, 2
					loop .next1
				
					pop ds
					pop es
					popa
					ret
;This subroutine checks if food is eaten by snake or not.
;If food is eaten then foodFlag = 1
;If food is not eaten foodFlag = 0
isFoodEaten:		pusha
					mov ax, word[snakePos]
					cmp ax, word[PoisonPos]
					jne nextFoodCmp
					push 6559
					call sound
					mov word[PoisonPos], 0
					dec word[gameOverCount]
					dec word[livesCount]
					call restore
					jmp exitFood
					;call generatePoision
		
		;checks the HeartFood
		nextFoodCmp:
					mov ax, word[snakePos]
					cmp ax, word[HeartPos]
					jne nextFoodCmp1
					push 422
					call sound
					mov word[HeartPos], 0
					inc word[livesCount]
					inc word[gameOverCount]

					jmp exitFood

		;checks the DragonFood
		nextFoodCmp1:
					mov ax, word[snakePos]
					cmp ax, word[DragonPos]
					jne nextFoodCmp2
					push 644
					call sound
					mov word[DragonPos], 0
					mov word[dragonFlag], 1
                                        add word[score],5
					jmp exitFood	
		
		;Checks the Normal Food
		nextFoodCmp2:
					mov ax, word[snakePos]					;head in ax
					mov dx, word[foodPos]					;position of food		
					
					
					cmp ax, dx
					jne exitFood 
					add word[score], 50			;50 for one eatable
					mov word[foodFlag], 1
					push 1809
					call sound
						
					;generate food if not available
					call ExtendSnake
					call ExtendSnake
					call ExtendSnake
					call ExtendSnake
					
					
					
	exitFood:
	.pass:			popa
					ret
;This subroutine Generates the food at random position on the screen.
;It produces the food if foodflag = 1
generateFood:		pusha
					
					
					pushf 
					
		generateAgain:
					
					add bx, word[foodTick]
					add bx, sp
					shl bx, 1
					add bx, word[PoisonPos]
					add bx, si
					add bx, bx
					add bx, bp
					add bx, [es:di]
					add bx, [0x1222]

					mov ax, bx				;random value
					mov bx, 2000			;divisor
					mov dx, 0				;remainder
					div bx					;divisor
					mov di, dx				;remainder in di
					shl di, 1				;MULTIPLY BY 2 

					mov ax, 0xb800			;location
					mov es, ax				;es = 0xb800
					mov al, 1				;food symbol
					mov ah, 0x67			;attribute
					mov cl, 0x20
					mov ch, byte[screenAttribute]
					cmp cx, word[es:di]
					jne generateAgain
					
	PassFood:		
					mov [es:di], ax			;placing at screen
					mov word[foodPos], di
					
	retainFood:
					popf
					
	.exit:			
					popa
					ret
generateHeart:		pusha		
					
					
		generateHeartAgain:
					
					add bx, word[foodTick]
					shl bx, 2

					mov ax, bx				;random value
					mov bx, 2000			;divisor
					mov dx, 0				;remainder
					div bx					;divisor
					mov di, dx				;remainder in di
					shl di, 1				;MULTIPLY BY 2 

					mov ax, 0xb800			;location
					mov es, ax				;es = 0xb800
					mov al, 3				;food symbol
					mov ah, 0x9C			;attribute
					mov cl, 0x20
					mov ch, byte[screenAttribute]
					mov di, word[counters2]
					add word[counters2], 2
					cmp cx, word[es:di]
					jne generateHeartAgain
					
	PassHeartFood:
					mov [es:di], ax			;placing at screen
					mov word[HeartPos], di
				
					
					
	.exit:			
					popa
					ret

generateDragon:		pusha		
					pushf 
					
					mov si,  word[DragonPos]
					mov al, 0x20
					mov ah, byte[screenAttribute]
					mov word[es:si], ax
		generateDragonAgain:
					
					add bx, word[tickforDragon]
					add bx, sp
					add bx, si
					

					mov ax, bx				;random value
					mov bx, 2000			;divisor
					mov dx, 0				;remainder
					div bx					;divisor
					mov di, dx				;remainder in di
					shl di, 1				;MULTIPLY BY 2 

					mov ax, 0xb800			;location
					mov es, ax				;es = 0xb800
					mov al, 8				;food symbol
					mov ah, 0xA4			;attribute
					mov cl, 0x20
					mov ch, byte[screenAttribute]
					cmp cx, word[es:di]
					jne generateDragonAgain
					
	PassDragonFood:
					mov [es:di], ax			;placing at screen
					mov word[DragonPos], di
				
					
					
	.exit:			popf
					popa
					ret

findPosition:		push bp
					mov bp, sp
					pusha
					mov ax, [bp+4]					;al hav col, ah have row
					mov bl, ah						;bl hav row
					mov bh, 0
					mov ah, 0
					mov dx, 0
					mov ch, 0

					mov cl, 80
					mul cl							;ax have 80* col
					add ax, bx						;ax = (col*80)+row
					shl ax, 1						;ax = (y*80+x)*2
					mov [bp+4], ax
					popa
					pop bp
					
					ret 

GamePlay:			pusha

					;Press any key to begin the game
	.infinite:
					
					call isFoodEaten
					call moveSnake
					;call delay1
					call isGameOver
					call updateScreen
					cmp word[gameOverCount], 0
					jne .infinite
					call DisplayEndingPage
					
					mov ah, 0
					int 16h

					call buffer_clear
					
					call DisplayTitlePage
					call clearScreen
					mov word[emergency], 1
					call generateFood
					mov word[emergency], 0

					mov word[livesCount], 3
					mov word[livesCountHeart], 3
					mov word[gameOverCount], 3
					mov word[sec], 59
					mov word[min], 3
					;call ResotreGameplay
					jmp .infinite
					popa
					ret

timer:				pusha

					add word[tickforDragon], 3
					add word[PoisonTick], 5
					
					cmp word[gameOverCount], 0
					je moveBack
					cmp word[emergency], 1
					jne NotOriginal

	moveBack:		popa
					jmp far[oldTimerIsr]

	NotOriginal:	cmp word[foodFlag], 1
					jne restOfTimer

					mov word[foodFlag], 0
					mov word[emergency], 1
					call generateFood				
					mov word[emergency], 0

	restOfTimer:
					inc word[foodTick]								;for random food generation
					add word[foodTick], bp							;for random food generation
					shl word[foodTick], 1
					
					
					inc word[startsTick]
					cmp word[startsTick], 250
					jne .beforeQuit
					mov word[startsTick], 0
					
					;Controlling the movement of Stars
					cmp word[stage3Flag], 1
					jne .beforeQuit
					call moveStage3Starts


	.beforeQuit:	inc word[tickCount]								;for random food generation
					cmp word[tickCount], 1000 
					je incSec
					jmp quitTimer
					
	incSec:			
	retains3:				
					call displayClock
					;call DisplayScore
					
					;After eating dragon flag
					cmp word[dragonFlag], 1
					jne retains1
					call ExtendSnake
	retains1:
					inc	word[speedTicks]
					cmp word[speedTicks], 6
					jne retains2
					mov word[speedTicks], 0
					;Generating Poison
					
					
	retains2:		inc word[speedTicksDragon]
					cmp word[speedTicksDragon], 20
					jne retains
					mov word[speedTicksDragon], 0
					;Generating Dragon
					mov word[emergency], 1
					call generateDragon
					mov word[emergency], 0
					
					;Generating Poison
					mov word[emergency], 1
					call generatePoision	
					mov word[emergency], 0

					cmp word[delayCount1], 2
					je retains
					dec word[delayCount1]
					
	retains:
					mov word[tickCount], 0							;tickcount will be reset
					dec word[sec]
					cmp word[sec], -1
					je incMin
					jmp quitTimer

	incMin:			;Generating Heart
					mov word[emergency], 1
					call generateHeart					
					mov word[emergency], 0

					mov word[sec], 60								;sec will be reset
					dec word[min]
					cmp word[min], -1 
					je incHrs
					jmp quitTimer

	incHrs:			mov word[gameOverCount], 0
					mov word[min], 0								;min will be reset
					inc word[hrs]
				
	quitTimer:		
					
					mov al, 0x20
					out 0x20, al

					popa
					iret

kbsir:				pusha

					in al, 0x60
					cmp word[gameOverCount], 0
					jne NotOriginalKbsir
					popa
					jmp far[oldKbsir]
	NotOriginalKbsir:


                    cmp al,0x04
                    jne .nextCmp1_
                    mov word[stage3Flag],1				;Enabling Stage 3
	.nextCmp1_: 

                    cmp al,0x03							;Enabling Stage 2
                    jne .nextCmp_
                    mov word[stage2Flag], 1

					call createHurdles1
                    call createHurdles2
                    call createHurdles3
                    call createHurdles4
                    call createHurdles5

	.nextCmp_:
					cmp al, 0x4d		;right Arrow
					jne .nextCmp
					push 3
					call updateHead
					;push 1809
					;call sound
					jmp .exit
	.nextCmp:
					cmp al, 0x4B		;left Arrow
					jne .nextCmp1
					push 1
					call updateHead
					;push 8609
					;call sound
					jmp .exit
	.nextCmp1:				
					cmp al, 0x48		;up Arrow
					jne .nextCmp2
					push 5 
					call updateHead
					;push 4831
					;call sound
					jmp .exit
	.nextCmp2:				
					cmp al, 0x50		;down Arrow
					jne .exit
					push 2
					call updateHead
					;push 3416
					;call sound
					jmp .exit
	.exit:
					mov al, 0x20
					out 0x20, al

					popa
					iret
printLabel:
					push bp
					mov bp, sp
					push es
					push ax
					push cx
					push si
					push di
					mov ax, 0xb800
					mov es, ax ; point es to video base
					mov di, 20 ; point di to top left column
					mov si, [bp+6] ; point si to string
					mov cx, [bp+4] ; load length of string in cx
					mov ah, 0x87 ; normal attribute fixed in al
	nextchar:
					mov al, [si] ; load next char of string
					mov [es:di], ax ; show this char on screen
					add di, 2 ; move to next screen location
					add si, 1 ; move to next char in string
					loop nextchar ; repeat the operation cx times
					pop di
					pop si
					pop cx
					pop ax
					pop es
					pop bp
					ret 4	

createHurdles:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,20
               mov al,0x2A
               mov ah,0x84
               mov di,1200
               mov bx,0
	printHurdles1:                 
               mov word[es:di],ax
               add di,2
               loop printHurdles1
               popa
               ret

createHurdles1:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,31
               mov al,0x2A
               mov ah,0x87
               mov di,2124
               mov bx,0
	printHurdles2:                 
               mov word[es:di],ax
               add di,2
               loop printHurdles2
               popa
               ret

createHurdles2:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,12
               mov al,0x2A
               mov ah,0x82
               mov di,840
               mov bx,0
	printHurdles3:                 
               mov word[es:di],ax
               add di,158
               loop printHurdles3
               popa
               ret
createHurdles3:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,20
               mov al,0x2A
               mov ah,0x83
               mov di,2510
               mov bx,0
	printHurdles4:                 
               mov word[es:di],ax
               add di,162
               loop printHurdles4
               popa
               ret

createHurdles4:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,12
               mov al,0x2A
               mov ah,0x84
               mov di,920
               mov bx,0
	printHurdles5:                 
               mov word[es:di],ax
               add di,162
               loop printHurdles5
               popa
               ret
                           

createHurdles5:
               pusha
               mov ax,0xb800
               mov es,ax
               mov cx,8
               mov al,0x2A
               mov ah,0x86
               mov di,2440
               mov bx,0
		printHurdles6:                 
               mov word[es:di],ax
               add di,158
               loop printHurdles6
               popa
               ret  				


start:			
				call clearScreen
				call DisplayTitlePage
				call buffer_clear
				call DisplayStageSelectionPage	
				call start_fast_clock
				call play_mario
				call stop_fast_clock
				mov ah, 0
				int 16h
				
				mov ah, 0
				int 16h

				mov ax, 1100
				out 0x40, al
				mov al, ah
				out 0x40, al
				
				call clearScreen
				call Stage3
				call generateFood
                call DisplayScore               
				;call generatePoision
				;mov ah, 0
				;int 16h
				xor ax, ax
				mov es, ax

				mov ax, word[es:8*4]
				mov word[oldTimerIsr], ax
				mov ax, word[es:8*4+2]
				mov word[oldTimerIsr+2], ax
				mov ax, word[es:9*4]
				mov word[oldKbsir], ax
				mov ax, word[es:9*4+2]
				mov word[oldKbsir+2], ax

				cli 				    		; disable interrupts
				mov word [es:9*4], kbsir 		; store offset at n*4
				mov [es:9*4+2], cs 				; store segment at n*4+2
            	mov word[es:8*4], timer
				mov [es:8*4+2], cs
				sti


				call GamePlay				

mov ax, 0x4c00
int 21h
