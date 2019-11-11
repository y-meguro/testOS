get_drive_param:
        ;-----------------------------------------
        ; 【スタックフレームの構築】
        ;-----------------------------------------
        push bp
        mov bp, sp

        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        push bx
        push cx
        push es
        push si
        push di

        ;-----------------------------------------
        ; 【処理の開始】
        ;-----------------------------------------
        mov si, [bp + 4]                          ; SI = SRCバッファ

        mov ax, 0
        mov es, ax
        mov di, ax

        mov ah, 8
        mov dl, [si + drive.no]
        int 0x13
.10Q:
        jc .10F
.10T:
        mov al, cl
        and ax, 0x3F

        shr cl, 6
        ror cx, 8
        inc cx

        movzx bx, dh
        inc bx

        mov [si + drive.cyln], cx
        mov [si + drive.head], bx
        mov [si + drive.sect], ax

        jmp .10E
.10F:
        mov ax, 0
.10E:

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop di
        pop si
        pop es
        pop cx
        pop bx

        ;-----------------------------------------
        ; 【スタックフレームの破棄】
        ;-----------------------------------------
        mov sp, bp
        pop bp

        ret