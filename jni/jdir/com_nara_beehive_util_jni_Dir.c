#include <jni.h>
#include "com_nara_beehive_util_jni_Dir.h"

#include <unistd.h>
#include <stdio.h>
#include <dirent.h>
#include <string.h>
#include <sys/stat.h>

JNIEXPORT jobjectArray JNICALL Java_com_nara_beehive_util_jni_Dir_list
  (JNIEnv *env, jobject this, jstring _dir, jint size)
{
    jobjectArray ret;
    DIR *dp;
    struct dirent *entry;
    struct stat statbuf;
    char *dir;

    int max_list = 1000;
    int max_length = 60;
    char list[max_list][max_length];

    int count = 0;
    int index = 0;

    jclass cls = (*env)->FindClass(env, "java/lang/String");
    dir = (char *)(*env)->GetStringUTFChars(env, _dir, NULL);

    if((dp = opendir(dir)) == NULL) {
        return NULL;
    }

    while((entry = readdir(dp)) != NULL) {
        stat(entry->d_name, &statbuf);
        if(strcmp(".", entry->d_name) == 0 ||
           strcmp("..", entry->d_name) == 0) {
            continue;
        }
        if(size <= count || max_list <= count) {
            break;
        }
        snprintf(list[count++], max_length, "%s", entry->d_name);
    }
    closedir(dp);


    (*env)->ReleaseStringUTFChars(env, _dir, dir);
    if(count == 0) {
        return NULL;
    }

    ret = (*env)->NewObjectArray(env,
          count,
          cls,
          (*env)->NewStringUTF(env, ""));

    for(index = 0; index < count; index++) {
        (*env)->SetObjectArrayElement(env, ret,
            index,
            (*env)->NewStringUTF(env, list[index]));
    }

    return ret;
}
