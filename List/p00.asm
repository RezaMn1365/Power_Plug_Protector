
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8L
;Program type             : Application
;Clock frequency          : 1.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8L
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _LED=R4
	.DEF _MODE=R6
	.DEF _MODESELECT=R8
	.DEF _OVERFLOW=R10
	.DEF _AD=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP _ext_int0_isr
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_0x3:
	.DB  0x3F,0x0,0x6,0x0,0x5B,0x0,0x4F,0x0
	.DB  0x66,0x0,0x6D,0x0,0x7D,0x0,0x7,0x0
	.DB  0x7F,0x0,0x6F,0x0,0x3E,0x0,0x31,0x0
	.DB  0x38,0x0,0x33,0x0,0x27,0x0,0x37,0x0
	.DB  0x71,0x0,0x77,0x0,0x0,0x0,0x76,0x0
	.DB  0x30
_0x4:
	.DB  0xFE,0x0,0xEF,0x0,0xDF
_0x5:
	.DB  0x3F,0x2,0x26,0x2,0x12,0x2,0x62,0x1
	.DB  0x72,0x1,0x8C,0x1
_0x6:
	.DB  0x1E,0x0,0x4B,0x0,0xF0
_0x7:
	.DB  0xC0,0x3,0x60,0x9,0x0,0x1E
_0xB6:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x29
	.DW  _SEGCODE
	.DW  _0x3*2

	.DW  0x0C
	.DW  _OUV
	.DW  _0x5*2

	.DW  0x05
	.DW  _SCALE
	.DW  _0x6*2

	.DW  0x06
	.DW  _OVERFLOWSCALE
	.DW  _0x7*2

	.DW  0x06
	.DW  0x04
	.DW  _0xB6*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.04.4a Advanced
;Automatic Program Generator
;© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :PROTECTOR
;Version :1
;Date    : 3/11/2012
;Author  : REZA MOSAVIAN
;Company : RM
;Comments:
;Chip type               : ATmega8L
;Program type            : Application
;AVR Core Clock frequency: 1.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;
;// Declare your global variables here
;unsigned short LED=0,MODE=0,MODESELECT=0;
;unsigned int OVERFLOW,AD,i,i1,X,NUM;
;
;                                                                // CODE 7SEG    V    r    L   ____M____  N    F    A  NON H    I
;unsigned short SEGCODE[21]= {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0X3E,0X31,0X38,0x33,0x27,0X37,0x71,0x77,0,0x76,0x30};

	.DSEG
;unsigned short LOCCODE[3] = {0XFE,0XEF,0XDF};                           // BA PORT D OR SHAVAD   {0XFE,0XEF,0XDF};
;        //REAL VOLTAGE 260 250 240 160 170 185
;unsigned int OUV[6] = {575,550,530,354,370,396};
;unsigned int SCALE[3] = {30,75,240};
;unsigned int OVERFLOWSCALE[3]={960,2400,7680}; //{117,293,879}
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 002A {

	.CSEG
_read_adc:
; 0000 002B ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 002C // Delay needed for the stabilization of the ADC input voltage
; 0000 002D delay_us(10);
	__DELAY_USB 3
; 0000 002E // Start the AD conversion
; 0000 002F ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0030 // Wait for the AD conversion to complete
; 0000 0031 while ((ADCSRA & 0x10)==0);
_0x8:
	SBIS 0x6,4
	RJMP _0x8
; 0000 0032 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0033 return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 0034 }
;
;
;
; void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
; 0000 0039 {
_EEPROM_write:
; 0000 003A /* Wait for completion of previous write */
; 0000 003B while(EECR & (1<<EEWE))
;	uiAddress -> Y+1
;	ucData -> Y+0
_0xB:
	SBIC 0x1C,1
; 0000 003C ;
	RJMP _0xB
; 0000 003D /* Set up address and data registers */
; 0000 003E EEAR = uiAddress;
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 003F EEDR = ucData;
	LD   R30,Y
	OUT  0x1D,R30
; 0000 0040 /* Write logical one to EEMWE */
; 0000 0041 EECR |= (1<<EEMWE);
	SBI  0x1C,2
; 0000 0042 /* Start eeprom write by setting EEWE */
; 0000 0043 EECR |= (1<<EEWE);
	SBI  0x1C,1
; 0000 0044 return;}
	ADIW R28,3
	RET
