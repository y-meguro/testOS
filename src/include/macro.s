%macro cdecl 1-*.nolist
    %rep %0 - 1
        push %{-1:-1}
        %rotate -1
    %endrep
    %rotate -1

    call %1

    %if 1 < %0
        add sp, (__BITS__ >> 3) * (%0 - 1)
    %endif
%endmacro

%macro set_vect 1-*.nolist
        push eax
        push edi

        mov edi, VECT_BASE + (%1 * 8)
        mov eax, %2

	%if 3 == %0
		mov [edi + 4], %3
	%endif

        mov [edi + 0], ax
        shr eax, 16
        mov [edi + 6], ax

        pop edi
        pop eax
%endmacro

%macro outp 2
    mov al, %2
    out %1, al
%endmacro

%macro set_desc 2-*
        push eax
        push edi

        mov edi, %1
        mov eax, %2

    %if 3 == %0
        mov [edi + 0], %3
    %endif

        mov [edi + 2], ax
        shr eax, 16
        mov [edi + 4], al
        mov [edi + 7], ah

        pop edi
        pop eax
%endmacro

%macro  set_gate 2-* 
    push eax
    push edi

    mov edi, %1
    mov eax, %2

    mov [edi + 0], ax
    shr eax, 16
    mov [edi + 6], ax

    pop edi
    pop eax
%endmacro

struc drive
    .no resw 1      ; ドライブ番号
    .cyln resw 1    ; シリンダ
    .head resw 1    ; ヘッド
    .sect resw 1    ; セクタ
endstruc

%define RING_ITEM_SIZE (1 << 4)
%define RING_INDEX_MASK (RING_ITEM_SIZE - 1)

struc ring_buff
    .rp resd 1                  ; RP:書き込み位置
    .wp resd 1                  ; WP:読み込み位置
    .item resb RING_ITEM_SIZE   ; バッファ
endstruc

struc rose
    .x0 resd 1
    .y0 resd 1
    .x1 resd 1
    .y1 resd 1

    .n resd 1
    .d resd 1

    .color_x resd 1
    .color_y resd 1
    .color_z resd 1
    .color_s resd 1
    .color_f resd 1
    .color_b resd 1

    .title resb 16
endstruc
