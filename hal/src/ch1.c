#include "ch1.h"

int acoral_start(){
	rCLKDIVN = 0X5;	
	rMPLLCON = (0X7f<<12) | (0X2<<4) | (0X1);
	rGPGCON = 0;			//检测按键状态
	while(1){
		if((rGPGDAT & 0x1)==0)
        	break;
		}
	rTCFG0 |= 0xF9;			/* prescaler等于249*/
 	rTCFG1 |= 0x3;			/*divider等于16*/
   	rTCNTB0 = 0X61A9;          		/*计数值25001*/
   	rTCON = rTCON & (~0xf) |0x02;           	/* 更新TCNT0*/
	rTCON = rTCON & (~0xf) |0x01; 	/* start定时器0*/
	while(1){
		if(rTCNTO0 == 1)		/*倒计时到1，两秒*/
        	break;
		}
	rGPBCON = 0x400;			
	rGPBDAT = 0x1C0; 			//点亮LED
	while(1);
}