;
;
;unsigned char EEPROM_read(unsigned int uiAddress)
; 0000 0048 {
_EEPROM_read:
; 0000 0049 /* Wait for completion of previous write */
; 0000 004A while(EECR & (1<<EEWE))
;	uiAddress -> Y+0
_0xE:
	SBIC 0x1C,1
; 0000 004B ;
	RJMP _0xE
; 0000 004C /* Set up address register */
; 0000 004D EEAR = uiAddress;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x1E+1,R31
	OUT  0x1E,R30
; 0000 004E /* Start eeprom read by writing EERE */
; 0000 004F EECR |= (1<<EERE);
	SBI  0x1C,0
; 0000 0050 /* Return data from data register */
; 0000 0051 return EEDR;
	IN   R30,0x1D
	ADIW R28,2
	RET
; 0000 0052 }
;
;
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0058 {
_ext_int0_isr:
	RCALL SUBOPT_0x0
; 0000 0059 delay_ms(40);
; 0000 005A if(PIND.2==1){goto RET20;}
	SBIC 0x10,2
	RJMP _0x12
; 0000 005B SELECT0:
_0x13:
; 0000 005C MODE++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	SBIW R30,1
; 0000 005D MODESELECT=0XFF;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	MOVW R8,R30
; 0000 005E if (MODE>=4) {MODE=0;goto SELECT0;};
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CP   R6,R30
	CPC  R7,R31
	BRLO _0x14
	CLR  R6
	CLR  R7
	RJMP _0x13
_0x14:
; 0000 005F RET20:
_0x12:
; 0000 0060 EEPROM_write(0,MODE);
	RCALL SUBOPT_0x1
	ST   -Y,R6
	RJMP _0xB5
; 0000 0061 return;}
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)               //led(time) selector subroutin
; 0000 0065 {
_ext_int1_isr:
	RCALL SUBOPT_0x0
; 0000 0066 delay_ms(40);
; 0000 0067 if(PIND.3==1){goto RET;}
	SBIC 0x10,3
	RJMP _0x16
; 0000 0068 REAPEAT:
_0x17:
; 0000 0069 if (MODESELECT==0XFF) {MODESELECT=0;goto RET;};
	RCALL SUBOPT_0x2
	BRNE _0x18
	CLR  R8
	CLR  R9
	RJMP _0x16
_0x18:
; 0000 006A PORTC.1=1;
	SBI  0x15,1
; 0000 006B PORTC.2=1;
	SBI  0x15,2
; 0000 006C PORTC.3=1;
	SBI  0x15,3
; 0000 006D LED++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 006E if (LED==1){PORTC.1=0;goto RET;};
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	BRNE _0x1F
	CBI  0x15,1
	RJMP _0x16
_0x1F:
; 0000 006F if (LED==2){PORTC.2=0;goto RET;};
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	BRNE _0x22
	CBI  0x15,2
	RJMP _0x16
_0x22:
; 0000 0070 if (LED==3){PORTC.3=0;goto RET;};
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x4
	BRNE _0x25
	CBI  0x15,3
	RJMP _0x16
_0x25:
; 0000 0071 if (LED==4){LED=0;goto REAPEAT;};
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	RCALL SUBOPT_0x4
	BRNE _0x28
	CLR  R4
	CLR  R5
	RJMP _0x17
_0x28:
; 0000 0072 RET:
_0x16:
; 0000 0073 EEPROM_write(1,LED);
	RCALL SUBOPT_0x6
	ST   -Y,R4
_0xB5:
	RCALL _EEPROM_write
; 0000 0074 return;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0077 {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0078 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 0079 TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 007A OVERFLOW++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 007B TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 007C return;}
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;void T0N(void){       //timer0 on subroutin
; 0000 007F void T0N(void){
_T0N:
; 0000 0080   OVERFLOW=0;
	CLR  R10
	CLR  R11
; 0000 0081   TCCR0=0x05;
	LDI  R30,LOW(5)
	RJMP _0x2000001
; 0000 0082   TCNT0=0x06;
; 0000 0083   return;}
;
;void T0F(void){       //timer0 off subroutin
; 0000 0085 void T0F(void){
_T0F:
; 0000 0086   TCCR0=0x00;
	LDI  R30,LOW(0)
_0x2000001:
	OUT  0x33,R30
; 0000 0087   TCNT0=0x06;
	LDI  R30,LOW(6)
	OUT  0x32,R30
; 0000 0088   return;}
	RET
;
;
;
;void display(unsigned int DATA,unsigned int LOC){  // VOLTAGE DISPLAY SUBROUTIN
; 0000 008C void display(unsigned int DATA,unsigned int LOC){
_display:
; 0000 008D   // PORTD=PIND | 0X31 ;                            //RESET ADDRESS | 0X31       & 0XCE
; 0000 008E   // PORTB=0XFF;                                    //RESET DATA
; 0000 008F 
; 0000 0090    switch(LOC){
;	DATA -> Y+2
;	LOC -> Y+0
	LD   R30,Y
	LDD  R31,Y+1
; 0000 0091 
; 0000 0092    case 0:{
	SBIW R30,0
	BRNE _0x2C
; 0000 0093    PORTD.5=1;
	SBI  0x12,5
; 0000 0094    PORTD.4=1;
	SBI  0x12,4
; 0000 0095    PORTD.0=0;
	CBI  0x12,0
; 0000 0096    break; }
	RJMP _0x2B
; 0000 0097 
; 0000 0098    case 1:{
_0x2C:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x33
; 0000 0099    PORTD.5=1;
	SBI  0x12,5
; 0000 009A    PORTD.0=1;
	SBI  0x12,0
; 0000 009B    PORTD.4=0;
	CBI  0x12,4
; 0000 009C    break; }
	RJMP _0x2B
; 0000 009D 
; 0000 009E    case 2:{
_0x33:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x41
; 0000 009F    PORTD.0=1;
	SBI  0x12,0
; 0000 00A0    PORTD.4=1;
	SBI  0x12,4
; 0000 00A1    PORTD.5=0;
	CBI  0x12,5
; 0000 00A2    break; }
	RJMP _0x2B
; 0000 00A3 
; 0000 00A4    default:{
_0x41:
; 0000 00A5    PORTD.0=1;
	SBI  0x12,0
; 0000 00A6    PORTD.4=1;
	SBI  0x12,4
; 0000 00A7    PORTD.5=1;
	SBI  0x12,5
; 0000 00A8    break; }
; 0000 00A9  }
_0x2B:
; 0000 00AA 
; 0000 00AB    //PORTD=PIND & LOCCODE[LOC];                     //FIRST  LOCATION appointment   & LOCCODE[LOC]  | LOCCODE[LOC]
; 0000 00AC    PORTB=~SEGCODE[DATA];                          //NEXT SEND DATA
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	LDI  R26,LOW(_SEGCODE)
	LDI  R27,HIGH(_SEGCODE)
	RCALL SUBOPT_0x7
	LD   R30,X
	COM  R30
	OUT  0x18,R30
; 0000 00AD    return;}
	ADIW R28,4
	RET
;
;void numproduction(){           //digit preparation subroutin
; 0000 00AF void numproduction(){
_numproduction:
; 0000 00B0 
; 0000 00B1    X=NUM/100;
	RCALL SUBOPT_0x8
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	RCALL SUBOPT_0x9
; 0000 00B2    display(X,2);                //CALL VOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT
	RCALL SUBOPT_0xA
; 0000 00B3 
; 0000 00B4    X=(NUM/10)%10;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xB
	RCALL __DIVW21U
	MOVW R26,R30
	RCALL SUBOPT_0xB
	RCALL __MODW21U
	RCALL SUBOPT_0x9
; 0000 00B5    display(X,1);               //CALLVOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 00B6 
; 0000 00B7    X=NUM%10;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xB
	RCALL __MODW21U
	RCALL SUBOPT_0x9
; 0000 00B8    display(X,0);              //CALL VOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT
	RCALL SUBOPT_0x1
	RCALL _display
; 0000 00B9     return;}
	RET
;
; void ADD(){
; 0000 00BB void ADD(){
_ADD:
; 0000 00BC  for (i=0;i<=63;i++){
	RCALL SUBOPT_0xC
_0x49:
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRSH _0x4A
; 0000 00BD    AD+=read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	__ADDWRR 12,13,30,31
; 0000 00BE    numproduction();}
	RCALL _numproduction
	RCALL SUBOPT_0xE
	RJMP _0x49
_0x4A:
; 0000 00BF    AD=AD/64;
	MOVW R26,R12
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	RCALL __DIVW21U
	MOVW R12,R30
; 0000 00C0    NUM=(AD*10)/22;
	MOVW R30,R12
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	MOVW R26,R30
	LDI  R30,LOW(22)
	LDI  R31,HIGH(22)
	RCALL __DIVW21U
	STS  _NUM,R30
	STS  _NUM+1,R31
; 0000 00C1    return;}
	RET
;
;void main(void){
; 0000 00C3 void main(void){
_main:
; 0000 00C4 // Declare your local variables here
; 0000 00C5 
; 0000 00C6 // Input/Output Ports initialization
; 0000 00C7 // Port B initialization
; 0000 00C8 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00C9 // State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1
; 0000 00CA PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00CB DDRB=0xFF;
	OUT  0x17,R30
; 0000 00CC 
; 0000 00CD // Port C initialization
; 0000 00CE // Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 00CF // State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=T
; 0000 00D0 PORTC=0x7E;
	LDI  R30,LOW(126)
	OUT  0x15,R30
; 0000 00D1 DDRC=0x7E;
	OUT  0x14,R30
; 0000 00D2 
; 0000 00D3 // Port D initialization
; 0000 00D4 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=Out
; 0000 00D5 // State7=1 State6=1 State5=1 State4=1 State3=T State2=T State1=0 State0=1
; 0000 00D6 PORTD=0xF1;
	LDI  R30,LOW(241)
	OUT  0x12,R30
; 0000 00D7 DDRD=0xF3;
	LDI  R30,LOW(243)
	OUT  0x11,R30
; 0000 00D8 
; 0000 00D9 // Timer/Counter 0 initialization
; 0000 00DA // Clock source: System Clock
; 0000 00DB // Clock value: 0.977 kHz
; 0000 00DC TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00DD TCNT0=0x00;
	OUT  0x32,R30
; 0000 00DE 
; 0000 00DF // Timer/Counter 1 initialization
; 0000 00E0 // Clock source: System Clock
; 0000 00E1 // Clock value: Timer1 Stopped
; 0000 00E2 // Mode: Normal top=FFFFh
; 0000 00E3 // OC1A output: Discon.
; 0000 00E4 // OC1B output: Discon.
; 0000 00E5 // Noise Canceler: Off
; 0000 00E6 // Input Capture on Falling Edge
; 0000 00E7 // Timer1 Overflow Interrupt: Off
; 0000 00E8 // Input Capture Interrupt: Off
; 0000 00E9 // Compare A Match Interrupt: Off
; 0000 00EA // Compare B Match Interrupt: Off
; 0000 00EB TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00EC TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00ED TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00EE TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00EF ICR1H=0x00;
	OUT  0x27,R30
; 0000 00F0 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00F1 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00F2 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00F3 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00F4 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00F5 
; 0000 00F6 // Timer/Counter 2 initialization
; 0000 00F7 // Clock source: System Clock
; 0000 00F8 // Clock value: Timer2 Stopped
; 0000 00F9 // Mode: Normal top=FFh
; 0000 00FA // OC2 output: Disconnected
; 0000 00FB ASSR=0x00;
	OUT  0x22,R30
; 0000 00FC TCCR2=0x00;
	OUT  0x25,R30
; 0000 00FD TCNT2=0x00;
	OUT  0x24,R30
; 0000 00FE OCR2=0x00;
	OUT  0x23,R30
; 0000 00FF 
; 0000 0100 // External Interrupt(s) initialization
; 0000 0101 // INT0: On
; 0000 0102 // INT0 Mode: Falling Edge
; 0000 0103 // INT1: On
; 0000 0104 // INT1 Mode: Falling Edge
; 0000 0105 GICR|=0xC0;
	RCALL SUBOPT_0xF
; 0000 0106 MCUCR=0x0A;
	LDI  R30,LOW(10)
	OUT  0x35,R30
; 0000 0107 GIFR=0xC0;
	LDI  R30,LOW(192)
	OUT  0x3A,R30
; 0000 0108 
; 0000 0109 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 010A TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 010B 
; 0000 010C // Analog Comparator initialization
; 0000 010D // Analog Comparator: Off
; 0000 010E // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 010F ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0110 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0111 
; 0000 0112 // ADC initialization
; 0000 0113 // ADC Clock frequency: 500.000 kHz
; 0000 0114 // ADC Voltage Reference: AREF pin
; 0000 0115 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 0116 ADCSRA=0x89;
	LDI  R30,LOW(137)
	OUT  0x6,R30
; 0000 0117 
; 0000 0118 
; 0000 0119 
; 0000 011A // Global enable interrupts
; 0000 011B #asm("sei")
	sei
; 0000 011C //while(1){
; 0000 011D   GICR&=0x3F;
	RCALL SUBOPT_0x10
; 0000 011E   MODE=EEPROM_read(0);
	RCALL SUBOPT_0x1
	RCALL _EEPROM_read
	MOV  R6,R30
	CLR  R7
; 0000 011F   LED=EEPROM_read(1);
	RCALL SUBOPT_0x6
	RCALL _EEPROM_read
	MOV  R4,R30
	CLR  R5
; 0000 0120   if (LED==1){PORTC.1=0;goto FIRST;};
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	BRNE _0x4B
	CBI  0x15,1
	RJMP _0x4E
_0x4B:
; 0000 0121   if (LED==2){PORTC.2=0;goto FIRST;};
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x4
	BRNE _0x4F
	CBI  0x15,2
	RJMP _0x4E
_0x4F:
; 0000 0122   if (LED==3){PORTC.3=0;goto FIRST;};
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x4
	BRNE _0x52
	CBI  0x15,3
_0x52:
; 0000 0123   FIRST:
_0x4E:
; 0000 0124   PORTD.1=0;          //relay off
	CBI  0x12,1
; 0000 0125 
; 0000 0126   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x58:
	RCALL SUBOPT_0x11
	BRSH _0x59
; 0000 0127   display(18,2);         //NON on 7seg
	RCALL SUBOPT_0x12
; 0000 0128   }
	RCALL SUBOPT_0xE
	RJMP _0x58
_0x59:
; 0000 0129 
; 0000 012A   for(i1=0;i1<=1;i1++){
	LDI  R30,LOW(0)
	STS  _i1,R30
	STS  _i1+1,R30
_0x5B:
	LDS  R26,_i1
	LDS  R27,_i1+1
	SBIW R26,2
	BRLO PC+2
	RJMP _0x5C
; 0000 012B 
; 0000 012C   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x5E:
	RCALL SUBOPT_0x11
	BRSH _0x5F
; 0000 012D   display(16,0);          // F on seg
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x1
	RCALL _display
; 0000 012E   }
	RCALL SUBOPT_0xE
	RJMP _0x5E
_0x5F:
; 0000 012F 
; 0000 0130   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x61:
	RCALL SUBOPT_0x11
	BRSH _0x62
; 0000 0131   display(16,1);           //F on 7seg
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x14
; 0000 0132   display(17,0);         //A on 7seg
	RCALL _display
; 0000 0133   }
	RCALL SUBOPT_0xE
	RJMP _0x61
_0x62:
; 0000 0134 
; 0000 0135   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x64:
	RCALL SUBOPT_0x11
	BRSH _0x65
; 0000 0136   display(16,2);           //F on 7seg
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0xA
; 0000 0137   display(17,1);         //A on 7seg
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 0138   display(11,0);}         //R on 7seg
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x1
	RCALL _display
	RCALL SUBOPT_0xE
	RJMP _0x64
_0x65:
; 0000 0139 
; 0000 013A   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x67:
	RCALL SUBOPT_0x11
	BRSH _0x68
; 0000 013B   display(17,2);           //A on 7seg
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xA
; 0000 013C   display(11,1);         //R on 7seg
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x14
; 0000 013D   display(17,0);}         //A on 7seg
	RCALL _display
	RCALL SUBOPT_0xE
	RJMP _0x67
_0x68:
; 0000 013E 
; 0000 013F   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x6A:
	RCALL SUBOPT_0x11
	BRSH _0x6B
; 0000 0140   display(11,2);          //R on seg
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0xA
; 0000 0141   display(17,1);         //A on 7seg
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 0142   }
	RCALL SUBOPT_0xE
	RJMP _0x6A
_0x6B:
; 0000 0143 
; 0000 0144   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x6D:
	RCALL SUBOPT_0x11
	BRSH _0x6E
; 0000 0145   display(17,2);         //A on 7seg
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0xA
; 0000 0146   }
	RCALL SUBOPT_0xE
	RJMP _0x6D
_0x6E:
; 0000 0147 
; 0000 0148   for(i=0;i<=18000;i++){
	RCALL SUBOPT_0xC
_0x70:
	RCALL SUBOPT_0x11
	BRSH _0x71
; 0000 0149   display(18,2);         //NON on 7seg
	RCALL SUBOPT_0x12
; 0000 014A   } }
	RCALL SUBOPT_0xE
	RJMP _0x70
_0x71:
	LDI  R26,LOW(_i1)
	LDI  R27,HIGH(_i1)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x5B
_0x5C:
; 0000 014B 
; 0000 014C   T0N();
	RCALL _T0N
; 0000 014D   TIR00:
_0x72:
; 0000 014E   NUM=SCALE[LED-1]-(OVERFLOW/32);         //TIMER VALUE initialize
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 014F   numproduction();                       // timer display
; 0000 0150   if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;goto start;}            //TIMER0 overflow cheker
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	BRLO _0x73
	RCALL _T0F
	RCALL SUBOPT_0xF
	RJMP _0x74
