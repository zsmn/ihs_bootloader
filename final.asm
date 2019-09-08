;Jogo da Velha: ULTRA
org 0x7E00
jmp 0x0000:start
 
data:
    mostra db "SISTEMA DE REGISTRO DE CONTAS BANCARIAS", 13
    instr1 db "Nome (20 caracteres) --- CPF (11 caracteres) --- Conta Bancaria (6 caracteres)", 13
    registro_nome dw "000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", 13
    registro_cpf dw "0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", 13
    registro_cc dw "00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000", 13
    mostrapergunta db "Qual operacao voce deseja realizar?", 13
    mostrapergunta1 db "1 - Cadastro", 13
    mostrapergunta2 db "2 - Busca Cadastro", 13
    mostrapergunta3 db "3 - Editar Conta", 13
    mostrapergunta4 db "4 - Deletar Conta", 13
    mostrapergunta5 db "5 - Sair", 13
    agradecimento db "Obrigado por usar nosso servico!", 13
    naoachei db "Nao achei man", 13
    cad db "Cadastro:",13
    nome db "12345678901234567890", 13
    cpf db "12345678901", 13
    cc db "123456", 13
    mostranome db "Digite o seu nome:", 13
    mostracpf db "Digite o seu cpf:", 13
    mostracb db "Digite o numero da conta bancaria:", 13
    instrucao db "                                      " ,13,0
    ;tami db 0
    ocup db '000000000000000000000',13
    index db 0;
    inicio dw 0
    limite_at db 0
    variavel_comparadora dw 0
    variavel_auxiliar_al db 0
    variavel_auxiliar dw 0
    flag_comparacao db 0
    index_aux dw 0
    opcao db 0

start:
    call limparTela
    call telaInicial
 
    jmp exit

limparTela:
    ; Modo vídeo.
    mov ah, 0
    mov al, 12h
    int 10h

    ret

getchar:
    mov ah, 0
    int 16h
    ret
 
putchar:
    mov ah, 0xe
    mov bx, 0x7
    mov bh, 0
    int 10h
    ret
 
telaInicial:
    .loop_infinito: ;loop que so termina quando o usuario digita 5 para poder sair do programa
        ; chamar o modo video para limpar a tela

        mov byte[opcao], 0

        mov ah, 0
        mov al, 12h
        int 10h
 
        mov si, mostrapergunta
        mov dh, 00h
        mov dl, 00h
        call printarString
 
        mov si, mostrapergunta1
        mov dh, 01h
        mov dl, 00h
        call printarString
 
        mov si, mostrapergunta2
        mov dh, 02h
        mov dl, 00h
        call printarString
 
        mov si, mostrapergunta3
        mov dh, 03h
        mov dl, 00h
        call printarString
 
        mov si, mostrapergunta4
        mov dh, 04h
        mov dl, 00h
        call printarString
 
        mov si, mostrapergunta5
        mov dh, 05h
        mov dl, 00h
        call printarString
        mov si, instrucao
        mov dh, 06h
        mov dl, 00h
        call printarString
        call getchar
        cmp al, '1'
        je cadastro
        cmp al, '2'
        je busca
        cmp al, '3'
        je editar
        cmp al, '4'
        je deletar
        cmp al, '5'
        je sair
        call putchar
        call getchar
        cmp al, 13
        jmp .loop_infinito
 
delchar:
  mov al, 0x08          ; backspace
  call putchar
  mov al, ' '
  call putchar
  mov al, 0x08          ; backspace
  call putchar
  ret

getstring:
    mov word[inicio], si
    loop12:
        call getchar
        cmp al, 0x08
        je .backspace
        cmp al, 13
        je .mover_char
        cmp byte[limite_at], 0
        je loop12
        dec byte[limite_at]
        call putchar
        .mover_char:
        mov byte[si], al
        inc si
        cmp al, 13
        je finale
    jmp loop12
    .backspace:
        cmp si, word[inicio]
        je loop12
        dec si
        inc byte[limite_at]
        mov byte[si], 0
        call delchar
    jmp loop12
 
    finale:
    ret
 
val_index:
    mov byte[index], cl
    dec si;
    mov byte[si], '1';
    ret

 find_ind:
    lodsb;
    cmp al,'0';
    je retornar; salvar no index
    inc cl
    cmp cl, 21
    je retornar
    jmp find_ind;
    retornar:
        call val_index;
        ret;
    
cadastro:
    xor cx,cx
    mov si, ocup;
    call find_ind ;encontrar o indice que eu procuro
    
    cmp byte[index], 21
    je telaInicial

    call limparTela
    ;mostrar ocup
    mov si, ocup;
    mov dh, 10h
    mov dl, 00h;
    call printarString
    
    mov si, cad
    mov dh, 00h
    mov dl, 00h
    call printarString
    mov dh, 01h
    mov dl, 00h
    mov si, instr1
    call printarString
    ;movendo o ponteiro si para a string nome
   
    mov si, instrucao
    mov dh, 02h
    mov dl, 00h
    call printarString
    
    call pegar

    mov si, instrucao
    mov dh, 02h
    mov dl, 00h
    call printarString
    
    call printarAtributos

    call getchar
    jmp telaInicial

