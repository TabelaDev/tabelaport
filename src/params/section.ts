import type { ParamMatcher } from '@sveltejs/kit';
import { sectionKeys } from '$lib/data/sections';

export const match = ((param: string) => sectionKeys.includes(param)) satisfies ParamMatcher;
