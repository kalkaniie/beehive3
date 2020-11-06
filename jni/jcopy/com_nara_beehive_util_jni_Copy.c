#include <jni.h>
#include "com_nara_beehive_util_jni_Copy.h"

#include <stdio.h>
/*
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
*/

/*
 * JNI copy(const char *oldname, const char *newname)
 * file copy
 */
JNIEXPORT jboolean JNICALL Java_com_nara_beehive_util_jni_Copy_copy
  (JNIEnv * env, jobject this, jstring _oldname, jstring _newname)
{
    FILE *fin;
    FILE *fout;
//    int fin;
//    int fout;
    char *oldname;
    char *newname;
    int rt = 0;
    char line[8192];
    int count = 8192;
    int nread = 0;

    oldname = (char *) (*env)->GetStringUTFChars(env, _oldname, NULL);
    newname = (char *) (*env)->GetStringUTFChars(env, _newname, NULL);


/*
    fin = open(oldname, O_RDONLY);

    if (fin == -1) {
          // error
         return 0;
    }

    fout = open(newname, O_WRONLY|O_CREAT|O_EXCL);
    if (fout == -1) {
          // error
          return 0;
    }


    while((nread = read(fin, line, count)) > 0) {
        write(fout, line, nread);
    }
    rt = 1;


    close(fout);
    close(fin);
*/

    fin = fopen(oldname, "r");
    if(fin != NULL) {
        fout = fopen(newname, "w");
        if(fout != NULL) {
            while((nread = fread(line, 1, count, fin)) != 0) {
                fwrite(line, 1, nread, fout);
            }
            rt = 1;
            fflush(fout);
            fclose(fout);
        }
        fclose(fin);
    }
    

    (*env)->ReleaseStringUTFChars(env, _oldname, oldname);
    (*env)->ReleaseStringUTFChars(env, _newname, newname);

    return (jboolean)rt;
}
