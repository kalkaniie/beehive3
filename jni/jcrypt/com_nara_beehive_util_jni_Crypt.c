#include <jni.h>
#include "com_nara_beehive_util_jni_Crypt.h"

#include <sys/stat.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <crypt.h>

#include <time.h>
#include <pwd.h>

JNIEXPORT jboolean JNICALL Java_com_nara_beehive_util_jni_Crypt_verifyPassword
  (JNIEnv * env, jobject this, jstring _password, jstring _crypt_password)
{
    int rt = 1;
    char *crypt_password;
    char *password;

    password = (char *) (*env)->GetStringUTFChars(env, _password, NULL);
    crypt_password = (char *) (*env)->GetStringUTFChars(env, _crypt_password, NULL);



    if(strcmp(crypt(password, crypt_password), crypt_password) != 0) {
        rt = 0;
    }

    (*env)->ReleaseStringUTFChars(env, _crypt_password, crypt_password);
    (*env)->ReleaseStringUTFChars(env, _password, password);

    return (jboolean)rt;
}
