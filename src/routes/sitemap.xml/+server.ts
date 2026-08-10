import type { RequestHandler } from './$types';
import { sectionKeys } from '$lib/data/sections';
import { locales, localizeHref } from '$lib/paraglide/runtime';

// Every route in both locales, cross-linked with xhtml:link alternates so a
// crawler treats the pt-br and en versions as the same page rather than as
// duplicates. Generated from the same `sections` list the nav and the routes
// read, so adding a section never leaves the sitemap behind.
export const GET: RequestHandler = ({ url }) => {
	const paths = ['/', ...sectionKeys.map((key) => `/${key}`)];

	const entries = paths
		.flatMap((path) =>
			locales.map((locale) => {
				const href = new URL(localizeHref(path, { locale }), url.origin).href;
				const alternates = locales
					.map(
						(alt) =>
							`\n\t\t<xhtml:link rel="alternate" hreflang="${alt}" href="${
								new URL(localizeHref(path, { locale: alt }), url.origin).href
							}" />`
					)
					.join('');
				return `\t<url>\n\t\t<loc>${href}</loc>${alternates}\n\t</url>`;
			})
		)
		.join('\n');

	const body = `<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9" xmlns:xhtml="http://www.w3.org/1999/xhtml">
${entries}
</urlset>
`;

	return new Response(body, {
		headers: {
			'content-type': 'application/xml; charset=utf-8',
			'cache-control': 'public, max-age=3600'
		}
	});
};
