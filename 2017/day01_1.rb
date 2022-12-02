# ruby codegolf edition

x=->s{
s[1]&&s<<s[0]
n=0
s.scan(/(.)(?=\1)/){n+=eval $1}
n
}