; 0000 0151   goto TIR00;
_0x73:
	RJMP _0x72
; 0000 0152 
; 0000 0153 
; 0000 0154 
; 0000 0155 
; 0000 0156 
; 0000 0157  start:
_0x74:
; 0000 0158 
; 0000 0159 
; 0000 015A 
; 0000 015B  if (MODESELECT==0XFF) {goto SELECT1;};
	RCALL SUBOPT_0x2
	BRNE _0x75
	RJMP _0x76
_0x75:
; 0000 015C  ADD();
	RCALL _ADD
; 0000 015D  if (AD > OUV[MODE-1]&& MODESELECT==0) {PORTD.1=0;PORTC.4=1;GICR&=0x3F;T0N();goto OVER;}    //over voltage checker
	RCALL SUBOPT_0x1C
	RCALL __GETW1P
	RCALL SUBOPT_0x1D
	BRSH _0x78
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x79
_0x78:
	RJMP _0x77
_0x79:
	CBI  0x12,1
	SBI  0x15,4
	RCALL SUBOPT_0x10
	RCALL _T0N
	RJMP _0x7E
; 0000 015E  if (AD <= OUV[MODE+2]&& MODESELECT==0) {PORTD.1=0;PORTC.4=1;GICR&=0x3F;T0N();goto LOW;}    //under voltage checker
_0x77:
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
	BRLO _0x80
	CLR  R0
	CP   R0,R8
	CPC  R0,R9
	BREQ _0x81
