draw_char:
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
        push edi

        ;-----------------------------------------
        ; テストアンドセット
        ;-----------------------------------------
%ifdef	USE_TEST_AND_SET
        cdecl test_and_set, IN_USE
%endif

        ;-----------------------------------------
        ; コピー元フォントアドレスを設定
        ;-----------------------------------------
        movzx esi, byte [ebp + 20]
        shl esi, 4
        add esi, [FONT_ADR]

        ;-----------------------------------------
        ; コピー先アドレスを取得
        ; Adr = 0xA0000 + (640 / 8 * 16) * y + x
        ;-----------------------------------------
        mov edi, [ebp + 12]
        shl edi, 8
        lea edi, [edi * 4 + edi + 0xA0000]
        add edi, [ebp + 8]

        ;-----------------------------------------
        ; 1文字分のフォントを出力
        ;-----------------------------------------
        movzx ebx, word[ebp + 16]

        cdecl vga_set_read_plane, 0x03
        cdecl vga_set_write_plane, 0x08
        cdecl vram_font_copy, esi, edi, 0x08, ebx

        cdecl vga_set_read_plane, 0x02
        cdecl vga_set_write_plane, 0x04
        cdecl vram_font_copy, esi, edi, 0x04, ebx

        cdecl vga_set_read_plane, 0x01
        cdecl vga_set_write_plane, 0x02
        cdecl vram_font_copy, esi, edi, 0x02, ebx

        cdecl vga_set_read_plane, 0x00
        cdecl vga_set_write_plane, 0x01
        cdecl vram_font_copy, esi, edi, 0x01, ebx

        ;-----------------------------------------
        ; 変数のクリア
        ;-----------------------------------------
%ifdef	USE_TEST_AND_SET
        mov [IN_USE], dword 0
%endif

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

ALIGN 4, db 0
IN_USE:	dd 0
