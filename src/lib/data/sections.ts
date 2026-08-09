export type SectionType = 'cards' | 'timeline';

export interface Section {
	/** URL segment for this section, e.g. `/projects`. */
	key: string;
	/** i18n message key for the nav label, resolved as `nav_${key}`. */
	label: string;
	/** How the section renders: `cards` = about-style grid, `timeline` = experience list. */
	type: SectionType;
	/** Which data feature (folder under `src/lib/data/`) feeds this section. */
	feature: string;
}

/**
 * The sections that show up in the navigation. Add, remove or reorder entries
 * here to customize your portfolio — the route, the nav item and the page all
 * follow this list.
 */
export const sections = [
	{ key: 'about', label: 'nav_about', type: 'cards', feature: 'about' },
	{ key: 'projects', label: 'nav_projects', type: 'timeline', feature: 'projects' },
	{ key: 'experiences', label: 'nav_experiences', type: 'timeline', feature: 'experiences' },
	{ key: 'education', label: 'nav_education', type: 'timeline', feature: 'education' },
	{ key: 'achievements', label: 'nav_achievements', type: 'timeline', feature: 'achievements' },
	{ key: 'teaching', label: 'nav_teaching', type: 'timeline', feature: 'teaching' }
] as const satisfies readonly Section[];

export const sectionKeys: string[] = sections.map((s) => s.key);

export function getSection(key: string) {
	return sections.find((s) => s.key === key);
}
