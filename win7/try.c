 #define     BUFFSIZE        128u            
 Boolean_e
 is_string_matched_regex (
         const char *filename,                  
         const char *pattern                    
         )
 {
     Boolean_e   is_matched = FALSE;
     uint32  matched_no = 0;
     uint32  ret = 0;
     uint8   err_buf[BUFFSIZE] = {0};

     regex_t reg;
     regmatch_t pm[10];                          
     const size_t nmatch = 10;

     RETURN_VAL_IF_FAIL(filename == NULL, FALSE);
     RETURN_VAL_IF_FAIL(pattern != NULL, FALSE);

 #ifdef  DEBUG
     printf("%s is processing...\n",__FUNCTION__);
 #endif

     
     ret = regcomp(&reg, pattern, REG_EXTENDED|REG_ICASE|REG_NEWLINE);
     if (ret != 0)
     {
         regerror(ret, &reg, err_buf, sizeof(err_buf));
         fprintf(stderr, "%s: filename '%s' \n", err_buf,filename);
         is_matched = FALSE;

         return(is_matched);
     }

     
     ret = regexec(&reg, filename, nmatch, pm, 0);

     if (ret == REG_NOMATCH )
     {
         is_matched = FALSE;

         return(is_matched);
     }
     else
         if (ret != 0)
         {
             regerror(ret, &reg, err_buf, sizeof(err_buf));
             fprintf(stderr, "%s: regcom('%s')\n", err_buf, filename);
             is_matched = FALSE;

             return(is_matched);
         }

     
     for (matched_no = 0; matched_no < nmatch && pm[matched_no].rm_so != -1; ++ matched_no)
     {
         

         if( pm[matched_no].rm_so == 0
                 && pm[matched_no].rm_eo == strlen(filename))
         {
             is_matched = TRUE;
             break;
         }
     }

     
     regfree(&reg);

     return(is_matched);
 }      
//实现单个文件名与正则表达式的匹配之后，只需要遍历当前目录下的所有文件名，
//重复匹配。测试程序如下：
int main(int argc, char *argv[])
 {
     Boolean_e is_matched = FALSE;
     uint16  file_no = 0;

     DIR *dp = NULL;
     struct   dirent   *dirp = NULL;

     
     if((dp = opendir("."))== NULL)
     {
         printf("can't open the current directoty!\n");
         exit(0);
     }

     
     while((dirp = readdir(dp))!=NULL)
     {
         file_no++;
         is_matched = is_string_matched_regex(dirp->d_name, argv[1]);

 #ifdef  DEBUG
         if( is_matched == TRUE )
         {
             printf("file_no:%d---filename:%s\n",file_no, dirp->d_name);
         }
 #endif    
     }

     closedir(dp);

     return 0;
 }