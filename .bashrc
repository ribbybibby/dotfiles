# vim is cool
export EDITOR=vim

# bash completion
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# kc changes kubectl context
kc() {
  kubectl config use-context "$1"
}

# parse_git_branch retrieves the name of the git branch from pwd
parse_git_branch() {
     branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/')
     [[ -z ${branch} ]] && echo '(-)' || echo "${branch}"
}

# parse_kube_context echos the current kube context
parse_kube_context() {
    echo "($(kubectl config current-context))"
}

# kf derives kubectl arguments from PWD, assuming your code is arranged in the
# form:
#  <manifests>/<cluster>/<namespace>/manifests.yaml
kf() {
  cluster=""
  flags=""

  if [[ "${PWD}" == ${KUBERNETES_MANIFEST_PATH}* ]]; then
    if [[ $(grep "cluster: ${PWD##*/}" ${HOME}/.kube/config) ]]; then
      cluster=${PWD##*/}
      flags="--context=${PWD##*/}"
    else
      namespace=${PWD##*/}
      cluster=$(dirname ${PWD} | sed "s|^$KUBERNETES_MANIFEST_PATH/||g")

      if [[ -d "${KUBERNETES_MANIFEST_PATH}/${cluster}" ]]; then
        flags="${flags} --context=${cluster}"
      fi

      if [[ -d "${KUBERNETES_MANIFEST_PATH}/${cluster}/${namespace}" ]]; then
        flags="${flags} -n ${namespace}"
      fi
    fi
  fi

  echo "${flags}"
}

# k runs kubectl with arguments derived from PWD, assuming your code is
# arranged in the form:
#  <manifests>/<cluster>/<namespace>/manifests.yaml
k() {
  flags=$(kf)
  echo "kubectl ${flags} $@"
  kubectl ${flags} $@
}

# s runs stern with arguments derived from PWD, assuming your code is
# arranged in the form:
#  <manifests>/<cluster>/<namespace>/manifests.yaml
s() {
  flags=$(kf)
  echo "+ stern ${flags} $@"
  stern ${flags} $@
}

# a changes kubectl context before running argocd. The context is dervied from
# PWD, assuming your code is arranged in the form:
#  <manifests>/<cluster>/<namespace>/manifests.yaml
a() {
  if [[ "${PWD}" == ${KUBERNETES_MANIFEST_PATH}* ]]; then
    if [[ $(grep "cluster: ${PWD##*/}" ${HOME}/.kube/config) ]]; then
      context="${PWD##*/}"
    else
      cluster=$(dirname ${PWD} | sed "s|^$KUBERNETES_MANIFEST_PATH/||g")

      if [[ -d "${KUBERNETES_MANIFEST_PATH}/${cluster}" ]]; then
        context="${cluster}"
      fi
    fi
  fi

  if [[ ! -z "${context}" ]]; then
    current_context=$(kubectl config current-context)
    trap "kubectl config use-context ${current_context} > /dev/null" EXIT
    kubectl config use-context ${context} > /dev/null
  fi

  echo "+ argocd $@"
  argocd $@
}

# Make my terminal look fancy
export PS1="\[\033[38;5;11m\]\$(parse_git_branch)\[$(tput sgr0)\]\[\033[38;5;15m\]::\[\033[38;5;10m\]\$(parse_kube_context)\[$(tput sgr0)\]\[\033[38;5;15m\]::\[$(tput sgr0)\]\[\033[38;5;45m\]\u\[$(tput sgr0)\]\[\033[38;5;15m\] [\[$(tput sgr0)\]\[\033[38;5;104m\]\t\[$(tput sgr0)\]\[\033[38;5;15m\]] [\[$(tput sgr0)\]\[\033[38;5;79m\]\w\[$(tput sgr0)\]\[\033[38;5;15m\]]\n{\[$(tput sgr0)\]\[\033[38;5;202m\]\$?\[$(tput sgr0)\]\[\033[38;5;15m\]}::\\$ \[$(tput sgr0)\]"

# Sort path out
export PATH=$PATH:$HOME/go/bin
export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# The next line updates PATH for the Google Cloud SDK.
if [ -f ~/Downloads/google-cloud-sdk/path.bash.inc ]; then . ~/Downloads/google-cloud-sdk/path.bash.inc; fi

# The next line enables shell command completion for gcloud.
if [ -f ~/Downloads/google-cloud-sdk/completion.bash.inc ]; then . ~/Downloads/google-cloud-sdk/completion.bash.inc; fi

# Open newsboat
alias newsboat="docker run -it --rm -v $HOME/.newsboat:/root/.newsboat froulet/docker-newsboat"

# Source local additions from another file
source ~/.bashrc.local
