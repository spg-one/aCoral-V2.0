#include <stdio.h>
#include<string.h>
#include<stdlib.h>

int main(int argc, char *argv[])
{
    system("dir /B .\\include >> temp.txt");
    FILE *in= fopen("temp.txt", "r");
    FILE *out = fopen("include/acoral.h", "w");
 
    char buf[1024];
    char* a = "#ifndef ACORAL_H\n";
    char* b = "#define ACORAL_H\n";
    char* c = "#endif";
    char* d = "#include \"";
    char* e = "\n";
    fputs(a, out);
    fputs(b, out);
    while (fgets(buf, sizeof(buf), in) != NULL)
    {
        fputs(d, out);
        char *find = strchr(buf, '\n');  //找出data中的"\n"
        if(find)
            *find = '\"';   //替换
        fputs(buf, out);
        fputs(e, out);
    }
    fputs(c, out);
    fclose(in);
    fclose(out);
    system("del temp.txt");
    return 0;
}