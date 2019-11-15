draw_line:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        push dword 0
        push dword 0
        push dword 0
        push dword 0
        push dword 0
        push dword 0
        push dword 0

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push eax
        push ebx
        push ecx
        push edx
        push esi
        push edi

        ;-----------------------------------------
        ; 幅を計算(X軸)
        ;-----------------------------------------
        mov eax, [ebp + 8]
        mov ebx, [ebp + 16]
        sub ebx, eax
        jge .10F

        neg ebx
        mov esi, -1
        jmp .10E
.10F:
        mov esi, 1
.10E:

        ;-----------------------------------------
        ; 高さを計算(Y軸)
        ;-----------------------------------------
        mov ecx, [ebp + 12]
        mov edx, [ebp + 20]
        sub edx, ecx
        jge .20F

        neg edx
        mov edi, -1
        jmp .20E
.20F:
        mov edi, 1
.20E:

        ;-----------------------------------------
        ; X軸
        ;-----------------------------------------
        mov [ebp - 8], eax
        mov [ebp - 12], ebx
        mov [ebp - 16], esi

        ;-----------------------------------------
        ; Y軸
        ;-----------------------------------------
        mov [ebp - 20], ecx
        mov [ebp - 24], edx
        mov [ebp - 28], edi

        ;-----------------------------------------
        ; 基準軸を決める
        ;-----------------------------------------
        cmp ebx, edx
        jg .22F

        lea esi, [ebp - 20]
        lea edi, [ebp - 8]

        jmp .22E
.22F:
        lea esi, [ebp - 8]
        lea edi, [ebp - 20]
.22E:

        ;-----------------------------------------
        ; 繰り返し回数(基準軸のドット数)
        ;-----------------------------------------
        mov ecx, [esi - 4]
        cmp ecx, 0
        jnz .30E
        mov ecx, 1
.30E:

        ;-----------------------------------------
        ; 線を描画
        ;-----------------------------------------
.50L:

%ifdef  USE_SYSTEM_CALL
        mov eax, ecx

        mov ebx, [ebp + 24]
        mov ecx, [ebp - 8]
        mov edx, [ebp - 20]
        int 0x82

        mov ecx, eax
%else
        cdecl draw_pixel, dword [ebp - 8], dword [ebp - 20], dword [ebp + 24]
%endif

        mov eax, [esi - 8]
        add [esi - 0], eax

        mov eax, [ebp - 4]
        add eax, [edi - 4]
        mov ebx, [esi - 4]

        cmp eax, ebx
        jl .52E
        sub eax, ebx

        mov ebx, [edi - 8]
        add [edi - 0], ebx
.52E:
        mov [ebp - 4], eax

        loop .50L
.50E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop edi
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

.s0:    db '        ', 0
.t0:    dw 0x0000, 0x0800
        dw 0x0100, 0x0900
        dw 0x0200, 0x0A00
        dw 0x0300, 0x0B00
        dw 0x0400, 0x0C00
        dw 0x0500, 0x0D00
        dw 0x0600, 0x0E00
        dw 0x0700, 0x0F00