_0x80:
	RJMP _0x7F
_0x81:
	CBI  0x12,1
	SBI  0x15,4
	RCALL SUBOPT_0x10
	RCALL _T0N
	RJMP _0x86
; 0000 015F  PORTD.1=1;                                                //relay on
_0x7F:
	SBI  0x12,1
; 0000 0160   PORTC.4=0;                                               //pwr led on
	CBI  0x15,4
; 0000 0161  for(i=0;i<=3500;i++){                                     //  display voltage for 3500 cycle
	RCALL SUBOPT_0xC
_0x8C:
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0xDAD)
	LDI  R30,HIGH(0xDAD)
	CPC  R27,R30
	BRSH _0x8D
; 0000 0162  numproduction();}
	RCALL _numproduction
	RCALL SUBOPT_0xE
	RJMP _0x8C
_0x8D:
; 0000 0163  goto start;
	RJMP _0x74
; 0000 0164 
; 0000 0165 
; 0000 0166   OVER:
_0x7E:
; 0000 0167   for(i=0;i<=17000;i++){                                   // HI display loop
	RCALL SUBOPT_0xC
_0x8F:
	RCALL SUBOPT_0x1F
	BRSH _0x90
; 0000 0168   if(OVERFLOW>=760){PORTC.5=1;T0F();goto ED;};             //check buzzer on off timer
	RCALL SUBOPT_0x20
	BRLO _0x91
	SBI  0x15,5
	RCALL _T0F
	RJMP _0x94
_0x91:
; 0000 0169   PORTC.5=0;                                               //buzzer on
	CBI  0x15,5
; 0000 016A   ED:
_0x94:
; 0000 016B   display(18,2);                                          //non on 7seg
	RCALL SUBOPT_0x12
; 0000 016C   display(19,1);                                          //H on 7seg
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 016D   display(20,0);}                                         //I on 7seg
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1
	RCALL _display
	RCALL SUBOPT_0xE
	RJMP _0x8F
