ENTRY(__ENTRY)
MEMORY
{  
	    sdram (wx)  : org = 0x30000000,   len = 64M
}
SECTIONS
{
	.text 0x30000000 : AT(0x0)
	{
		text_load_addr = LOADADDR(.text);
		text_start = .;
	       	* (.text)
     		* (.init.text)
			* (.rodata*)
	}>sdram 
	
	.data ALIGN(4):
	{  
		* (.data)
	} >sdram
	
	.bss ALIGN(4): 
	{ 
		bss_start = .;  
		bss_load_addr = bss_start - 0x30000000;  
		* (.bss)
     		. = ALIGN(4) ;
	} >sdram
	bss_end = .;    

	stack_base = 0x33ffff00;
	MMU_base   =   0x33f00000;

	SYS_stack_size   =  0x200;      
	SVC_stack_size   =  0x200;    
	Undef_stack_size =  0x100;        
	Abort_stack_size =  0x100;     
	IRQ_stack_size   =  0x200;       
	FIQ_stack_size   =  0x0;   

	FIQ_stack        =  stack_base; 
	IRQ_stack        =  FIQ_stack   - FIQ_stack_size;  
	ABT_stack      =  IRQ_stack   - IRQ_stack_size;  
	UDF_stack      =  ABT_stack - Abort_stack_size;    
	SVC_stack        =  UDF_stack - Undef_stack_size;    
	SYS_stack        =  SVC_stack   - SVC_stack_size;  
	heap_start = (bss_end + 3)&( ~ 3);  
	heap_end = MMU_base - 0x1000;
}  
