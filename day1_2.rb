# ruby codegolf edition

x=->s{
n=i=0
s.scan(/(.)/){s[i+s.length/2]==$1&&n+=2*$1.to_i;i+=1}
n
}