_0x90:
; 0000 016E   PORTC.5=1;                                              //buzzer off
	SBI  0x15,5
; 0000 016F   ADD();                                                  // read voltage
	RCALL _ADD
; 0000 0170   for(i=0;i<=3000;i++){                                   //  display voltage for 3500 cycle
	RCALL SUBOPT_0xC
_0x9A:
	RCALL SUBOPT_0x22
	BRSH _0x9B
; 0000 0171   numproduction();}
	RCALL _numproduction
	RCALL SUBOPT_0xE
	RJMP _0x9A
_0x9B:
; 0000 0172   if (AD > (OUV[MODE-1])-10) {goto OVER;}                 //over voltage checker
	RCALL SUBOPT_0x1C
	RCALL __GETW1P
	SBIW R30,10
	RCALL SUBOPT_0x1D
	BRLO _0x7E
; 0000 0173   T0N();                                                  //timer0 on
	RCALL _T0N
; 0000 0174 
; 0000 0175   TIR0:                                                   // return to normal mode timer loop
_0x9D:
; 0000 0176   if (AD > (OUV[MODE-1])-10) {goto OVER;}                 //over voltage checker
	RCALL SUBOPT_0x1C
	RCALL __GETW1P
	SBIW R30,10
	RCALL SUBOPT_0x1D
	BRLO _0x7E
