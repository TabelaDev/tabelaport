import { paraglideVitePlugin } from '@inlang/paraglide-js';
import tailwindcss from '@tailwindcss/vite';
import { sveltekit } from '@sveltejs/kit/vite';
import { defineConfig } from 'vite';

export default defineConfig({
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
