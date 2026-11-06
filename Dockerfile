# syntax=docker/dockerfile:1
# Entorno de practicas de Git - 1o DAW
FROM debian:stable-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends git nano less ca-certificates bash-completion \
 && rm -rf /var/lib/apt/lists/*

RUN git config --system init.defaultBranch main \
 && git config --system core.editor nano \
 && git config --system --add safe.directory '*' \
 && git config --global credential.helper 'store --file /tmp/.git-credentials'

ENV HOME=/practica
ENV LANG=C.UTF-8
WORKDIR /practica

RUN cat > /etc/practica.bashrc <<'EOF'
# Autocompletado con Tab (comandos, ramas, etiquetas...)
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi
bind 'set show-all-if-ambiguous on'
bind 'set completion-ignore-case on'
bind 'set colored-stats on'

# Prompt: carpeta actual y rama en verde
rama() { local b; b=$(git branch --show-current 2>/dev/null); [ -n "$b" ] && echo " ($b)"; }
PS1='\[\e[1;32m\]\W$(rama)\[\e[0m\] \$ '

# Historial
shopt -s histappend
export HISTSIZE=5000 HISTFILESIZE=5000
PROMPT_COMMAND="history -a"

# Atajos
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'

echo 'Entorno de Git listo'
EOF

CMD ["bash", "--rcfile", "/etc/practica.bashrc"]