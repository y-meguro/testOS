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
.cr3:     dd 0
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
.cr3:     dd 0
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
.cr3:     dd 0
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

;***********************************************************
;  グローバルディスクリプタテーブル
;***********************************************************
GDT:        dq 0x0000000000000000
.cs_kernel: dq 0x00CF9A000000FFFF
.ds_kernel: dq 0x00CF92000000FFFF
.ldt        dq 0x0000820000000000
.tss_0:     dq 0x0000890000000067
.tss_1:     dq 0x0000890000000067
.tss_2:     dq 0x0000890000000067
.call_gate: dq 0x0000EC0400080000
.end:

CS_KERNEL   equ .cs_kernel - GDT
DS_KERNEL   equ .ds_kernel - GDT
SS_LDT      equ .ldt - GDT
SS_TASK_0   equ .tss_0 - GDT
SS_TASK_1   equ .tss_1 - GDT
SS_TASK_2   equ .tss_2 - GDT
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
.end:

CS_TASK_0   equ (.cs_task_0 - LDT) | 4
DS_TASK_0   equ (.ds_task_0 - LDT) | 4
CS_TASK_1   equ (.cs_task_1 - LDT) | 4 | 3
DS_TASK_1   equ (.ds_task_1 - LDT) | 4 | 3
CS_TASK_2   equ	(.cs_task_2 - LDT) | 4 | 3
DS_TASK_2   equ (.ds_task_2 - LDT) | 4 | 3

LDT_LIMIT   equ .end - LDT - 1
