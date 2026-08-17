#!/usr/bin/env bash
set -euo pipefail

# Gera um CV filtrado por indexadores (tags) para static/.
# Uso:
#   ./scripts/cv-vaga.sh <lang> <tags> <slug> [<summary>] [flags...]
#
# Flags globais:
#   --exclude-tags X              exclui itens com qualquer tag de X
#
# Flags por seção (edu, exp, ach, proj, teaching):
#   --only-ids-{section} X       mostra SOMENTE os IDs de X na seção
#   --exclude-ids-{section} X    exclui os IDs de X da seção
#
# Exemplos:
#   ./scripts/cv-vaga.sh pt "ia,ml,python" icml ic-ml
#   ./scripts/cv-vaga.sh pt "" nubank nubank --only-ids-projects tabelainvest,tabelafin,tabelahub
#   ./scripts/cv-vaga.sh pt "dev,python" nubank nubank --exclude-ids-projects tabelarpgdk

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANG_INPUT="${1:?lang requerida (pt|en)}"
TAGS_INPUT="${2:-}"
SLUG="${3:?slug requerido}"
shift 3

SUMMARY_INPUT=""
EXCLUDE_TAGS=""
SECTION_FLAGS=()

while [ $# -gt 0 ]; do
	case "$1" in
		--exclude-tags)
			EXCLUDE_TAGS="${2:?valor requerido para --exclude-tags}"
			shift 2
			;;
		--only-ids-*|--exclude-ids-*)
			# Converte --flag-name pra key=value pro Typst
			SECTION_KEY="${1#--}"
			SECTION_FLAGS+=(--input "${SECTION_KEY}=${2:?valor requerido para $1}")
			shift 2
			;;
		*)
			SUMMARY_INPUT="$1"
			shift
			;;
	esac
done

OUT_LANG="${LANG_INPUT}"
if [ "$OUT_LANG" = "pt" ]; then
	OUT_LANG="pt-br"
fi

NAME_SLUG="$(node -e "console.log(JSON.parse(require('fs').readFileSync('${REPO_DIR}/src/lib/data/personal/en.json', 'utf8')).name.replace(/\s+/g, '_'))")"

OUT="${NAME_SLUG}_CV_${SLUG}_${OUT_LANG}"
ARGS=(--input "lang=${LANG_INPUT}" --input "tags=${TAGS_INPUT}")
if [ -n "$SUMMARY_INPUT" ]; then
	ARGS+=(--input "summary=${SUMMARY_INPUT}")
fi
if [ -n "$EXCLUDE_TAGS" ]; then
	ARGS+=(--input "exclude-tags=${EXCLUDE_TAGS}")
fi
ARGS+=("${SECTION_FLAGS[@]}")

typst compile "$REPO_DIR/src/lib/data/cv.typ" "$REPO_DIR/static/${OUT}.pdf" "${ARGS[@]}"
echo "Gerado:  $REPO_DIR/static/${OUT}.pdf"
