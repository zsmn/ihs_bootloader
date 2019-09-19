[bits 16]
[org 0x7c00]

jmp kernel_start ; jump para a label kernel_start

; sei la /*

gdt_start: ; inicio da declaracao do gdt

gdt_null:
    dd 0x0
    dd 0x0

gdt_code:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10011010b
    db 11001111b
    db 0x0

gdt_data:
    dw 0xffff
    dw 0x0
    db 0x0
    db 10010010b
    db 11001111b
    db 0x0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start ; descritor para todo o segmento
    dd gdt_start ; declarando o inicio

CODE_SEG equ gdt_code - gdt_start ; segmento de codigo (code - start)
DATA_SEG equ gdt_data - gdt_start ; segmento de dados (data - start)

; */ sei la

print:
    pusha ; pega os registradores ax, bx, cx, dx, sp, bp, si, di e coloca na pila
    mov ah, 0x0e ; printar modo normal
    mov bh, 0 ; seila
.loop:
    lodsb ; carrega de si
    cmp al, 0 ; compara com 0 (fim da str)
    je .done ; se for, vai pra done
    int 0x10 ; chama a interrupção da bios para desenhar na tela
    jmp .loop ; volta pra o loop
.done:
    popa ; recupera os registradores ax, bx, cx, dx, sp, bp, si, di na pilha
    ret

str16 db 'oi! to no 16bits', 0
str32 db 'oi! to no 32bits', 0

kernel_start:
    mov ax, 0
    mov ss, ax ; inicio do segmento
    mov sp, 0xFFFC ; fim do segmento

    mov ax, 0 ; sei la
    mov ds, ax ; sei la
    mov es, ax ; sei la
    mov fs, ax ; sei la
    mov gs, ax ; sei la

    mov si, str16 ; move a string para si
    call print ; chama a label para printar a string

    cli ; sei la
    lgdt[gdt_descriptor] ; sei la
    mov eax, cr0 ; sei la
    or eax, 0x1 ; sei la
    mov cr0, eax ; sei la
    jmp CODE_SEG:b32 ; sei la

[bits 32]

VIDEO_MEMORY equ 0x0b85a0 ; endereço base da memoria de video

print32:
    pusha ; move os registradores ax, bx, cx, dx, sp, bp, si, di para a pilha
    mov edx, VIDEO_MEMORY
.loop:
    mov al, [ebx] ; move o byte atual da string para al
    mov ah, 0x0f ; cor branca
    cmp al, 0 ; ve se chegou no fim da string
    je .done  ; jump pra done se chegou
    mov [edx], ax ; move ax para o byte atual da string em edx
    add ebx, 1 ; anda um byte na string
    add edx, 2 ; andar no endereço base do modo de video
    jmp .loop
.done:
    popa ; volta os registradores ax, bx, cx, dx, sp, bp, si, di da pilha
    ret

b32:
    mov ax, DATA_SEG ; sei la
    mov ds, ax ; sei la
    mov es, ax ; sei la
    mov fs, ax ; sei la
    mov gs, ax ; sei la
    mov ss, ax ; sei la

    mov ebp, 0x2000 ; sei la
    mov esp, ebp ; sei la

    mov ebx, str32 ; move a string para ebx
    call print32 ; chama a label para printar a string

    jmp $

[SECTION signature start=0x7dfe] ; sei la
dw 0AA55h ; sei la
