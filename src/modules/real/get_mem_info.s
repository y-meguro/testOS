get_mem_info:
        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push eax
        push ebx
        push ecx
        push edx
        push si
        push di
        push bp

ALIGN 4, db 0
.b0:    times E820_RECORD_SIZE db 0

        cdecl puts, .s0

        ; メモリ情報を取得する
        mov bp, 0
        mov ebx, 0
.10L:
        mov eax, 0x0000E820
        mov ecx, E820_RECORD_SIZE
        mov edx, 'PAMS'
        mov di, .b0
        int 0x15

        ; コマンドに対応か？
        cmp eax, 'PAMS'
        je .12E
        jmp .10E
.12E:
        ; エラーなし？
        jnc .14E
        jmp .10E
.14E:
        ; 1レコード分のメモリ情報を表示
        cdecl put_mem_info, di

        ; ACPI dataのアドレスを取得
        mov eax, [di + 16]
        cmp eax, 3
        jne .15E

        mov eax, [di + 0]
        mov [ACPI_DATA.adr], eax

        mov eax, [di + 8]
        mov [ACPI_DATA.len], eax
.15E:
        cmp ebx, 0
        jz .16E

        inc bp
        and bp, 0x07
        jnz .16E

        cdecl puts, .s2

        mov ah, 0x10
        int 0x16

        cdecl puts, .s3
.16E:
        cmp ebx, 0
        jne .10L
.10E:
        cdecl puts, .s1

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop bp
        pop di
        pop si
        pop edx
        pop ecx
        pop ebx
        pop eax

        ret

        ;------------------------------------------
        ; データ
        ;------------------------------------------
.s0:	db " E820 Memory Map:", 0x0A, 0x0D
	db " Base_____________ Length___________ Type____", 0x0A, 0x0D, 0
.s1:	db " ----------------- ----------------- --------", 0x0A, 0x0D, 0
.s2:    db " <more...>", 0
.s3:    db 0x0D, "          ", 0x0D, 0

put_mem_info:
        ;------------------------------------------
        ; 【スタックフレームの構築】
        ;------------------------------------------
        push bp
        mov bp, sp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push bx
        push si

        ;-----------------------------------------
        ; 引数を取得
        ;-----------------------------------------
        mov si, [bp + 4]

        ;-----------------------------------------
        ; レコードの表示
        ;-----------------------------------------
        ; Base(64bit)
        cdecl itoa, word[si + 6], .p2 + 0, 4, 16, 0b0100
        cdecl itoa, word[si + 4], .p2 + 4, 4, 16, 0b0100
        cdecl itoa, word[si + 2], .p3 + 0, 4, 16, 0b0100
        cdecl itoa, word[si + 0], .p3 + 4, 4, 16, 0b0100

        ; Length(64bit)
        cdecl itoa, word[si + 14], .p4 + 0, 4, 16, 0b0100
        cdecl itoa, word[si + 12], .p4 + 4, 4, 16, 0b0100
        cdecl itoa, word[si + 10], .p5 + 0, 4, 16, 0b0100
        cdecl itoa, word[si + 8], .p5 + 4, 4, 16, 0b0100

        ; Type(32bit)
        cdecl itoa, word[si + 18], .p6 + 0, 4, 16, 0b0100
        cdecl itoa, word[si + 16], .p6 + 4, 4, 16, 0b0100

        cdecl puts, .s1

        mov bx, [si + 16]
        and bx, 0x07
        shl bx, 1
        add bx, .t0
        cdecl puts, word[bx]

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop si
        pop bx

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov sp, bp
        pop bp

        ret

        ;------------------------------------------
        ; データ
        ;------------------------------------------
.s1:    db " "
.p2:    db "ZZZZZZZZ_"
.p3:    db "ZZZZZZZZ "
.p4:    db "ZZZZZZZZ_"
.p5:    db "ZZZZZZZZ "
.p6:    db "ZZZZZZZZ", 0

.s4:    db " (Unknown)", 0x0A, 0x0D, 0
.s5:    db " (usable)", 0x0A, 0x0D, 0
.s6:    db " (reserved)", 0x0A, 0x0D, 0
.s7:    db " (ACPI data)", 0x0A, 0x0D, 0
.s8:    db " (ACPI NVS)", 0x0A, 0x0D, 0
.s9:    db " (bad memory)", 0x0A, 0x0D, 0

.t0: dw .s4, .s5, .s6, .s7, .s8, .s9, .s4, .s4