; 0000 0177   NUM=SCALE[LED-1]-(OVERFLOW/32);                         //TIMER VALUE initialize
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 0178   numproduction();                                        // timer display
; 0000 0179   if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;delay_ms(100);goto start;}          //TIMER0 overflow cheker
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	BRLO _0x9F
	RCALL _T0F
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x23
	RJMP _0x74
; 0000 017A   if(OVERFLOW>=(OVERFLOWSCALE[LED-1])-50){ADD();goto TIR0;}                                //checck voltage
_0x9F:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x24
	BRLO _0xA0
	RCALL _ADD
	RJMP _0x9D
; 0000 017B   goto TIR0;
_0xA0:
	RJMP _0x9D
; 0000 017C 
; 0000 017D   LOW:
_0x86:
; 0000 017E   for(i=0;i<=17000;i++){                                     // LOV display loop
	RCALL SUBOPT_0xC
_0xA2:
	RCALL SUBOPT_0x1F
	BRSH _0xA3
; 0000 017F   if(OVERFLOW>=760){PORTC.5=1;T0F();goto ED1;};              //check buzzer on off time
	RCALL SUBOPT_0x20
	BRLO _0xA4
	SBI  0x15,5
	RCALL _T0F
	RJMP _0xA7
_0xA4:
; 0000 0180   PORTC.5=0;                                                 //buzzer on
	CBI  0x15,5
; 0000 0181   ED1:
_0xA7:
; 0000 0182   display(12,2);                                            //L on 7seg
	LDI  R30,LOW(12)
	LDI  R31,HIGH(12)
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0xA
; 0000 0183   display(0,1);                                             //O on 7seg
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 0184   display(10,0);}                                           //V on 7seg
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1
	RCALL _display
	RCALL SUBOPT_0xE
	RJMP _0xA2
