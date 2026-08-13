import { paraglideVitePlugin } from '@inlang/paraglide-js';
import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';
import { readFileSync } from 'node:fs';

function devPort() {
	try {
		const cwd = process.cwd();
		const line = readFileSync(`${process.env.HOME}/.config/dev-ports.yaml`, 'utf8')
			.split('\n')
			.find((l) => l.startsWith(`${cwd}: `));
		if (line) return Number(line.slice(cwd.length + 2));
	} catch {}
	return parseInt(process.env.DEV_PORT || '5173', 10);
}

export default defineConfig({
	server: {
		port: devPort()
	},
	plugins: [
		tailwindcss(),
		sveltekit(),
		paraglideVitePlugin({
			project: './project.inlang',
			outdir: './src/lib/paraglide',
			// "url" has to come first. localizeHref already produced /pt-br/… links
			// and the nav pointed at them, but the default strategy
			// (cookie → globalVariable → baseLocale) never read the locale back out
			// of the path: /pt-br/projects rendered in English with lang="en", and
			// the only thing that actually switched language was the cookie.
			strategy: ['url', 'cookie', 'preferredLanguage', 'baseLocale']
		})
	]
});
