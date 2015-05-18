#!/bin/bash
#
# Draw graph of network round trip time.
#
# VERSION       :0.2
# DEPENDS       :apt-get install -y gnuplot5-nox feedgnuplot

[ -z "$*" ] && exit 1

ping -n -W 1 "$@" \
    | sed -u -n \
        -e 's|^From \(.\+\) icmp_seq\(=[0-9]\+\) Destination Net Unreachable$|64 bytes from \1 icmp_req\2 time=-100 ms|g' \
        -e 's|^.* bytes from .*: icmp_seq=\([0-9]\+\) .* time=\([0-9.]\+\) .*$|\1 \2|p' \
    | feedgnuplot --terminal 'dumb 120,40' --stream --points --lines -xlen 24 --set "xtics 10" \
        --domain -title "network round trip time (ms)" -xlabel "ICMP request"
