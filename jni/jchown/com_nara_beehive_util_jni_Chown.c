#include <jni.h>
#include "com_nara_beehive_util_jni_Chown.h"


#include <grp.h>
#include <pwd.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>

/*
 * C chown(const char *filename, uid_t owner, gid_t group)
 * file owner change.
 */
JNIEXPORT jboolean JNICALL Java_com_nara_beehive_util_jni_Chown_chown
  (JNIEnv * env, jobject this, jstring _filename, jint _uid, jint _gid)
{
    int rt = 1;
    char *filename;

    filename = (char *) (*env)->GetStringUTFChars(env, _filename, NULL);
    if(chown(filename, _uid, _gid) == -1) {
        rt = 0;
    }

    (*env)->ReleaseStringUTFChars(env, _filename, filename);

    return (jboolean)rt;
}
