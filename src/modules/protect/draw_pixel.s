draw_pixel:
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
        push edi

        ;-----------------------------------------
        ; Y座標を80倍する(640/8)
        ;-----------------------------------------
        mov edi, [ebp + 12]
        shl edi, 4
        lea edi, [edi * 4 + edi + 0xA_0000]

        ;-----------------------------------------
        ; X座標を1/8して加算
        ;-----------------------------------------
        mov ebx, [ebp + 8]
        mov ecx, ebx
        shr ebx, 3
        add edi, ebx

        ;-----------------------------------------
        ; X座標を8で割った余りからビット位置を計算
        ; (0=0x80, 1=0x40, ..., 7=0x01)
        ;-----------------------------------------
        and ecx, 0x07
        mov ebx, 0x80
        shr ebx, cl

        ;-----------------------------------------
        ; 色指定
        ;-----------------------------------------
        mov ecx, [ebp + 16]

        ;-----------------------------------------
        ; プレーンごとに出力
        ;-----------------------------------------
        cdecl vga_set_read_plane, 0x03
        cdecl vga_set_write_plane, 0x08
        cdecl vram_bit_copy, ebx, edi, 0x08, ecx

        cdecl vga_set_read_plane, 0x02
        cdecl vga_set_write_plane, 0x04
        cdecl vram_bit_copy, ebx, edi, 0x04, ecx

        cdecl vga_set_read_plane, 0x01
        cdecl vga_set_write_plane, 0x02
        cdecl vram_bit_copy, ebx, edi, 0x02, ecx

        cdecl vga_set_read_plane, 0x00
        cdecl vga_set_write_plane, 0x01
        cdecl vram_bit_copy, ebx, edi, 0x01, ecx

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop edi
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