[ORG 0x00]          ; 코드의 시작 어드레스를 0x00으로 설정
[BITS 16]           ; 아래 코드를 16비트 코드로 설정

SECTION .text       ; text 섹션(세그먼트) 정의

mov ax, 0xB800      ; copy 0xB800 to AX register
mov ds, ax          ; copy value(0xB800) in AX to DS (segment register)

mov byte [ 0x00 ], 'M'  ;DS segment: copy "M" to offset 0xB800:0x0000
mov byte [ 0x01 ], 0x4A ;DS segment: copy 0x4A(green prop) to offset 0xB800:0x0001

jmp $               ; 현재 위치에서 무한 루프 실행

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