_0xA3:
; 0000 0185   PORTC.5=1;                                                //buzzer off
	SBI  0x15,5
; 0000 0186   ADD();                                                    // read voltage
	RCALL _ADD
; 0000 0187   for(i=0;i<=3000;i++){                                     //  display voltage for 3500 cycle
	RCALL SUBOPT_0xC
_0xAD:
	RCALL SUBOPT_0x22
	BRSH _0xAE
; 0000 0188   numproduction();}
	RCALL _numproduction
	RCALL SUBOPT_0xE
	RJMP _0xAD
_0xAE:
; 0000 0189   if (AD <= (OUV[MODE+2])+10) {goto LOW;}                   //under voltage checker
	RCALL SUBOPT_0x1E
	ADIW R30,10
	RCALL SUBOPT_0x1D
	BRSH _0x86
; 0000 018A 
; 0000 018B   T0N();                                                    //timer0 on
	RCALL _T0N
; 0000 018C   TIR1:                                                     // return to normal mode timer loop
_0xB0:
; 0000 018D   if (AD <= (OUV[MODE+2])+10) {goto LOW;}                   //undervoltage checker
	RCALL SUBOPT_0x1E
	ADIW R30,10
	RCALL SUBOPT_0x1D
	BRSH _0x86
; 0000 018E   NUM=SCALE[LED-1]-(OVERFLOW/32);                           //TIMER VALUE initialize
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x19
; 0000 018F   numproduction();                                          // timer display
; 0000 0190   if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;delay_ms(100);goto start;}       //TIMER0 overflow cheker
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	BRLO _0xB2
	RCALL _T0F
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x23
	RJMP _0x74
