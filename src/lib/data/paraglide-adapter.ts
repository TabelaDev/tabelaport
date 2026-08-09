import personalEnUs from '$lib/data/personal/en.json';
import contactsEnUs from '$lib/data/contacts/en.json';
import aboutEnUs from '$lib/data/about/en.json';
import projectsEnUs from '$lib/data/projects/en.json';
import experiencesEnUs from '$lib/data/experiences/en.json';
import educationEnUs from '$lib/data/education/en.json';
import achievementsEnUs from '$lib/data/achievements/en.json';
import teachingEnUs from '$lib/data/teaching/en.json';
import personalPtBr from '$lib/data/personal/pt-br.json';
import contactsPtBr from '$lib/data/contacts/pt-br.json';
import aboutPtBr from '$lib/data/about/pt-br.json';
import projectsPtBr from '$lib/data/projects/pt-br.json';
import experiencesPtBr from '$lib/data/experiences/pt-br.json';
import educationPtBr from '$lib/data/education/pt-br.json';
import achievementsPtBr from '$lib/data/achievements/pt-br.json';
import teachingPtBr from '$lib/data/teaching/pt-br.json';
import { getLocale } from '$lib/paraglide/runtime';

const datasets = {
	personal: { en: personalEnUs, 'pt-br': personalPtBr },
	contacts: { en: contactsEnUs, 'pt-br': contactsPtBr },
	about: { en: aboutEnUs, 'pt-br': aboutPtBr },
	projects: { en: projectsEnUs, 'pt-br': projectsPtBr },
	experiences: { en: experiencesEnUs, 'pt-br': experiencesPtBr },
	education: { en: educationEnUs, 'pt-br': educationPtBr },
	achievements: { en: achievementsEnUs, 'pt-br': achievementsPtBr },
	teaching: { en: teachingEnUs, 'pt-br': teachingPtBr }
} as const;

export function getLocaleData<T>(feature: string): T {
	const locale = getLocale();
	const entries = (datasets as Record<string, Record<string, unknown>>)[feature];
	return (entries?.[locale] ?? entries?.['en']) as T;
}

export const personal = JSON.parse(JSON.stringify(getLocaleData('personal')));
export const contacts = JSON.parse(JSON.stringify(getLocaleData('contacts')));
