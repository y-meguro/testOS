init_page:
        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        pusha

        ;-----------------------------------------
        ; ページ変換テーブルの作成
        ;-----------------------------------------
        cdecl page_set_4m, CR3_BASE

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        popa

        ret

page_set_4m:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push ebp
        mov ebp, esp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        pusha

        ;-----------------------------------------
        ; ページディレクトリの作成(P=0)
        ;-----------------------------------------
        cld
        mov edi, [ebp + 8]
        mov eax, 0x00000000
        mov ecx, 1024
        rep stosd

        ;-----------------------------------------
        ; 先頭のエントリを設定
        ;-----------------------------------------
        mov eax, edi
        and eax, ~0x0000_0FFF
        or eax,  7
        mov [edi - (1024 * 4)], eax

        ;-----------------------------------------
        ; ページテーブルの設定(リニア)
        ;-----------------------------------------
        mov eax, 0x00000007
        mov ecx, 1024

.10L:
        stosd
        add eax, 0x00001000
        loop .10L

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        popa

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov esp, ebp
        pop ebp

        ret
