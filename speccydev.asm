code_start_addr EQU #8000
    org code_start_addr

    ; headerless load
    scf
    ld a, #ff
    ld de, boriel_size
    ld ix, compressed_boriel
    call #0556

decompress:
    ld hl, compressed_boriel
    ld de, uncompressed_boriel
    call dzx0.dzx0_standard

    call uncompressed_boriel
    ret

    MODULE dzx0
    INCLUDE "dzx0_standard.asm"
    ENDMODULE

code_length EQU $ - code_start_addr

compressed_boriel:
    INCBIN "boriel.zx0"
boriel_size EQU $ - compressed_boriel

uncompressed_boriel EQU 40000


    DEVICE ZXSPECTRUM48
    SLDOPT COMMENT WPMEM, LOGPOINT, ASSERTION
    SAVESNA "myprog.sna", decompress
    EMPTYTAP "sjasm.tap"
    SAVETAP "sjasm.tap", CODE, "sjasm", code_start_addr, code_length