from commands import getstatusoutput
import time,sys,os,signal
import threading
import logging
log = logging.getLogger("zkill")
def checkrun_callback(checktime=None,callback=None):
    memory={}
    def decorate(func):
        def _memorit(*argv,**kwargs):
            callback_ret=[]
            for pid in  func(*argv,**kwargs):
                current_time=time.mktime(time.localtime())
                last_pid_time=memory.setdefault(pid,current_time)
                log.info("pid:%s,last:%s,now:%s,sub:%s"%(pid,last_pid_time,current_time,current_time-last_pid_time))
                if (current_time-last_pid_time)>checktime:
                    log.info("kill pid:%s"%pid)
                    callback_ret.append(callback(pid))
                    memory.pop(pid)
            return callback_ret
        return _memorit
    return decorate

def loop(sleeptime):
    def decorate(func):
        def _loop(*argvs,**kwargs):
            while True:
                try:
                    ret=func(*argvs,**kwargs)
                    log.info(str(ret))
                except Exception as e:
                    print e
                finally:
                    time.sleep(sleeptime)
        return _loop
    return decorate


def say_hi(pid):
    print "hi:",pid

def stop_pid(pid):
    return os.kill(int(pid),signal.SIGKILL)

@loop(10)
@checkrun_callback(checktime=10,callback=stop_pid)
def zombie_kill(zombie_name):
    SEP=','
    cmd="ps aux|grep '{name}'|grep -v 'grep'|awk 'BEGIN{{ORS=\"{ors}\"}}{{print $2}}'".format(ors=SEP,name=zombie_name)
    log.info(cmd)
    ret,pids=getstatusoutput(cmd)
    if ret!=0:
        print 'error:',pids
        return
    for pid in pids.split(SEP):
        if pid.strip():
            yield pid 
    
if __name__=="__main__":
    logging.basicConfig(level=logging.DEBUG,format='[%(asctime)s] [%(filename)s] [line:%(lineno)d] [%(levelname)s] [%(message)s]',
                        datefmt='%Y%m%d-%H:%M:%S',filename="zombie_kill.log")
    
    zombie_kill("ssh \-ND")