pegar:
    mov byte[limite_at], 21 ; calculo do offset
    call calcularOffset
    add si, registro_nome

    ;mov si, nome
    mov byte[limite_at], 20
    call getstring
 
    mov si, instrucao
    mov dh, 02h
    mov dl, 00h
    call printarString
 
    mov byte[limite_at], 12 ; calculo do offset
    call calcularOffset
    add si, registro_cpf
    ;mov si, cpf
    mov byte[limite_at], 11
    call getstring
 
    mov si, instrucao
    mov dh, 02h
    mov dl, 00h
    call printarString
 
    mov byte[limite_at], 7 ; calculo do offset
    call calcularOffset
    add si, registro_cc
    ;mov si, cc
    mov byte[limite_at], 6
    call getstring

    ret

printarAtributos:
    mov byte[limite_at], 21 ; calculo do offset
    call calcularOffset
    add si, registro_nome
    ;mov si, nome
    mov dh, 2h
    mov dl, 00h
    call printarString
 
    mov byte[limite_at], 12 ; calculo do offset
    call calcularOffset
    add si, registro_cpf
    ;mov si, cpf
    mov dh, 3h
    mov dl, 00h
    call printarString
 
    mov byte[limite_at], 7 ; calculo do offset
    call calcularOffset
    add si, registro_cc
    ;mov si, cc
    mov dh, 4h
    mov dl, 00h
    call printarString

    ret

calcularOffset: ; calculando offset com o valor salvo em index
    xor ax, ax
    mov al, byte[index]

    mul byte[limite_at] ; offset esta salvo em al
    mov si, ax
    ret

busca:
    call limparTela
    
    mov byte[opcao], 1
    
    jmp deletar
    
editar:
    call limparTela
    mov byte[opcao], 2
    jmp deletar

sair:
    call limparTela

    mov si, agradecimento
    mov dh, 00h
    mov dl, 00h
    call printarString

    call getchar

    jmp exit

deletar:
    call limparTela

    mov si, mostracpf
    mov dh, 00h
    mov dl, 00h
    call printarString

    mov si, instrucao
    mov dh, 02h
    mov dl, 00h
    call printarString

    mov si, cpf
    mov byte[limite_at], 11
    call getstring

    mov byte[limite_at], 12
    mov byte[index], 0

    .loop1:
        mov si, ocup
        xor cx, cx
        mov cl, byte[index]
        add si, cx
        lodsb
        cmp al, '0'
        je .incrementar_index
        mov byte[flag_comparacao], 1
        mov word[variavel_comparadora], cpf
        call calcularOffset
        add si, registro_cpf
        .loop2:
            lodsb
            mov byte[variavel_auxiliar_al], al
            mov word[variavel_auxiliar], si
            mov si, word[variavel_comparadora]
            lodsb
            cmp al, 13 ; fim
            je .end_loop2
            cmp al, byte[variavel_auxiliar_al]
            jne .zerar_var
            mov si, word[variavel_auxiliar]
            inc word[variavel_comparadora]
        jmp .loop2
        .end_loop2:
        cmp byte[flag_comparacao], 1
        je .zerar_flag
        .incrementar_index:
        inc byte[index]
        cmp byte[index], 21
        je .saida ;falta
    jmp .loop1

    .zerar_var:
        mov byte[flag_comparacao], 0
        jmp .end_loop2

    .saida:
        mov si, naoachei
        mov dh, 03h
        mov dl, 00h
        call printarString
        call getchar
        jmp telaInicial
 
    .zerar_flag:
        cmp byte[opcao], 1
        je .op1
        cmp byte[opcao], 2
        je .op2

        .op0:
        mov si, ocup
        xor cx, cx
        mov cl, byte[index]
        add si, cx
        mov al, '0'
        mov byte[si], al
        inc si
        jmp telaInicial
 
        .op1:
            call limparTela

            call printarAtributos
            call getchar
            jmp telaInicial

        .op2:
            call limparTela

            ;mostrar instrucoes
            mov si, instr1;
            mov dh, 00h
            mov dl, 00h;
            call printarString

            mov si, instrucao
            mov dh, 02h
            mov dl, 00h
            call printarString

            call pegar
            jmp telaInicial
 
printAux:
    lodsb
 
    mov ah, 0xe
    mov bh, 0
    mov bl, 0xf
    int 10h
 
    cmp al, 13
    jne printAux
ret
 
printarString:
    mov ah, 02h
    mov bh, 00h
    int 10h
    call printAux
 
    ret
 
jogo:
;Setando a posição do disco onde kernel.asm foi armazenado(ES:BX = [0x500:0x0])
    mov ax,0x860        ;0x50<<1 + 0 = 0x500
    mov es,ax
    xor bx,bx       ;Zerando o offset
 
;Setando a posição da Ram onde o jogo será lido
    mov ah, 0x02    ;comando de ler setor do disco
    mov al,8        ;quantidade de blocos ocupados por jogo
    mov dl,0        ;drive floppy
 
;Usaremos as seguintes posições na memoria:
    mov ch,0        ;trilha 0
    mov cl,7        ;setor 2
    mov dh,0        ;cabeca 0
    int 13h
    jc jogo ;em caso de erro, tenta de novo
 
break: 
    jmp 0x8600      ;Pula para a posição carregada

exit:
    
