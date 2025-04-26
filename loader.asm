    MODULE basic_loader
    ORG #5c00
basic_start:
    db 0, 0     ; line number
    dw line_length
line_start:
    db #fd, '0', #0e, 0, 0  ; CLEAR
    dw code_start_addr - 1
    db 0, ':'
    db #ef, '"'             ; LOAD "
    db "code"
    db '"', #af, ':'        ; name"CODE
    db #f5, #c0             ; PRINT USR
    db '0', #0e, 0, 0
    dw code_run_addr
    db 0, #0d

line_length EQU $ - line_start
basic_length EQU $ - basic_start

    EMPTYTAP "myprog.tap"
    SAVETAP "myprog.tap", BASIC, "myprog", basic_start, basic_length, 0
    SAVETAP "myprog.tap", CODE, "code", code_start_addr, code_length

    ENDMODULE
