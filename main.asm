code_start_addr EQU #8000
    ORG code_start_addr

    MODULE main
@code_run_addr:
    ld a, 57
    ld bc, 64
    ld hl, 0
    call print_string
    db "Hello, world!", 0
    ret

    ENDMODULE

    INCLUDE print.asm

code_length EQU $ - code_start_addr

    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    SAVESNA "myprog.sna", code_run_addr
    INCLUDE loader.asm
