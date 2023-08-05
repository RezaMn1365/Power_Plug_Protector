/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
© Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :PROTECTOR 
Version :1 
Date    : 3/11/2012
Author  : REZA MOSAVIAN
Company : RM 
Comments:       
Chip type               : ATmega8L
Program type            : Application
AVR Core Clock frequency: 1.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>
#include <delay.h>      


// Declare your global variables here  
unsigned short LED=0,MODE=0,MODESELECT=0;              
unsigned int OVERFLOW,AD,i,i1,X,NUM;   

                                                                // CODE 7SEG    V    r    L   ____M____  N    F    A  NON H    I  
unsigned short SEGCODE[21]= {0x3F,0x06,0x5B,0x4F,0x66,0x6D,0x7D,0x07,0x7F,0x6F,0X3E,0X31,0X38,0x33,0x27,0X37,0x71,0x77,0,0x76,0x30}; 
unsigned short LOCCODE[3] = {0XFE,0XEF,0XDF};                           // BA PORT D OR SHAVAD   {0XFE,0XEF,0XDF};
        //REAL VOLTAGE 260 250 240 160 170 185
unsigned int OUV[6] = {575,550,530,354,370,396};
unsigned int SCALE[3] = {30,75,240};
unsigned int OVERFLOWSCALE[3]={960,2400,7680}; //{117,293,879}

#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

 
   
 void EEPROM_write(unsigned int uiAddress, unsigned char ucData)
{
/* Wait for completion of previous write */
while(EECR & (1<<EEWE))
;
/* Set up address and data registers */
EEAR = uiAddress;
EEDR = ucData;
/* Write logical one to EEMWE */
EECR |= (1<<EEMWE);
/* Start eeprom write by setting EEWE */
EECR |= (1<<EEWE);
return;} 


unsigned char EEPROM_read(unsigned int uiAddress)
{
/* Wait for completion of previous write */
while(EECR & (1<<EEWE))
;
/* Set up address register */
EEAR = uiAddress;
/* Start eeprom read by writing EERE */
EECR |= (1<<EERE);
/* Return data from data register */
return EEDR;
}  
 

               
// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
delay_ms(40);
if(PIND.2==1){goto RET20;}
SELECT0:
MODE++;
MODESELECT=0XFF;
if (MODE>=4) {MODE=0;goto SELECT0;};    
RET20: 
EEPROM_write(0,MODE);                         
return;}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)               //led(time) selector subroutin
{
delay_ms(40);
if(PIND.3==1){goto RET;}
REAPEAT:
if (MODESELECT==0XFF) {MODESELECT=0;goto RET;};
PORTC.1=1;
PORTC.2=1;
PORTC.3=1;
LED++;
if (LED==1){PORTC.1=0;goto RET;};
if (LED==2){PORTC.2=0;goto RET;};
if (LED==3){PORTC.3=0;goto RET;};
if (LED==4){LED=0;goto REAPEAT;};    
RET:
EEPROM_write(1,LED);                    
return;}
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
TCCR0=0x00;
TCNT0=0x06;
OVERFLOW++;
TCCR0=0x05;        
return;}

 
void T0N(void){       //timer0 on subroutin
  OVERFLOW=0;
  TCCR0=0x05;  
  TCNT0=0x06;
  return;}
  
void T0F(void){       //timer0 off subroutin
  TCCR0=0x00;  
  TCNT0=0x06;
  return;}  
  
  

void display(unsigned int DATA,unsigned int LOC){  // VOLTAGE DISPLAY SUBROUTIN
  // PORTD=PIND | 0X31 ;                            //RESET ADDRESS | 0X31       & 0XCE
  // PORTB=0XFF;                                    //RESET DATA                                                   
   
   switch(LOC){ 
   
   case 0:{
   PORTD.5=1;
   PORTD.4=1;
   PORTD.0=0;     
   break; }  
   
   case 1:{
   PORTD.5=1; 
   PORTD.0=1; 
   PORTD.4=0;         
   break; }
   
   case 2:{    
   PORTD.0=1; 
   PORTD.4=1;
   PORTD.5=0;         
   break; }
    
   default:{
   PORTD.0=1; 
   PORTD.4=1;
   PORTD.5=1;         
   break; }
 }                          
                                                                                               
   //PORTD=PIND & LOCCODE[LOC];                     //FIRST  LOCATION appointment   & LOCCODE[LOC]  | LOCCODE[LOC]
   PORTB=~SEGCODE[DATA];                          //NEXT SEND DATA                                
   return;}                     
   
void numproduction(){           //digit preparation subroutin
   
   X=NUM/100;
   display(X,2);                //CALL VOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT

   X=(NUM/10)%10;                                                                                                                                                      
   display(X,1);               //CALLVOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT

   X=NUM%10;
   display(X,0);              //CALL VOLTAGE SUBROUTIN WITH DATA AND LOCATION CODE AS INPUT    
    return;} 
    
 void ADD(){ 
 for (i=0;i<=63;i++){
   AD+=read_adc(0);
   numproduction();}      
   AD=AD/64;                         
   NUM=(AD*10)/22;
   return;}    
 
