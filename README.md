# pkgo

pkgo is my own pakage manager for my own repo

## Installation

Bash Version
```bash 
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/bash/pkg/pkgo_1.0_all.deb 
dpkg -i pkgo_1.0_all.deb 
rm pkgo_1.0_all.deb
```

C Version
```bash 
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/c/pkg/pkgo_1.0_all.deb 
dpkg -i pkgo_1.0_all.deb 
rm pkgo_1.0_all.deb 
```

Wrapper/Bash
```bash
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/wrapper/bash/pkg/pkgo.deb
dpkg -i pkgo.deb
rm pkgo.deb
```

Wrapper/C
```bash 
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/wrapper/c/pkg/pkgo.deb
dpkg -i pkgo.deb
rm pkgo.deb
```

### Custom
```bash
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/custom/pkg/pkgo.deb 
dpkg -i pkgo.deb 
rm pkgo.deb
```
Update 
```bash
wget https://raw.githubusercontent.com/termuxandlinux/pkgo/main/custom/pkg/pkgo_1.2_all.deb
dpkg -i pkgo*.deb
rm pkgo*.deb
```

Before you use the custom version setup the url
start
```bash
pkgo -- setup
echo 'https://termux-pkg.netlify.app/' >> $HOME/.url/url.txt
```

You can write same repo with
```bash
echo.'https://yourrepo.com/' >> $HOME/.url/url.txt
```

Pls use the same construct how the pkg list here.[PKG](https://github.com/ternuxandlinux/pkg)
