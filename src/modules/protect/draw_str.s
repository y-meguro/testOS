draw_str:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push eax
        push ebx
        push ecx
        push edx
        push esi

        ;-----------------------------------------
        ; 文字列を描画する
        ;-----------------------------------------
        mov ecx, [ebp + 8]
        mov edx, [ebp + 12]
        movzx ebx, word [ebp + 16]
        mov esi, [ebp + 20]

        cld
.10L:
        lodsb
        cmp al, 0
        je .10E

%ifdef	USE_SYSTEM_CALL
        int 0x81
%else
        cdecl draw_char, ecx, edx, ebx, eax
%endif

        inc ecx
        cmp ecx, 80
        jl .12E
        mov ecx, 0
        inc edx
        cmp edx, 30
        jl .12E
        mov edx, 0
.12E:
        jmp .10L
.10E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop esi
        pop edx
        pop ecx
        pop ebx
        pop eax

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret