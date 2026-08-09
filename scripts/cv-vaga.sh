#!/usr/bin/env bash
set -euo pipefail

# Gera um CV filtrado por indexadores (tags) para static/.
# Uso:
#   ./scripts/cv-vaga.sh <lang> <tags> <slug> [<summary>]
# Exemplo:
#   ./scripts/cv-vaga.sh pt "ia,ml,matematica,engenharia,python" icml ic-ml

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LANG_INPUT="${1:?lang requerida (pt|en)}"
TAGS_INPUT="${2:?tags requeridas (separadas por virgula)}"
SLUG="${3:?slug requerido}"
SUMMARY_INPUT="${4:-}"

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

typst compile "$REPO_DIR/src/lib/data/cv.typ" "$REPO_DIR/static/${OUT}.pdf" "${ARGS[@]}"
echo "Gerado:  $REPO_DIR/static/${OUT}.pdf"
