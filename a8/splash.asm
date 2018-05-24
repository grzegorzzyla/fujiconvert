splash
    ; disable interrupts, ANTIC, POKEY
    sei
    mva #0 NMIEN
    sta DMACTL
    sta AUDCTL
    mwa #dlist DLISTL
    mva #0 COLPF2
    mva #15 COLPF1
    lda:rne VCOUNT
    mva #$22 DMACTL

wait
    lda SKSTAT
    and #4
    beq continue
    lda TRIG0
    beq continue
    lda CONSOL
    and #7
    cmp #7
    bne continue
    jmp wait

continue
    rts

dlist
    :10 dta $70
    dta $42,a(scr)
    :9 dta 2
    dta $41,a(dlist)
scr
    ;     0123456789012345678901234567890123456789
    org *+40*10
;    dta d' Song:                                  '
;    dta d' Length:                                '
;    dta d' Playback method:                       '
;    dta d' Frequency:                             '
;    dta d'    Press any key to start playback     '
;    dta d' Press START to toggle between Altirra  '
;    dta d'         and hardware tuning            '
