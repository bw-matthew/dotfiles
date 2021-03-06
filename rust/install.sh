set -eu

. "`dirname \`dirname \\\`readlink -f $0\\\`\``/script/lib.sh"

readonly CARGO_FOLDER="${HOME}/.cargo"

install () {
    install_rust           || return ${STATUS_ERROR}
    install_rust_formatter || return ${STATUS_ERROR}
    install_rust_linter    || return ${STATUS_ERROR}

    return ${STATUS_OK}
}

install_rust () {
    if [ ! -e "${CARGO_FOLDER}" ]; then
        curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path
    fi
}

install_rust_formatter () {
    if ! "${CARGO_FOLDER}/bin/rustup" component list | grep rustfmt >/dev/null; then
        "${CARGO_FOLDER}/bin/rustup" component add rustfmt
    fi
}

install_rust_linter () {
    if ! "${CARGO_FOLDER}/bin/rustup" component list | grep clippy >/dev/null; then
        "${CARGO_FOLDER}/bin/rustup" component add clippy
    fi
}

install