; 0000 0191   if(OVERFLOW>=(OVERFLOWSCALE[LED-1])-50){ADD();goto TIR1;}                            //checck voltage
_0xB2:
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x24
	BRLO _0xB3
	RCALL _ADD
	RJMP _0xB0
; 0000 0192   goto TIR1;
_0xB3:
	RJMP _0xB0
; 0000 0193 
; 0000 0194   SELECT1:
_0x76:
; 0000 0195   if (MODESELECT==0) {goto start;};
	MOV  R0,R8
	OR   R0,R9
	BRNE _0xB4
	RJMP _0x74
_0xB4:
; 0000 0196   display(13,2);
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0xA
; 0000 0197   display(14,1);
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x6
	RCALL _display
; 0000 0198   display(MODE,0);
	ST   -Y,R7
	ST   -Y,R6
	RCALL SUBOPT_0x1
	RCALL _display
; 0000 0199   goto SELECT1;
	RJMP _0x76
; 0000 019A  }

	.DSEG
_i:
	.BYTE 0x2
_i1:
	.BYTE 0x2
_X:
	.BYTE 0x2
_NUM:
	.BYTE 0x2
_SEGCODE:
	.BYTE 0x2A
_OUV:
	.BYTE 0xC
_SCALE:
	.BYTE 0x6
_OVERFLOWSCALE:
	.BYTE 0x6

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R8
	CPC  R31,R9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x3
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x7:
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDS  R26,_NUM
	LDS  R27,_NUM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x9:
	STS  _X,R30
	STS  _X+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA:
	RCALL SUBOPT_0x5
	ST   -Y,R31
	ST   -Y,R30
	RJMP _display

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:50 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xD:
	LDS  R26,_i
	LDS  R27,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:76 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	IN   R30,0x3B
	ORI  R30,LOW(0xC0)
	OUT  0x3B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	IN   R30,0x3B
	ANDI R30,LOW(0x3F)
	OUT  0x3B,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0x4651)
	LDI  R30,HIGH(0x4651)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	RCALL _display
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	MOVW R30,R4
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_SCALE)
	LDI  R27,HIGH(_SCALE)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x19:
	LD   R22,X+
	LD   R23,X
	MOVW R26,R10
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	RCALL __DIVW21U
	MOVW R26,R22
	SUB  R26,R30
	SBC  R27,R31
	STS  _NUM,R26
	STS  _NUM+1,R27
	RCALL _numproduction
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_OVERFLOWSCALE)
	LDI  R27,HIGH(_OVERFLOWSCALE)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1B:
	RCALL __GETW1P
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	MOVW R30,R6
	SBIW R30,1
	LDI  R26,LOW(_OUV)
	LDI  R27,HIGH(_OUV)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	CP   R30,R12
	CPC  R31,R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1E:
	MOVW R26,R6
	LSL  R26
	ROL  R27
	__ADDW2MN _OUV,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0x4269)
	LDI  R30,HIGH(0x4269)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(760)
	LDI  R31,HIGH(760)
	CP   R10,R30
	CPC  R11,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	RCALL SUBOPT_0xD
	CPI  R26,LOW(0xBB9)
	LDI  R30,HIGH(0xBB9)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x21
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	RCALL __GETW1P
	SBIW R30,50
	CP   R10,R30
	CPC  R11,R31
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

;END OF CODE MARKER
__END_OF_CODE:
