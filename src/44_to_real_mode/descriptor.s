;***********************************************************
;  TSS
;***********************************************************
TSS_0:
.link:    dd 0
.esp0:    dd SP_TASK_0 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_BASE
.eip:     dd 0
.eflags:  dd 0
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd 0
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd 0
.cs:      dd 0
.ss:      dd 0
.ds:      dd 0
.fs:      dd 0
.gs:      dd 0
.ldt:     dd 0
.io:      dd 0
.fp_save: times 108 + 4 db 0

TSS_1:
.link:    dd 0
.esp0:    dd SP_TASK_1 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_BASE
.eip:     dd task_1
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd SP_TASK_1
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd DS_TASK_1
.cs:      dd CS_TASK_1
.ss:      dd DS_TASK_1
.ds:      dd DS_TASK_1
.fs:      dd DS_TASK_1
.gs:      dd DS_TASK_1
.ldt:     dd SS_LDT
.io:      dd 0
.fp_save: times 108 + 4 db 0

TSS_2:
.link:    dd 0
.esp0:    dd SP_TASK_2 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:	    dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_BASE
.eip:     dd task_2
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:			dd 0
.esp:			dd SP_TASK_2
.ebp:			dd 0
.esi:			dd 0
.edi:			dd 0
.es:			dd DS_TASK_2
.cs:			dd CS_TASK_2
.ss:			dd DS_TASK_2
.ds:			dd DS_TASK_2
.fs:			dd DS_TASK_2
.gs:			dd DS_TASK_2
.ldt:			dd SS_LDT
.io:			dd 0
.fp_save: times 108 + 4 db 0

TSS_3:
.link:    dd 0
.esp0:    dd SP_TASK_3 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_BASE
.eip:     dd task_3
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd SP_TASK_3
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd DS_TASK_3
.cs:      dd CS_TASK_3
.ss:      dd DS_TASK_3
.ds:      dd DS_TASK_3
.fs:      dd DS_TASK_3
.gs:      dd DS_TASK_3
.ldt:     dd SS_LDT
.io:      dd 0
.fp_save: times 108 + 4 db 0

TSS_4:
.link:    dd 0
.esp0:    dd SP_TASK_4 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_TASK_4
.eip:     dd task_3
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd SP_TASK_4
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd DS_TASK_4
.cs:      dd CS_TASK_3
.ss:      dd DS_TASK_4
.ds:      dd DS_TASK_4
.fs:      dd DS_TASK_4
.gs:      dd DS_TASK_4
.ldt:     dd SS_LDT
.io:      dd 0
.fp_save: times 108 + 4 db 0

TSS_5:
.link:    dd 0
.esp0:    dd SP_TASK_5 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_TASK_5
.eip:     dd task_3
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd SP_TASK_5
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd DS_TASK_5
.cs:      dd CS_TASK_3
.ss:      dd DS_TASK_5
.ds:      dd DS_TASK_5
.fs:      dd DS_TASK_5
.gs:      dd DS_TASK_5
.ldt:     dd SS_LDT
.io:      dd 0
.fp_save: times 108 + 4 db 0

TSS_6:
.link:    dd 0
.esp0:    dd SP_TASK_6 - 512
.ss0:     dd DS_KERNEL
.esp1:    dd 0
.ss1:     dd 0
.esp2:    dd 0
.ss2:     dd 0
.cr3:     dd CR3_TASK_6
.eip:     dd task_3
.eflags:  dd 0x0202
.eax:     dd 0
.ecx:     dd 0
.edx:     dd 0
.ebx:     dd 0
.esp:     dd SP_TASK_6
.ebp:     dd 0
.esi:     dd 0
.edi:     dd 0
.es:      dd DS_TASK_6
.cs:      dd CS_TASK_3
.ss:      dd DS_TASK_6
.ds:      dd DS_TASK_6
.fs:      dd DS_TASK_6
.gs:      dd DS_TASK_6
.ldt:     dd SS_LDT
.io:      dd 0
.fp_save:	times 108 + 4 db 0

;***********************************************************
;  グローバルディスクリプタテーブル
;***********************************************************
GDT:        dq 0x0000000000000000
.cs_kernel: dq 0x00CF9A000000FFFF
.ds_kernel: dq 0x00CF92000000FFFF
.cs_bit16:  dq 0x000F9A000000FFFF
.ds_bit16:  dq 0x000F92000000FFFF
.ldt        dq 0x0000820000000000
.tss_0:     dq 0x0000890000000067
.tss_1:     dq 0x0000890000000067
.tss_2:     dq 0x0000890000000067
.tss_3:     dq 0x0000890000000067
.tss_4:     dq 0x0000890000000067
.tss_5:     dq 0x0000890000000067
.tss_6:     dq 0x0000890000000067
.call_gate: dq 0x0000EC0400080000
.end:

CS_KERNEL   equ .cs_kernel - GDT
DS_KERNEL   equ .ds_kernel - GDT
SS_LDT      equ .ldt - GDT
SS_TASK_0   equ .tss_0 - GDT
SS_TASK_1   equ .tss_1 - GDT
SS_TASK_2   equ .tss_2 - GDT
SS_TASK_3   equ .tss_3 - GDT
SS_TASK_4   equ .tss_4 - GDT
SS_TASK_5   equ .tss_5 - GDT
SS_TASK_6   equ .tss_6 - GDT
SS_GATE_0   equ .call_gate - GDT

GDTR:   dw GDT.end - GDT - 1
        dd GDT

;***********************************************************
;  ローカルディスクリプタテーブル
;***********************************************************
LDT:        dq 0x0000000000000000
.cs_task_0: dq 0x00CF9A000000FFFF
.ds_task_0: dq 0x00CF92000000FFFF
.cs_task_1: dq 0x00CFFA000000FFFF
.ds_task_1: dq 0x00CFF2000000FFFF
.cs_task_2: dq 0x00CFFA000000FFFF
.ds_task_2: dq 0x00CFF2000000FFFF
.cs_task_3: dq 0x00CFFA000000FFFF
.ds_task_3: dq 0x00CFF2000000FFFF
.ds_task_4: dq 0x00CFF2000000FFFF
.ds_task_5: dq 0x00CFF2000000FFFF
.ds_task_6: dq 0x00CFF2000000FFFF
.end:

CS_TASK_0   equ (.cs_task_0 - LDT) | 4
DS_TASK_0   equ (.ds_task_0 - LDT) | 4
CS_TASK_1   equ (.cs_task_1 - LDT) | 4 | 3
DS_TASK_1   equ (.ds_task_1 - LDT) | 4 | 3
CS_TASK_2   equ	(.cs_task_2 - LDT) | 4 | 3
DS_TASK_2   equ (.ds_task_2 - LDT) | 4 | 3
CS_TASK_3   equ (.cs_task_3 - LDT) | 4 | 3
DS_TASK_3   equ (.ds_task_3 - LDT) | 4 | 3
DS_TASK_4   equ (.ds_task_4 - LDT) | 4 | 3
DS_TASK_5   equ (.ds_task_5 - LDT) | 4 | 3
DS_TASK_6   equ (.ds_task_6 - LDT) | 4 | 3

LDT_LIMIT   equ .end - LDT - 1
