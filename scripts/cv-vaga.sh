#!/usr/bin/env bash
set -euo pipefail

# Gera um CV filtrado por indexadores (tags) para static/.
# Uso:
#   ./scripts/cv-vaga.sh <lang> <tags> <slug> [<summary>] [--exclude-tags X] [--exclude-ids X]
# Exemplo:
#   ./scripts/cv-vaga.sh pt "ia,ml,matematica,engenharia,python" icml ic-ml
#   ./scripts/cv-vaga.sh pt "dev,python,ia,web" nubank nubank --exclude-ids tabelarpgdk

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANG_INPUT="${1:?lang requerida (pt|en)}"
TAGS_INPUT="${2:?tags requeridas (separadas por virgula)}"
SLUG="${3:?slug requerido}"
shift 3

SUMMARY_INPUT=""
EXCLUDE_TAGS=""
EXCLUDE_IDS=""

while [ $# -gt 0 ]; do
	case "$1" in
		--exclude-tags)
			EXCLUDE_TAGS="${2:?valor requerido para --exclude-tags}"
			shift 2
			;;
		--exclude-ids)
			EXCLUDE_IDS="${2:?valor requerido para --exclude-ids}"
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
if [ -n "$EXCLUDE_IDS" ]; then
	ARGS+=(--input "exclude-ids=${EXCLUDE_IDS}")
fi

typst compile "$REPO_DIR/src/lib/data/cv.typ" "$REPO_DIR/static/${OUT}.pdf" "${ARGS[@]}"
echo "Gerado:  $REPO_DIR/static/${OUT}.pdf"
