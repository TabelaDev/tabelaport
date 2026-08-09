#!/usr/bin/env node
// Generates CV PDFs with the name from src/lib/data/personal/en.json.
//
// Usage (from the repo root):
//   node scripts/cv.mjs                 # all 6 profile x lang combos
//   node scripts/cv.mjs dev en          # single combo
//   node scripts/cv.mjs watch dev pt    # typst watch (single combo)
import { execSync } from 'node:child_process';
import { readFileSync } from 'node:fs';
import { resolve } from 'node:path';

const repoDir = process.cwd();
const [mode, profileArg = 'dev', langArg = 'en'] = process.argv.slice(2);

const personal = JSON.parse(
	readFileSync(resolve(repoDir, 'src/lib/data/personal/en.json'), 'utf8')
);
const nameSlug = personal.name.replace(/\s+/g, '_');

const profiles = ['dev', 'tutor', 'all'];
const langs = [
	{ typst: 'en', file: 'en' },
	{ typst: 'pt', file: 'pt-br' }
];

function compile(profile, lang) {
	const outName = `${nameSlug}_CV_${lang.file}.pdf`;
	const cmd = [
		'typst',
		mode === 'watch' ? 'watch' : 'compile',
		resolve(repoDir, 'src/lib/data/cv.typ'),
		resolve(repoDir, 'static', outName),
		`--input=lang=${lang.typst}`,
		`--input=profile=${profile}`
	].join(' ');
	console.log(`> ${cmd}`);
	execSync(cmd, { stdio: 'inherit' });
}

if (mode === 'watch') {
	compile(profileArg, langs.find((l) => l.typst === langArg) ?? langs[1]);
} else if (mode === 'dev' || mode === 'tutor' || mode === 'all') {
	compile(mode, langs.find((l) => l.typst === langArg) ?? langs[0]);
} else {
	for (const profile of profiles) {
		for (const lang of langs) {
			compile(profile, lang);
		}
	}
}
