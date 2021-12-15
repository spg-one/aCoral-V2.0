

#define rGPGCON    (*(volatile unsigned int *)0x56000060)	/*Port G control*/
#define rGPGDAT    (*(volatile unsigned int *)0x56000064)	/*Port G data*/
#define rGPGUP     (*(volatile unsigned int *)0x56000068)	/*Pull-up control G*/
#define rGPBCON    (*(volatile unsigned int *)0x56000010)	/*Port B control*/
#define rGPBDAT    (*(volatile unsigned int *)0x56000014)	/*Port B data*/
#define rGPBUP     (*(volatile unsigned int *)0x56000018)	/*Pull-up control B*/
#define rCLKDIVN   (*(volatile unsigned int *)0x4C000014)
#define rMPLLCON   (*(volatile unsigned int *)0x4C000004)
#define rTCFG0  (*(volatile unsigned int *)0x51000000)	/*Timer 0 configuration*/
#define rTCFG1  (*(volatile unsigned int *)0x51000004)	/*Timer 1 configuration*/
#define rTCON   (*(volatile unsigned int *)0x51000008)	/*Timer control*/
#define rTCNTB0 (*(volatile unsigned int *)0x5100000c)	/*Timer count buffer 0*/
#define rTCMPB0 (*(volatile unsigned int *)0x51000010)	/*Timer compare buffer 0*/
#define rTCNTO0 (*(volatile unsigned int *)0x51000014)	/*Timer count observation 0*/

