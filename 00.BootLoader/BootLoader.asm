[ORG 0x00]          ; 코드의 시작 어드레스를 0x00으로 설정
[BITS 16]           ; 아래 코드를 16비트 코드로 설정

SECTION .text       ; text 섹션(세그먼트) 정의

jmp 0x07C0:START    ; copy 0x07C0 to CS segment register + move to START label

START:
    mov ax, 0x07C0  ; change the segment register's value to bootLoader's starting value (0x7C00)
    mov ds, ax      ; copy value in AX to DS (segment register)
    mov ax, 0xB800  ; change the vid mem start add(0xB800) to segment register value
    mov es, ax      ; set es segment register

    mov si, 0       ; reset SI register(String Index register)

.SCREENCLEARLOOP:           ; clears the screen
    mov byte [ es:si ], 0  ; copy 0 to where 'vid mom text' is located (deletes text)
    mov byte [ es:si+1 ], 0x06  ; copy 0x06(yellow) 0x0A(bright green) to where 'vid mem prop' is located

    add si, 2                   ; we are done setting text and props, move on

    cmp si, 80*25*2 ; screen's dimension

    jl .SCREENCLEARLOOP ; If SI register is less than 80*25*2, there exists uncleared bits
                        ; jump to screenclearloop to clear the screen
    mov si,0    ;reset SI register (String Source Index)
    mov di, 0   ;reset DI register (String Destination Index)

.MESSAGELOOP:   ; loop that prints messages
    mov cl, byte [ si+MESSAGE1 ] ;copy the value at address siAddress+MESSAGEAddress to cl
                                ;cl register - last 1byte of CX register
    cmp cl, 0
    je .MESSAGEEND  ; if cl==0 then jump to .MESSAGEEND (this terminates the program)

    mov byte [ es:di ],cl ;if cl!=0, print the text to 0xB800:di (vid mem address)

    add si,1    ;add 1 to SI register -> move to next string
    add di, 2   ; add 2 to DI register -> move to next character in vid mem
                ; vid mem has (char, prop) pair, thus, to print a char you need to add 2
    jmp .MESSAGELOOP    ;print the next char by going to .MESSAGELOOP

.MESSAGEEND:

    jmp $   ;infinite loop

MESSAGE1:   db 'Jeeheon MINT64 OS Boot Loader Starts...', 0; define a string to print
            ; we define the last char as 0 so that .MESSAGELOOP knows that the string ended

times 510 - ( $ - $$ )  db  0x00    ; $: 현재 라인의 어드레스
                                    ; $$: 현재 섹션(.text)의 시작 어드레스
                                    ; $ - $$: 현재 섹션을 기준으로 하는 오프셋
                                    ; 510 - ( $ - $$ ): 현재부터 어드레스 510까지
                                    ; db 0x00: 1바이트를 선언하고 값은 0x00
                                    ; time: 반복 수행
                                    ; 현재 위치에서 어드레스 510까지 0x00으로 채움

db 0x55             ; 1바이트를 선언하고 값은 0x55
db 0xAA             ; 1바이트를 선언하고 값은 0xAA
                    ; 어드레스 511, 512에 0x55, 0xAA를 써서 부트 섹터로 표기함
