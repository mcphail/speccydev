ink_black EQU 0
ink_blue EQU 1
ink_red EQU 2
ink_magenta EQU 3
ink_green EQU 4
ink_cyan EQU 5
ink_yellow EQU 6
ink_white EQU 7
black EQU ink_black
blue EQU ink_blue
red EQU ink_red
magenta EQU ink_magenta
green EQU ink_green
cyan EQU ink_cyan
yellow EQU ink_yellow
white EQU ink_white
paper_black EQU 0
paper_blue EQU 8
paper_red EQU 16
paper_magenta EQU 24
paper_green EQU 32
paper_cyan EQU 40
paper_yellow EQU 48
paper_white EQU 56
bright EQU 64
flash EQU 128
attr_list_end EQU flash | bright | ink_black | paper_black

    MODULE print
bm_start EQU #4000
attr_area EQU #5800
bm_len EQU 6144
attr_len EQU 768
CHARS EQU #5c36
char_posn:
    dw #4000

        MODULE print_string
; Set HL to be row and column and follow the call with a null-terminated string
; All registers preserved
; char_posn will have been moved to after string, but HL will still have coordinates of string start
@print_string:
    call set_char_posn
    ex (sp), hl
    push af
loop:
    ld a, (hl)
    inc hl
    or a
    jr z, exit
    call print_char
    jr loop
exit:
    pop af
    ex (sp), hl
    ret
        ENDMODULE

        MODULE print_char
; Prints the single character from the A register
; All registers preserved
; char_posn will point to next square
@print_char:
    push hl
    push de
    push af
    ld h, 0
    ld l, a
    add hl, hl
    add hl, hl
    add hl, hl
    ld d, h
    ld e, l
    ld hl, (print.CHARS)
    add hl, de
    ld d, h
    ld e, l
    ld hl, (print.char_posn)
    push bc
    ld b, 8
loop:
    ld a, (de)
    ld (hl), a
    inc h
    inc de
    djnz loop
    ld hl, (print.char_posn)
    inc l
    jr nz, update_char_posn
    ld a, #50
    cp h
    jr nz, next_third
    ld hl, print.bm_start
    jr update_char_posn
next_third:
    ld a, 8
    add a, h
    ld h, a
update_char_posn:
    ld (print.char_posn), hl
    pop bc
    pop af
    pop de
    pop hl
    ret
        ENDMODULE

        MODULE set_char_posn
; Pass row and column, in that order, in HL
@set_char_posn:
    push hl
    push af
    ld a, h
    ; check for top third
    ld h, %01000000
    sub 8
    jr c, set_column
    ; check for middle third
    ld h, %01001000
    sub 8
    jr c, set_column
    ; must be bottom third
    ld h, %01010000
    sub 8
set_column:
    ; restore the row offset of the third and shift it into upper 3 bits of L
    add a, 8
    sla a
    sla a
    sla a
    sla a
    sla a
    or l
    ld l, a
    ld (print.char_posn), hl
    pop af
    pop hl
    ret
        ENDMODULE

        MODULE set_attributes
; Row and column in HL
; db list of attributes follows call
; terminate with attr_list_end byte (bright flashing black on black)
@set_attributes:
        ex de, hl
        ex (sp), hl
        push de
        push hl
        ld h, 0
        ld l, d
        ld d, h
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, hl
        add hl, de
        ld de, print.attr_area
        add hl, de
        pop de
        ex de, hl
        push af
loop:
        ld a, (hl)
        inc hl
        cp attr_list_end
        jr z, exit
        ld (de), a
        inc de
        jr loop
exit:
        pop af
        pop de
        ex (sp), hl
        ex de, hl
        ret
        ENDMODULE

    ENDMODULE
