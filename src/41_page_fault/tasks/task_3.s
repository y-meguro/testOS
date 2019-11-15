task_3:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        mov ebp, esp

        push dword 0
        push dword 0
        push dword 0
        push dword 0
        push dword 0

        ;-----------------------------------------
        ; 初期化
        ;-----------------------------------------
        mov esi, 0x0010_7000

        ;-----------------------------------------
        ; タイトル表示
        ;-----------------------------------------
        mov eax, [esi + rose.x0]
        mov ebx, [esi + rose.y0]

        shr eax, 3
        shr ebx, 4
        dec ebx
        mov ecx, [esi + rose.color_s]
        lea edx, [esi + rose.title]

        cdecl draw_str, eax, ebx, ecx, edx

        ;-----------------------------------------
        ; X軸の中点
        ;-----------------------------------------
        mov eax, [esi + rose.x0]
        mov ebx, [esi + rose.x1]
        sub ebx, eax
        shr ebx, 1
        add ebx, eax
        mov [ebp - 4], ebx

        ;-----------------------------------------
        ; Y軸の中点
        ;-----------------------------------------
        mov eax, [esi + rose.y0]
        mov ebx, [esi + rose.y1]
        sub ebx, eax
        shr ebx, 1
        add ebx, eax
        mov [ebp - 8], ebx

        ;-----------------------------------------
        ; X軸の描画
        ;-----------------------------------------
        mov eax, [esi + rose.x0]
        mov ebx, [ebp - 8]
        mov ecx, [esi + rose.x1]

        cdecl draw_line, eax, ebx, ecx, ebx, dword [esi + rose.color_x]

        ;-----------------------------------------
        ; Y軸の描画
        ;-----------------------------------------
        mov eax, [esi + rose.y0]
        mov ebx, [ebp - 4]
        mov ecx, [esi + rose.y1]

        cdecl draw_line, ebx, eax, ebx, ecx, dword [esi + rose.color_y]

        ;-----------------------------------------
        ; 枠の描画
        ;-----------------------------------------
        mov eax, [esi + rose.x0]
        mov ebx, [esi + rose.y0]
        mov ecx, [esi + rose.x1]
        mov edx, [esi + rose.y1]

        cdecl draw_rect, eax, ebx, ecx, edx, dword [esi + rose.color_z]

        ;-----------------------------------------
        ; 振幅をX軸の約95%とする
        ;-----------------------------------------
        mov eax, [esi + rose.x1]
        sub eax, [esi + rose.x0]
        shr eax, 1
        mov ebx, eax
        shr ebx, 4
        sub eax, ebx

        ;-----------------------------------------
        ; FPUの初期化(バラ曲線の初期化)
        ;-----------------------------------------
        cdecl fpu_rose_init, eax, dword [esi + rose.n], dword [esi + rose.d]

        ;-----------------------------------------
        ; メインループ
        ;-----------------------------------------
.10L:

        ;-----------------------------------------
        ; 座標計算
        ;-----------------------------------------
        lea ebx, [ebp - 12]
        lea ecx, [ebp - 16]
        mov eax, [ebp - 20]

        cdecl fpu_rose_update, ebx, ecx, eax

        ;-----------------------------------------
        ; 角度更新(r = r % 36000)
        ;-----------------------------------------
        mov edx, 0
        inc eax
        mov ebx, 360 * 100
        div ebx
        mov [ebp - 20], edx

        ;-----------------------------------------
        ; ドット描画
        ;-----------------------------------------
        mov ecx, [ebp - 12]
        mov edx, [ebp - 16]

        add ecx, [ebp - 4]
        add edx, [ebp - 8]

        mov ebx, [esi + rose.color_f]
        int 0x82

        ;-----------------------------------------
        ; ウェイト
        ;-----------------------------------------
        cdecl wait_tick, 2

        ;-----------------------------------------
        ; ドット描画
        ;-----------------------------------------
        mov ebx, [esi + rose.color_b]
        int 0x82

        jmp .10L

        ;-----------------------------------------
        ; データ
        ;-----------------------------------------
ALIGN 4, db 0
DRAW_PARAM:
    istruc rose
        at rose.x0, dd 16
        at rose.y0, dd 32
        at rose.x1, dd 416
        at rose.y1, dd 432

        at rose.n, dd 5
        at rose.d, dd 2

        at rose.color_x, dd 0x0007
        at rose.color_y, dd 0x0007
        at rose.color_z, dd 0x000F
        at rose.color_s, dd 0x030F
        at rose.color_f, dd 0x000F
        at rose.color_b, dd 0x0003

        at rose.title, db "Task-3", 0
    iend

fpu_rose_init:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        push dword 180

        ;-----------------------------------------
        ; FPUのスタックを設定
        ;-----------------------------------------
        fldpi
        fidiv dword [ebp - 4]
        fild dword [ebp + 12]
        fidiv dword [ebp + 16]
        fild dword [ebp + 8]

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret

fpu_rose_update:
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

        ;-----------------------------------------
        ; X/Y座標の保存先を設定
        ;-----------------------------------------
        mov eax, [ebp + 8]
        mov ebx, [ebp + 12]

        ;-----------------------------------------
        ; ラディアンへの変換
        ;-----------------------------------------
        fild dword [ebp + 16]
        fmul st0, st3
        fld st0

        fsincos
        fxch st2
        fmul st0, st4
        fsin
        fmul st0, st3

        ;-----------------------------------------
        ; x = A * sin(kθ) * cos(θ)
        ;-----------------------------------------
        fxch st2
        fmul st0, st2
        fistp dword [eax]

        ;-----------------------------------------
        ; y = -A * sin(kθ) * sin(θ)
        ;-----------------------------------------
        fmulp st1, st0
        fchs
        fistp dword [ebx]

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop ebx
        pop eax

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret
