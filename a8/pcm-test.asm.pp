    icl 'hardware.asm'

    org $80
index org *+1
vars
wavei org *+1
range org *+1
offset org *+1
pulseperiod org *+1
gy org *+1
keyrepeat org *+1
rem org *+1
d org *+1
lastkey org *+1

    org $2000
lo240
    ert <*!=0
    :8 dta $A0
    :240 dta $A0|[[#+1+[#/15]]&$F]
    :8 dta $AF
hi240
    ert <*!=0
    :8 dta $10
    :240 dta $10|[[#+1+[#/15]]>>4]
    :8 dta $1F
lo256
    ert <*!=0
    :256 dta $A0|[#&$F]
hi256
    ert <*!=0
    :256 dta $10|[#>>4]

dlist
    :4 dta $70
    dta $47,a(scr)
    :8 dta $7
    dta $41,a(dlist)
scr
scr_wave equ *+11
    dta d' waveform: tri      '
scr_range equ *+11
    dta d'    range: 240      '
scr_offset equ *+11
    dta d'   offset: 0        '
scr_pulse equ *+11
    dta d'    pulse: 3/5      '
    dta d'                    '
    dta d' w/s - up/down      '
    dta d' a/d - change option'
    dta d'                    '
    dta d' any key - reset    '
leftmark
    dta d'   >   '*
rightmark
    dta d'   <   '*


    org [*+$FF]&$FF00
wavetri112
>>> $period = 8*14;
>>> $pad = (256-$period/2)>>1;
>>> for $rep (0, 1) {
>>> for ($i = 0; $i < $period; ++$i) {
>>>   $s = $i<$period/2 ? $pad + $i : 256 - $pad - ($i - $period/2);
    dta <<<$s>>>
>>> }
>>> }
    org [*+$FF]&$FF00
wavetri224
>>> $period = 16*14;
>>> $pad = (256-$period/2)>>1;
>>> for $rep (0, 1) {
>>> for ($i = 0; $i < $period; ++$i) {
>>>   $s = $i<$period/2 ? $pad + $i : 256 - $pad - ($i - $period/2);
    dta <<<$s>>>
>>> }
>>> }
    org [*+$FF]&$FF00
wavetri128
>>> for ($i = 0; $i < 256; ++$i) {
>>>   $s = ($i & 0x40) ? 0x40 - ($i & 0x3F) : ($i & 0x3F);
>>>   $s += 0x60;
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavetri256
>>> for ($i = 0; $i < 256; ++$i) {
>>>   $s = int(8 + ($i < 128 ? $i : 255 - $i) * 240 / 128);
>>>   $s += 0x08;
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavetri131
>>> $period = 131;
>>> $pad = (256-$period/2)>>1;
>>> for ($i = 0; $i < $period; ++$i) {
>>>   $s = $i<$period/2 ? $pad + $i : 256 - $pad - ($i - ($period>>1));
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavetri156
>>> $period = 156;
>>> $pad = (256-$period/2)>>1;
>>> for ($i = 0; $i < $period; ++$i) {
>>>   $s = $i<$period/2 ? $pad + $i : 256 - $pad - ($i - $period/2);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin112
>>> for ($i = 0; $i < 224; ++$i) {
>>>   $s = int(sin($i / 56 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin224
>>> for ($i = 0; $i < 224; ++$i) {
>>>   $s = int(sin($i / 112 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin128
>>> for ($i = 0; $i < 256; ++$i) {
>>>   $s = int(sin($i / 64 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin256
>>> for ($i = 0; $i < 256; ++$i) {
>>>   $s = int(sin($i / 128 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin131
>>> for ($i = 0; $i < 131; ++$i) {
>>>   $s = int(sin($i / 65.5 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }
    org [*+$FF]&$FF00
wavesin156
>>> for ($i = 0; $i < 156; ++$i) {
>>>   $s = int(sin($i / 78 * 3.141592654) * 119.9 + 128);
    dta <<<$s>>>
>>> }

lolo
    dta <lo240,<lo256
lohi
    dta >lo240,>lo256
hilo
    dta <hi240,<hi256
hihi
    dta >hi240,>hi256
wavelo
    dta <wavetri112,<wavetri224,<wavetri128,<wavetri256
    dta <wavetri131,<wavetri156
    dta <wavesin112,<wavesin224,<wavesin128,<wavesin256
    dta <wavesin131,<wavesin156
wavecount equ *-wavelo
wavehi
    dta >wavetri112,>wavetri224,>wavetri128,>wavetri256
    dta >wavetri131,>wavetri156
    dta >wavesin112,>wavesin224,>wavesin128,>wavesin256
    dta >wavesin131,>wavesin156
waveend
    :2 dta 16*14-1,16*14-1,$FF,$FF,130,155

wavestr
    dta d'TRI112  TRI224  TRI128  TRI256  TRI131  TRI156  '*
    dta d'SIN112  SIN224  SIN128  SIN256  SIN131  SIN156  '*
rangestr
    dta d'240 256 '*
pulsestr
    dta d'0/2 1/3 2/4 3/5 4/6 5/6 6/7 7/8 8/9 '*
digits
    dta d'0123456789'*
delay
    dta 8

main
    sei
    mva #0 NMIEN
    sta DMACTL
    sta AUDCTL
    mva #$08 COLPM0 ; channel 1
    mva #$FF GRAFP0
    mva #$04 PRIOR
    mva #5 wavei
    mva #3 pulseperiod
    mva #$FF lastkey
    mva #0 range
    sta offset
    sta gy

    lda:rne VCOUNT
    mwa #dlist DLISTL
    mva #$22 DMACTL

reset
    jsr draw_menu

    ldx wavei
    mva waveend,x cmpindex+1
    mva wavelo,x ldwave+1
    mva wavehi,x ldwave+2
    ldy range
    mva lolo,y ldlo+1
    mva lohi,y ldlo+2
    mva hilo,y ldhi+1
    mva hihi,y ldhi+2
    mva offset index

    lda:req VCOUNT
    jmp start

    org [*+$FF]&$FF00
start
    inc WSYNC
    lda VCOUNT
    bne start
    jsr setpulse

    ldy index ; 3 cycles
play
ldwave
    ldx $FFFF,y
ldhi
    lda $FFFF,x ; 4 cycles
ldlo
    ldy $FFFF,x ; 4 cycles
    inc WSYNC ; Guarantee next instruction starts on cycle 105
    sta AUDC3 ; 4 cycles
    sty AUDC1
    stx HPOSP0 ; 4 cycles
    ldy index
cmpindex
    cpy #$FF
    beq loop
cont
    iny
    sty index
    lda SKSTAT
    and #4
    cmp:sta lastkey
    bcc keydown
    jmp play
loop
    mvy #0 index
    dec keyrepeat
    beq keyup
    jmp play

keyup
    mva #10 keyrepeat
    mva #4 lastkey
    jmp play
keydown
    mva #18 keyrepeat
    lda KBCODE
    ldx gy
    cmp #46 ; 'W'
    sne:dex
    cmp #62 ; 'S'
    sne:inx
    cmp #63 ; 'A'
    sne:dec vars,x
    cmp #58 ; 'D'
    sne:inc vars,x
    txa
    and #3
    sta gy
    jmp reset

draw_menu
    ; wavei
    ; -----
    lda wavei
    spl:lda #wavecount-1
    cmp #wavecount
    scc:lda #0
    sta wavei
    :3 asl @
    add #7
    tax
    ldy #7
    mva:rpl wavestr,x- scr_wave,y-
    ; range
    ; -----
    lda range
    and #1
    sta range
    :2 asl @
    add #3
    tax
    ldy #3
    mva:rpl rangestr,x- scr_range,y-
    ; offset
    ; ------
    lda offset
    ldx #100
    jsr div
    mvy digits,x scr_offset
    ldx #10
    jsr div
    mvy digits,x scr_offset+1
    tax
    mvy digits,x scr_offset+2
    ; pulseperiod
    ; ------
    lda pulseperiod
    and #7
    sta pulseperiod
    :2 asl @
    add #3
    tax
    ldy #3
    mva:rpl pulsestr,x- scr_pulse,y-
    ; mark
    ; ----
    ldx gy
    mva leftmark+3,x scr_wave-1
    mva rightmark+3,x scr_wave+6
    mva leftmark+2,x scr_range-1
    mva rightmark+2,x scr_range+6
    mva leftmark+1,x scr_offset-1
    mva rightmark+1,x scr_offset+6
    mva leftmark,x scr_pulse-1
    mva rightmark,x scr_pulse+6
    rts

div
    stx d
    ldx #0
divloop
    sta rem
    sub d
    bcc divdone
    inx
    jmp divloop
divdone
    lda rem
    rts

setpulse
    ; 1.79Mhz for channel 1
FAST1 equ 1<<6
    ; 1.79Mhz for channel 3
FAST3 equ 1<<5
    ; HiPass 1+3
HI13 equ 1<<2
    ; 15Khz
KHZ15 equ 1<<0
    mva #0 SKCTL
    mva #3 SKCTL
    mva #[FAST1|FAST3|HI13] AUDCTL
    ; Set up 1/16 dutycycle HiPass on 1+3
    ldx pulseperiod
    txa
    add #2
    stx AUDF1
    sta AUDF3
    sta STIMER
    stx AUDF3
    ;ldx delay
    ;dex:rne
    rts

    run main
