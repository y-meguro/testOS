memcpy:
        push ebp
        mov ebp, esp

        push ecx
        push esi
        push edi

        cld
        mov edi, [ebp + 8]
        mov esi, [ebp + 12]
        mov ecx, [ebp + 16]

        rep movsb

        pop edi
        pop esi
        pop ecx

        mov esp, ebp
        pop ebp

        ret