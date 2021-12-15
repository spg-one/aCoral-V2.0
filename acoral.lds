ENTRY(_start)
MEMORY
{  
	    ram (wx)  : org = 0x030000000,   len = 64M
}
SECTIONS
{
	.text : 
	{
		text_start = .;
	       	* (.text)
     		* (.init.text)
		* (.rodata*)
	}>ram 
	
	.data ALIGN(4):
	{  
		* (.data)
	} >ram
	
	.bss ALIGN(4): 
	{ 
		bss_start = .;    
		* (.bss)
     		. = ALIGN(4) ;
	} >ram
	bss_end = .;    

	
}  
