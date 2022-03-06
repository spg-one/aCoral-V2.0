#include "acoral.h"

acoral_thread_t orig_thread;
/*================================
 * Entry c function of start.S 
 *       c语言初始化入口函数
 *================================*/
void acoral_start(){
	
#ifdef CFG_CMP
      	static int core_cpu=1;
	if(!core_cpu){
		acoral_set_orig_thread(&orig_thread);
		/*其他次cpu core的开始函数,不会返回的*/
		acoral_follow_cpu_start();
	}
	core_cpu=0;
	HAL_CORE_CPU_INIT();
#endif
	orig_thread.console_id=ACORAL_DEV_ERR_ID;
	acoral_set_orig_thread(&orig_thread);
	/*板子初始化*/
	HAL_BOARD_INIT();

	/*内核模块初始化*/
	acoral_module_init();

	/*串口终端应该初始化好了，将根线程的终端id设置为串口终端*/
#ifdef CFG_DRIVER
	orig_thread.console_id=acoral_dev_open("console");
	acoral_prints("hello spg");
#endif

#ifdef CFG_CMP
	/*cmp初始化*/
    	acoral_cmp_init();
#endif

	/*主cpu开始函数*/
	acoral_core_cpu_start();
}