# dotfiles
My setup

## Other configuration

### mkcert

Generate certificate on **Windows**. On WSL run:

```
cp -r /mnt/c/Users/<User>/AppData/Local/mkcert /home/sante/.local/share
chmod 600 ~/.local/share/mkcert/rootCA-key.pem
mkcert -install
```
