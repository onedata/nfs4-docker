#!/usr/bin/env bash
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

function start()
{

    # prepare /etc/exports

    # Root of all the exports
    # fsid=0: needed for NFSv4  
    echo "$NFS_ROOT_DIR *(ro,fsid=0,crossmnt,nohide,async,insecure,no_root_squash,no_subtree_check)" >> /etc/exports
    for i in "$@"; do
        echo "$i *(rw,async,nohide,insecure,no_root_squash,no_subtree_check)" >> /etc/exports
        # move index.html to here
        /bin/cp /tmp/index.html $i/ 
        chmod 644 $i/index.html
        echo "${1#/}" > $i/"test_file_for_share_${1//\//_}.txt"
        echo "Serving $i"
    done

    # start rpcbind if it is not started yet
    /usr/sbin/rpcinfo 127.0.0.1 > /dev/null; s=$?
    if [ $s -ne 0 ]; then
    echo "Starting rpcbind"
    /sbin/rpcbind -w
    fi

    mount -t nfsd nfds /proc/fs/nfsd

    # -N 4.x: enable NFSv4
    # -V 3: disable NFSv3
    /usr/sbin/rpc.mountd -N 2 -N 3 -V 4 -V 4.1

    /usr/sbin/exportfs -r
    # -G 10 to reduce grace time to 10 seconds (the lowest allowed)
    # rpc.nfsd on ubuntu does not have -G flag, on centos it's ok
    /usr/sbin/rpc.nfsd -N 2 -N 3 -V 4 -V 4.1 2
    /sbin/rpc.statd --no-notify
    echo "NFS started"
}

function stop()
{
    echo "Stopping NFS"

    /usr/sbin/rpc.nfsd 0
    /usr/sbin/exportfs -au
    /usr/sbin/exportfs -f

    kill $( pidof rpc.mountd )
    umount /proc/fs/nfsd
    echo > /etc/exports
    exit 0
}

trap stop TERM

start "$@"

# Ugly hack to do nothing and wait for SIGTERM
while true; do
    sleep 5
done