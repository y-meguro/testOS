int_nm:
        ;-----------------------------------------
        ; 【レジスタの保存】
        ;-----------------------------------------
        pusha
        push ds
        push es

        ;-----------------------------------------
        ; カーネル用セレクタを設定
        ;-----------------------------------------
        mov ax, DS_KERNEL
        mov ds, ax
        mov es, ax

        ;-----------------------------------------
        ; タスクスイッチフラグをクリア
        ;-----------------------------------------
        clts

        ;-----------------------------------------
        ; 前回/今回FPUを使用するタスク
        ;-----------------------------------------
        mov edi, [.last_tss]
        str esi
        and esi, ~0x0007

        ;-----------------------------------------
        ; FPUの初回利用をチェック
        ;-----------------------------------------
        cmp edi, 0
        je .10F

        cmp esi, edi
        je .12E

        cli

        ;-----------------------------------------
        ; 前回のFPUコンテキストを保存
        ;-----------------------------------------
        mov ebx, edi
        call get_tss_base
        call save_fpu_context

        ;-----------------------------------------
        ; 今回のFPUコンテキストを復帰
        ;-----------------------------------------
        mov ebx, esi
        call get_tss_base
        call load_fpu_context

        sti
.12E:
        jmp .10E
.10F:
        cli

        ;-----------------------------------------
        ; 今回のFPUコンテキストを復帰
        ;-----------------------------------------
        mov ebx, esi
        call get_tss_base
        call load_fpu_context

        sti
.10E:
        mov [.last_tss], esi

        ;-----------------------------------------
        ; 【レジスタの復帰】
        ;-----------------------------------------
        pop es
        pop ds
        popa

        iret

ALIGN 4, db 0
.last_tss: dd 0

get_tss_base:
        mov eax, [GDT + ebx + 2]
        shl eax, 8
        mov al,  [GDT + ebx + 7]
        ror eax, 8

        ret

save_fpu_context:
        fnsave [eax + 104]
        mov [eax + 104 + 108], dword 1

        ret

load_fpu_context:
        cmp [eax + 104 + 108], dword 0
        jne .10F
        fninit
        jmp .10E
.10F:
        frstor [eax + 104]
.10E:
        ret
