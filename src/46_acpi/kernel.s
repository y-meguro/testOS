;***********************************************************
;  マクロ
;***********************************************************
%define USE_SYSTEM_CALL
%define USE_TEST_AND_SET

%include "../include/define.s"
%include "../include/macro.s"

        ORG KERNEL_LOAD

[BITS 32]
;***********************************************************
;  エントリポイント
;***********************************************************
kernel:
        ;------------------------------------------
        ; フォントアドレスを取得
        ;------------------------------------------
        mov esi, BOOT_LOAD + SECT_SIZE
        movzx eax, word[esi + 0]
        movzx ebx, word[esi + 2]
        shl eax, 4
        add eax, ebx
        mov [FONT_ADR], eax

        ;------------------------------------------
        ; TSSディスクリプタの設定
        ;------------------------------------------
        set_desc GDT.tss_0, TSS_0
        set_desc GDT.tss_1, TSS_1
        set_desc GDT.tss_2, TSS_2
        set_desc GDT.tss_3, TSS_3
        set_desc GDT.tss_4, TSS_4
        set_desc GDT.tss_5, TSS_5
        set_desc GDT.tss_6, TSS_6

        ;------------------------------------------
        ; コールゲートの設定
        ;------------------------------------------
        set_gate GDT.call_gate, call_gate

        ;------------------------------------------
        ; LDTの設定
        ;------------------------------------------
        set_desc GDT.ldt, LDT, word LDT_LIMIT

        ;------------------------------------------
        ; GDTをロード(再設定)
        ;------------------------------------------
        lgdt [GDTR]

        ;------------------------------------------
        ; スタックの設定
        ;------------------------------------------
        mov esp, SP_TASK_0

        ;------------------------------------------
        ; タスクレジスタの初期化
        ;------------------------------------------
        mov ax, SS_TASK_0
        ltr ax

        ;------------------------------------------
        ; 初期化
        ;------------------------------------------
        cdecl init_int
        cdecl init_pic
        cdecl init_page

        set_vect 0x00, int_zero_div
        set_vect 0x07, int_nm
        set_vect 0x0E, int_pf
        set_vect 0x20, int_timer
        set_vect 0x21, int_keyboard
        set_vect 0x28, int_rtc
        set_vect 0x81, trap_gate_81, word 0xEF00
        set_vect 0x82, trap_gate_82, word 0xEF00

        ;------------------------------------------
        ; デバイスの割り込み許可
        ;------------------------------------------
        cdecl rtc_int_en, 0x10
        cdecl int_en_timer0

        ;------------------------------------------
        ; IMR(割り込みマスクレジスタ)の設定
        ;------------------------------------------
        outp 0x21, 0b_1111_1000
        outp 0xA1, 0b_1111_1110

        ;------------------------------------------
        ; ページングの有効化
        ;------------------------------------------
        mov eax, CR3_BASE
        mov cr3, eax

        mov eax, cr0
        or eax, (1 << 31)
        mov cr0, eax
        jmp $ + 2

        ;------------------------------------------
        ; CPUの割り込み許可
        ;------------------------------------------
        sti

        ;------------------------------------------
        ; フォントの一覧表示
        ;------------------------------------------
        cdecl draw_font, 63, 13
        cdecl draw_color_bar, 63, 4

        ;------------------------------------------
        ; 文字列の表示
        ;------------------------------------------
        cdecl draw_str, 25, 14, 0x010F, .s0

.10L:

        ;------------------------------------------
        ; 回転する棒を表示
        ;------------------------------------------
        cdecl draw_rotation_bar

        ;------------------------------------------
        ; キーコードの取得
        ;------------------------------------------
        cdecl ring_rd, _KEY_BUFF, .int_key
        cmp eax, 0
        je .10E

        ;------------------------------------------
        ; キーコードの表示
        ;------------------------------------------
        cdecl draw_key, 2, 29, _KEY_BUFF

        ;------------------------------------------
        ; キー押下時の処理
        ;------------------------------------------
        mov al, [.int_key]
        cmp al, 0x02
        jne .12E

        ;------------------------------------------
        ; ファイル読み込み
        ;------------------------------------------
        call [BOOT_LOAD + BOOT_SIZE - 16]

        ;------------------------------------------
        ; ファイルの内容を表示
        ;------------------------------------------
        mov esi, 0x7800
        mov [esi + 32], byte 0
        cdecl draw_str, 0, 0, 0x0F04, esi
.12E:

        ;------------------------------------------
        ; CTRL+ALT+ENDキー
        ;------------------------------------------
        mov al, [.int_key]
        cdecl ctrl_alt_end, eax
        cmp eax, 0
        je .14E

        mov eax, 0
        bts [.once], eax
        jc .14E
        cdecl power_off

.14E:
.10E:
        jmp .10L

.s0:    db " Hello, kernel! ", 0

ALIGN 4, db 0
.int_key: dd 0
.once:    dd 0

ALIGN 4, db 0
FONT_ADR: dd 0
RTC_TIME: dd 0

;***********************************************************
;  タスク
;***********************************************************
%include "descriptor.s"
%include "modules/paging.s"
%include "modules/int_timer.s"
%include "modules/int_pf.s"
%include "tasks/task_1.s"
%include "tasks/task_2.s"
%include "tasks/task_3.s"

;***********************************************************
;  モジュール
;***********************************************************
%include "../modules/protect/vga.s"
%include "../modules/protect/draw_char.s"
%include "../modules/protect/draw_font.s"
%include "../modules/protect/draw_str.s"
%include "../modules/protect/draw_color_bar.s"
%include "../modules/protect/draw_pixel.s"
%include "../modules/protect/draw_line.s"
%include "../modules/protect/draw_rect.s"
%include "../modules/protect/itoa.s"
%include "../modules/protect/rtc.s"
%include "../modules/protect/draw_time.s"
%include "../modules/protect/interrupt.s"
%include "../modules/protect/pic.s"
%include "../modules/protect/int_rtc.s"
%include "../modules/protect/int_keyboard.s"
%include "../modules/protect/ring_buff.s"
%include "../modules/protect/timer.s"
%include "../modules/protect/draw_rotation_bar.s"
%include "../modules/protect/call_gate.s"
%include "../modules/protect/trap_gate.s"
%include "../modules/protect/test_and_set.s"
%include "../modules/protect/int_nm.s"
%include "../modules/protect/wait_tick.s"
%include "../modules/protect/memcpy.s"
%include "../modules/protect/ctrl_alt_end.s"
%include "../modules/protect/power_off.s"
%include "../modules/protect/acpi_find.s"
%include "../modules/protect/find_rsdt_entry.s"
%include "../modules/protect/acpi_package_value.s"

;***********************************************************
;  パディング
;***********************************************************
        times KERNEL_SIZE - ($ - $$) db 0

;***********************************************************
;  FAT
;***********************************************************
%include "fat.s"
