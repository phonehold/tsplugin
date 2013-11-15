#/bin/bash

g_plugin()
{
cat >example.c <<EOF
#include <stdio.h>
#include <ts/ts.h>

char * name= "helloword";
char * email = "yingcai.huang@verycloud.cn";
char * vendor = "VeryCDN";

static void
hander_dns(TSHttpTxn txnp, TSCont contp){
        //do nothing
}

static void
hander_response(TSHttpTxn txnp, TSCont contp){
        //do nothing
}

static int
do_work(TSCont contp, TSEvent event, void *edata){
        TSHttpTxn txnp = (TSHttpTxn) edata;
        switch (event){
                case TS_EVENT_HTTP_OS_DNS:
                        hander_dns(txnp,contp);
                        return 0;
                case TS_EVENT_HTTP_SEND_RESPONSE_HDR:
                        hander_response (txnp,contp);
                        return 0;
                default:
                        TSDebug (name, "The Fream devel\n" );
                        break;
        }
        return 0;
}

void TSPluginInit(int argc, const char *argv[]){
        TSPluginRegistrationInfo info;
        info.plugin_name= name;
        info.support_email=email;
        info.vendor_name = vendor;
        TSCont contp;
        contp = TSContCreate(do_work, NULL);
        TSHttpHookAdd (TS_HTTP_OS_DNS_HOOK, contp);
}
EOF
}

print_usage()
{
        cat << EOF
        Usage: `basename $0`
                 -h  print help
                 -g  Create Global plugin example code
                 -r  Create Remap plguin example code
EOF
}

if [ $# != 1 ] ; then 
        print_usage
        exit 1; 
fi
while getopts grh name
do
    case $name in
    g)    g_plugin;;
    r)    bflag=1;;
    h)  print_usage;;
    *) print_usage 
        exit 2;;
    esac
done