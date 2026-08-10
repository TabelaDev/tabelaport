import { getLocaleData } from '$lib/data/paraglide-adapter';
import { getSection } from '$lib/data/sections';
import * as m from '$lib/paraglide/messages';

// The site shipped with no <title> and no description at all, so a shared link
// showed a bare URL and search results showed nothing useful. These are read
// from a $derived in the layout, never at module scope, so they follow the
// active locale.

export function siteTitle(): string {
	return getLocaleData<{ name: string }>('personal').name;
}

export function siteDescription(): string {
	return getLocaleData<{ summary: string }>('personal').summary;
}

/** Title for a route: "Section · Name" on a section, just the name at the root. */
export function pageTitle(pathname: string): string {
	const key = sectionKeyOf(pathname);
	const section = key ? getSection(key) : undefined;
	if (!section) return siteTitle();

	const label = (m as unknown as Record<string, () => string>)[section.label];
	return `${label ? plainLabel(label()) : section.key} · ${siteTitle()}`;
}

// Nav labels are written in method-call style (".projects()") to match the
// site's look. That reads as noise in a browser tab or a search result, so the
// decoration is dropped for the title while the translation is kept.
function plainLabel(label: string): string {
	return label.replace(/^\./, '').replace(/\(\)$/, '');
}

/** Last path segment, when it names one of the configured sections. */
export function sectionKeyOf(pathname: string): string | undefined {
	const segments = pathname.split('/').filter(Boolean);
	const last = segments.at(-1);
	return last && getSection(last) ? last : undefined;
}
