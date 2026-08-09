import { getLocaleData } from '$lib/data/paraglide-adapter';
import { getLocale } from '$lib/paraglide/runtime';

export function personalName() {
	return getLocaleData<{ name: string }>('personal').name;
}

export function personalNameSlug() {
	return personalName().replace(/\s+/g, '_');
}

export function cvFilename(locale = getLocale()) {
	return `${personalNameSlug()}_CV_${locale}.pdf`;
}