void main(void){
// Declare your local variables here

// Input/Output Ports initialization
// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=1 State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=1 
PORTB=0xFF;
DDRB=0xFF;

// Port C initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State6=1 State5=1 State4=1 State3=1 State2=1 State1=1 State0=T 
PORTC=0x7E;
DDRC=0x7E;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=Out Func0=Out 
// State7=1 State6=1 State5=1 State4=1 State3=T State2=T State1=0 State0=1 
PORTD=0xF1;
DDRD=0xF3;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 0.977 kHz
TCCR0=0x00;
TCNT0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
GICR|=0xC0;
MCUCR=0x0A;
GIFR=0xC0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 500.000 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x89;



// Global enable interrupts
#asm("sei")
//while(1){
  GICR&=0x3F; 
  MODE=EEPROM_read(0);
  LED=EEPROM_read(1);  
  if (LED==1){PORTC.1=0;goto FIRST;};
  if (LED==2){PORTC.2=0;goto FIRST;};
  if (LED==3){PORTC.3=0;goto FIRST;};
  FIRST:
  PORTD.1=0;          //relay off
  
  for(i=0;i<=18000;i++){
  display(18,2);         //NON on 7seg
  }
         
  for(i1=0;i1<=1;i1++){  
  
  for(i=0;i<=18000;i++){
  display(16,0);          // F on seg
  }        
  
  for(i=0;i<=18000;i++){
  display(16,1);           //F on 7seg
  display(17,0);         //A on 7seg
  }        
  
  for(i=0;i<=18000;i++){
  display(16,2);           //F on 7seg
  display(17,1);         //A on 7seg
  display(11,0);}         //R on 7seg   
  
  for(i=0;i<=18000;i++){
  display(17,2);           //A on 7seg
  display(11,1);         //R on 7seg
  display(17,0);}         //A on 7seg                 
  
  for(i=0;i<=18000;i++){
  display(11,2);          //R on seg  
  display(17,1);         //A on 7seg            
  }        
  
  for(i=0;i<=18000;i++){
  display(17,2);         //A on 7seg
  }                           
  
  for(i=0;i<=18000;i++){
  display(18,2);         //NON on 7seg
  } }
  
  T0N();
  TIR00:
  NUM=SCALE[LED-1]-(OVERFLOW/32);         //TIMER VALUE initialize 
  numproduction();                       // timer display
  if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;goto start;}            //TIMER0 overflow cheker              
  goto TIR00;


                                        
         
  
 start:   
 
 

 if (MODESELECT==0XFF) {goto SELECT1;};  
 ADD();               
 if (AD > OUV[MODE-1]&& MODESELECT==0) {PORTD.1=0;PORTC.4=1;GICR&=0x3F;T0N();goto OVER;}    //over voltage checker
 if (AD <= OUV[MODE+2]&& MODESELECT==0) {PORTD.1=0;PORTC.4=1;GICR&=0x3F;T0N();goto LOW;}    //under voltage checker
 PORTD.1=1;                                                //relay on            
  PORTC.4=0;                                               //pwr led on      
 for(i=0;i<=3500;i++){                                     //  display voltage for 3500 cycle
 numproduction();}             
 goto start;                        
  
   
  OVER:                
  for(i=0;i<=17000;i++){                                   // HI display loop
  if(OVERFLOW>=760){PORTC.5=1;T0F();goto ED;};             //check buzzer on off timer     
  PORTC.5=0;                                               //buzzer on
  ED:                     
  display(18,2);                                          //non on 7seg
  display(19,1);                                          //H on 7seg
  display(20,0);}                                         //I on 7seg 
  PORTC.5=1;                                              //buzzer off
  ADD();                                                  // read voltage
  for(i=0;i<=3000;i++){                                   //  display voltage for 3500 cycle
  numproduction();}                
  if (AD > (OUV[MODE-1])-10) {goto OVER;}                 //over voltage checker         
  T0N();                                                  //timer0 on  
  
  TIR0:                                                   // return to normal mode timer loop
  if (AD > (OUV[MODE-1])-10) {goto OVER;}                 //over voltage checker 
  NUM=SCALE[LED-1]-(OVERFLOW/32);                         //TIMER VALUE initialize         
  numproduction();                                        // timer display
  if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;delay_ms(100);goto start;}          //TIMER0 overflow cheker     
  if(OVERFLOW>=(OVERFLOWSCALE[LED-1])-50){ADD();goto TIR0;}                                //checck voltage
  goto TIR0; 
  
  LOW:    
  for(i=0;i<=17000;i++){                                     // LOV display loop
  if(OVERFLOW>=760){PORTC.5=1;T0F();goto ED1;};              //check buzzer on off time      
  PORTC.5=0;                                                 //buzzer on
  ED1:                                                   
  display(12,2);                                            //L on 7seg
  display(0,1);                                             //O on 7seg
  display(10,0);}                                           //V on 7seg 
  PORTC.5=1;                                                //buzzer off
  ADD();                                                    // read voltage
  for(i=0;i<=3000;i++){                                     //  display voltage for 3500 cycle
  numproduction();}       
  if (AD <= (OUV[MODE+2])+10) {goto LOW;}                   //under voltage checker
     
  T0N();                                                    //timer0 on     
  TIR1:                                                     // return to normal mode timer loop
  if (AD <= (OUV[MODE+2])+10) {goto LOW;}                   //undervoltage checker
  NUM=SCALE[LED-1]-(OVERFLOW/32);                           //TIMER VALUE initialize 
  numproduction();                                          // timer display
  if(OVERFLOW>=OVERFLOWSCALE[LED-1]){T0F();GICR|=0xC0;delay_ms(100);goto start;}       //TIMER0 overflow cheker   
  if(OVERFLOW>=(OVERFLOWSCALE[LED-1])-50){ADD();goto TIR1;}                            //checck voltage
  goto TIR1;   
  
  SELECT1: 
  if (MODESELECT==0) {goto start;};       
  display(13,2);   
  display(14,1);
  display(MODE,0);                                          
  goto SELECT1;    
 }
