/* 
    In-place Search & Replace (ipsr) - 2007-04-16
    Copyright(c) qala@telenet.be, subspawn@gmail.com
    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    at your option) any later version.
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
 */
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h> /* close */

int main(int argc, char *argv[]);
// convert 1 hexchar to char
char hex2char( char c ){
  char ret=0;
  if(c >= '0' && c <= '9') ret = c - '0';
  if(c >= 'a' && c <= 'z') ret = c - 'a' + 10;
  if(c >= 'A' && c <= 'Z') ret = c - 'A' + 10;
  //printf("%c -> %d\n",c,ret);
  return ret;
}
/* input : either a string or something starting
   with "0x", in which case the string is interpreted as a hex
   representation
   returns the length of the string or the converted hex lenght
   we put the converted binary code where the binary code was*/
int str2bin(char *s){
  int slen = strlen(s);
  if( slen > 3 && s[0] == '0' && s[1] == 'x' ) { // this is an hex string
    int spos=2; //skeep 0x
    while( spos < slen ){
      s[(int)(spos/2)-1] = ((hex2char(s[spos]) << 4) | (hex2char(s[spos+1]) & 0x0f));
      spos+=2;
    }
    return (int)(spos-4)/2+1;
  } else return slen;
}
int main(int argc, char *argv[]){
  char *search,*replace,*filename;
  int slen, rlen;
  int fd;
  int rval = -1;
  int fpos=0, spos=0;
  if( argc < 4 ){
    printf("%s p/s <searchstring> [<replacestring>] <file> \n"
           "In-place Search & Replace (ipsr)\n"
           " searchstring, replacestring can be either normal strings or\n"
           " hex encoded strings, beginning with 0x\n"
           " hex encoded string may contian dontcare '..' dots\n"
           " When using replace, make sure search & replace strings are of exact the same length\n\n"
           " Option: \n"
           " p = print adress of pattern\n"
           " s = silent\n"
           " v = verbose\n"
           " Copyright (C) 2007 qala@telenet.be, subspawn@gmail.com\n"
           " Modified by Jpascher\n"
           " ipsr comes with ABSOLUTELY NO WARRANTY. This is free software, and you are welcome\n"
           " to redistribute it under certain conditions\n"
           " See http://www.gnu.org/licenses/gpl.txt for more information\n",argv[0]);
    exit(-4);
  }
   search = argv[2];
   char buff[strlen(search)];
   for (spos=0; spos <= strlen(search); spos++) {
    buff[spos] = search[spos];
    //printf("Buffer as char %c.\n",(char)buff[spos]);
   }
   if( argc < 5 ){
    slen = str2bin(buff); //convert if string starts with 0x
    filename = argv[3];
    rlen = slen;
   } else {
    replace = argv[3];
    filename = argv[4];
    rlen = str2bin(replace);
   }
   if( rlen < slen || slen == 0 ){
    printf("Search string is %d long, but replacement pattern only %d.\n",slen,rlen);
    exit(-3);
   }
   if ( rlen > slen ) printf("WARNING: replacement string longer than searchstring. Will truncate.\n");
   if( (fd=open(filename,O_RDWR,0)) < 0){
    printf("Could not open file %s.\n",filename);
    exit(-2);
   } else {
    char c;
    while( read(fd, &c, 1) > 0 ){
      if (( search[spos*2+2] == '.' && search[spos*2+3] == '.') || c == buff[spos] ){
        //if ( search[spos*2+2] == '.' && search[spos*2+3] == '.') printf ("c: %c hex_pos:%d buff[spos]: %c str_pos: %d search: %s slen: %d\n", c, spos, buff[spos], spos*2+2, search, slen);
        spos++;
      } else {
       spos=0;
      }
      if( spos == slen ){
        if (strcasecmp(argv[1],"v")==0) printf("Found pattern at position: %d\n", fpos - spos);
        if (strcasecmp(argv[1],"p")==0) printf("%d\n", fpos - spos);
        if( argc == 5 ){
         lseek(fd, -1 * spos, 1);
         write(fd, replace, spos);
        }
        spos=0;
        rval=0;
      }
      fpos++;
    }
  }
  close(fd);
 return rval;
}
